//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Isaiah Ojo on 12/23/22.
//

import Foundation
import CoreData
import UIKit
/// Object that represents a singlet API call
final class RMRequest {
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    /// Desired endpoint
    let endpoint: RMEndpoint

    /// Path components for API, if any
    private let pathComponents: [String]

    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]

    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue

        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }

        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")

            string += argumentString
        }

        return string
    }

    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }

    /// Desired http method
    public let httpMethod = "GET"

    // MARK: - Public

    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of Path components
    ///   - queryParameters: Collection of query parameters
    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }


    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(
                    rawValue: endpointString
                ) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")

                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })

                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}

// MARK: - Request convenience

extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
    static let listEpisodesRequest = RMRequest(endpoint: .episode)
    static let listLocationsRequest = RMRequest(endpoint: .location)
}

func fetchCharacters() {
    // Assuming you have a Core Data stack setup
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    // Fetch the data from the API
    let request = RMRequest.listCharactersRequests
    let task = URLSession.shared.dataTask(with: request.url!) { (data, response, error) in
        if let error = error {
            print("Error fetching characters: \(error)")
            return
        }
        
        guard let data = data else {
            print("No data returned from character fetch")
            return
        }
        
        do {
            // Parse the JSON data
            let decoder = JSONDecoder()
            let characters = try decoder.decode([CoreDataCharacter].self, from: data)
            
            container.performBackgroundTask { context in
                for character in characters {
                    // Avoid duplicate entries
                    let fetchRequest: NSFetchRequest<CoreCharacter> = CoreCharacter.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", character.id)
                    
                    if let existingCharacter = try? context.fetch(fetchRequest).first {
                        // Update existing character if needed
                    } else {
                        // Create new CoreCharacter entity
                        let entity = CoreCharacter(context: context)
                        entity.name = character.name
                        entity.id = Int64(character.id)
                        // ... set the other properties
                        
                        // Download the image asynchronously
                        if let url = URL(string: character.image) {
                            URLSession.shared.dataTask(with: url) { (data, response, error) in
                                if let data = data {
                                    DispatchQueue.main.async {
                                        entity.image = data
                                    }
                                }
                            }.resume()
                        }
                    }
                }
                
                // Save the context
                do {
                    try context.save()
                } catch {
                    print("Failed to save character: \(error)")
                }
            }
        } catch {
            print("Error decoding character data: \(error)")
        }
    }
    
    task.resume()
}

func checkDataSaved() {
    // Assuming you have a Core Data stack setup
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    // Create a fetch request for the CharacterEntity
    let fetchRequest: NSFetchRequest<CoreCharacter> = CoreCharacter.fetchRequest()
    
    do {
        // Attempt to execute the fetch request
        let fetchedCharacters = try container.viewContext.fetch(fetchRequest)
        
        // Check if any characters were fetched
        if fetchedCharacters.isEmpty {
            print("No characters found in CoreData")
        } else {
            for character in fetchedCharacters {
                print("Fetched character with name: \(character.name ?? ""), id: \(character.id)")
            }
        }
    } catch {
        // Handle any errors that occurred while fetching
        print("Failed to fetch characters: \(error)")
    }
}
