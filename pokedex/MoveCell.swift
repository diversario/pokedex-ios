//
//  MoveCell.swift
//  pokedex
//
//  Created by Ilya Shaisultanov on 1/20/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(move: [String: AnyObject]) {
        moveLabel.text = move["name"] as! String
        attackLabel.text = "power: \(move["power"]!)"
        accuracyLabel.text = "accuracy: \(move["accuracy"]!)"
    }
}
