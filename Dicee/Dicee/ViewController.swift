//
//  ViewController.swift
//  Dicee
//
//  Created by Anand Batjargal on 2/7/19.
//  Copyright © 2019 anandbatjargal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var randomDiceIndex1 = 0
    var randomDiceIndex2 = 0
    let diceArray = ["dice1", "dice2", "dice3","dice4", "dice5", "dice6"]
    
    @IBOutlet weak var diceOne: UIImageView!
    @IBOutlet weak var diceTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDiceImages()
    }
    
    @IBAction func rollDice(_ sender: Any) {
        updateDiceImages()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        updateDiceImages()
    }
    
    func updateDiceImages() {
        randomDiceIndex1 = Int.random(in: 0...5)
        randomDiceIndex2 = Int.random(in: 0...5)
        
        diceOne.image = UIImage(named: diceArray[randomDiceIndex1])
        diceTwo.image = UIImage(named: diceArray[randomDiceIndex2])
    }
}

