//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Isaiah Ojo on 12/28/22.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case apiReference
    case viewCode

    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation/#get-a-single-episode")
        case .viewCode:
            return URL(string: "https://github.com/LafyOjo/RickAndMortyiOSApp-main")
        }
    }

    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .apiReference:
            return "API Reference"
        case .viewCode:
            return "View App Code"
        }
    }

    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .apiReference:
            return .systemOrange
        case .viewCode:
            return .systemPink
        }
    }

    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
