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
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        label.text = pokemon.name
    }
    
    @IBAction func onBackPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
