//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Isaiah Ojo on 12/24/22.
//

import UIKit
import CoreData


/// Single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLabel, statusLabel, favoriteButton) // Added favoriteButton here
        addConstraints()
        setUpLayer()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),

            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),

            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

                    // Constraints for favoriteButton
                    favoriteButton.widthAnchor.constraint(equalToConstant: 44),
                    favoriteButton.heightAnchor.constraint(equalToConstant: 44),
                    favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                    favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                ])
    }
    
    // Add a button for favoriting a character
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false // Added this line
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return button
    }()
       // Other properties and methods...

    @objc private func didTapFavoriteButton() {
        let context = CoreDataStack.shared.persistentContainer.viewContext

        if favoriteButton.tintColor == UIColor.systemRed {
            // Unfavorite character
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = UIColor.gray

            // Fetch the character from CoreData
            let fetchRequest: NSFetchRequest<CoreCharacter> = CoreCharacter.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", self.nameLabel.text ?? "")

            do {
                let fetchedCharacters = try context.fetch(fetchRequest)

                // If the character exists in CoreData, delete it
                if let character = fetchedCharacters.first {
                    context.delete(character)
                }
            } catch let error {
                print("Failed to fetch character: \(error)")
            }
        } else {
            // Favorite character
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = UIColor.systemRed

            // Create a new Character entity
            let character = CoreCharacter(context: context)
            character.name = self.nameLabel.text
            if let image = self.imageView.image {
                character.image = image.pngData() // Save the image as Data
            }
            // Set the rest of the attributes...
            // character.species = self.speciesLabel.text
            // character.type = self.typeLabel.text
            // character.url = self.urlLabel.text
            // ... and so on for all the attributes you have
        }

        // Save the context
        do {
            try context.save()
        } catch let error {
            print("Failed to save context: \(error)")
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }

    

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }

    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
