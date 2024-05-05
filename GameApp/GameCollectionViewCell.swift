//
//  GameCollectionViewCell.swift
//  GameApp
//
//  Created by Rizki Siraj on 04/05/24.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    
    func setup(with game: Game) {
        gameImageView.image = game.image
        gameTitle.text = game.name
        gameRating.text = "\(game.rating)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        gameDate.text = "\(dateFormatter.string(from: game.released))"
    }
}
