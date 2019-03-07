//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    private var isFinishedTypingNumber: Bool = true
    
    private var displayValue: Double {
        get {
            guard let value = Double(displayLabel.text!) else {
                fatalError("Cannot convert displayLabel.text to a number")
            }
            
            return value
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    private var calculator = CalculatorLogic()
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        //What should happen when a non-number button is pressed
        
        isFinishedTypingNumber = true
        
        calculator.setNumber(displayValue)
    
        if let calcButton = sender.currentTitle {
           
            if let value = calculator.calculate(symbol: calcButton) {
                displayValue = value
            }
        
        }
    }

    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        //What should happen when a number is entered into the keypad
        
        if let numButton = sender.currentTitle {
            if isFinishedTypingNumber {
                displayLabel.text = numButton
                isFinishedTypingNumber = false
            }else{
                if numButton == "." {
                    let isInt = floor(displayValue) == displayValue
                    
                    if !isInt {
                        return
                    }
                }
                
                displayLabel.text = displayLabel.text! + numButton
            }
        }
    }

}
