//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Ilya Shaisultanov on 1/17/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Segment: Int {
        case Bio = 0
        case Moves = 1
    }
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    @IBOutlet weak var evoStack: UIStackView!
    @IBOutlet weak var bioStack: UIStackView!
    
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "onNextEvoTap:")
        //tapGesture.delegate = self
        
        nextEvoImg.userInteractionEnabled = true
        nextEvoImg.addGestureRecognizer(tapGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.hidden = true
        tableView.tableFooterView = UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let move = pokemon.moves[indexPath.row]
        let name = move["name"] as! String
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("moveCell") as? MoveCell {
            cell.configureCell(move)
            return cell
        } else {
            let cell = MoveCell()
            cell.configureCell(move)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("MoveListVC", sender: indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let movesVC = segue.destinationViewController as? MoveListVC {
            movesVC.pokemon = pokemon
            movesVC.moveIndex = sender as? Int
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.moves.count
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
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onNextEvoTap(sender: AnyObject) {
        let nextPokemon = Pokemon(name: pokemon.nextEvolutionName, pokedexId: Int(pokemon.nextEvolutionId)!)
        
        nextPokemon.downloadPokemonDetails { () -> () in
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let pokeDetailVC = storyboard.instantiateViewControllerWithIdentifier("detailVC") as! PokemonDetailVC
            
            pokeDetailVC.pokemon = nextPokemon
            pokeDetailVC.modalTransitionStyle = .CrossDissolve
            
            self.presentViewController(pokeDetailVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onSwitch(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == Segment.Bio.rawValue {
            evoStack.hidden = false
            bioStack.hidden = false
            tableView.hidden = true
        } else {
            evoStack.hidden = true
            bioStack.hidden = true
            tableView.hidden = false
        }
    }
}
