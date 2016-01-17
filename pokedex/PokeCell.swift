//
//  PokeCell.swift
//  pokedex
//
//  Created by Ilya Shaisultanov on 1/16/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell (pokemon: Pokemon) {
        self.pokemon = pokemon
        
        self.nameLabel.text = self.pokemon.name.capitalizedString
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
