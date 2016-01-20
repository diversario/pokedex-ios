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
    
    var tapGesture: UITapGestureRecognizer!
    
    var history: [Pokemon]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "onNextEvoTap:")
        //tapGesture.delegate = self
        
        history = [Pokemon]()
        
        nextEvoImg.userInteractionEnabled = true
        nextEvoImg.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateUI()
    }
    
    func updateUI(){
        nameLabel.text = pokemon.name.capitalizedString
        mainImg.image = UIImage(named: String(pokemon.pokedexId))
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
            nextEvoImg.hidden = false
        }
    }
    
    @IBAction func onBackPressed(sender: UIButton) {
        if !history.isEmpty {
            pokemon = history.popLast()
            updateUI()
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func onNextEvoTap(sender: AnyObject) {
        let nextPokemon = Pokemon(name: pokemon.nextEvolutionName, pokedexId: Int(pokemon.nextEvolutionId)!)
        self.history.append(self.pokemon)
        
        nextPokemon.downloadPokemonDetails { () -> () in
            self.pokemon = nextPokemon
            self.updateUI()
        }
    }
}
