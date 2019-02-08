//
//  ViewController.swift
//  Dicee
//
//  Created by Anand Batjargal on 2/7/19.
//  Copyright © 2019 anandbatjargal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var randomDiceIndex1 = 1
    var randomDiceIndex2 = 1
    let diceArray = ["dice1", "dice2", "dice3","dice4", "dice5", "dice6"]
    
    @IBOutlet weak var diceOne: UIImageView!
    @IBOutlet weak var diceTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func rollDice(_ sender: Any) {
        randomDiceIndex1 = Int.random(in: 0...5)
        randomDiceIndex2 = Int.random(in: 0...5)
        
        diceOne.image = UIImage(named: diceArray[randomDiceIndex1])
        diceTwo.image = UIImage(named: diceArray[randomDiceIndex2])
    }
}

