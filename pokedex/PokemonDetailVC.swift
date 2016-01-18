//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Ilya Shaisultanov on 1/17/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    var pokemon: Pokemon!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        label.text = pokemon.name
    }
}
