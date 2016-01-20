//
//  MoveListVC.swift
//  pokedex
//
//  Created by Ilya Shaisultanov on 1/20/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit

class MoveListVC: UIViewController {
    var pokemon: Pokemon!
    var moveIndex: Int!
    
    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var moveName: UILabel!
    @IBOutlet weak var accuracy: UILabel!
    @IBOutlet weak var power: UILabel!
    @IBOutlet weak var desc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        pokeName.text = pokemon.name
        
        let move = pokemon.moves[moveIndex]
        
        moveName.text = move["name"] as? String
        accuracy.text = String(move["accuracy"] as! Int)
        power.text = String(move["power"] as! Int)
        desc.text = move["description"] as? String
    }

    @IBAction func onBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
