//
//  FavoritesTableViewCell.swift
//  RickAndMorty
//
//  Created by Isaiah Ojo on 26/05/2023.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewCell: FavoritesTableViewCell!
    
    @IBOutlet weak var imagePhoto: UIImageView!
    
    @IBOutlet weak var labelOne: UILabel!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
