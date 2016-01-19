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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var evoLabelStack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        nameLabel.text = pokemon.name
        mainImg.image = UIImage(named: String(pokemon.pokedexId))
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }
    
    func updateUI(){
        descLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenceLabel.text = pokemon.defense
        attackLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        pokedexLabel.text = String(pokemon.pokedexId)
        currentEvoImg.image = mainImg.image
        
        if pokemon.nextEvolutionId == "" {
            evoLabel.text = "No evolutions"
            nextEvoImg.hidden = true
        } else {
            evoLabel.text = "Next evolution: \(pokemon.nextEvolutionName)"
            
            if pokemon.nextEvolutionLevel != "" {
                evoLabel.text = "\(evoLabel.text!) at level \(pokemon.nextEvolutionLevel)"
            }
            
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
        }
    }
    
    @IBAction func onBackPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
