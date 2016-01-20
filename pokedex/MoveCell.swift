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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(name: String) {
        moveLabel.text = name
    }
}
