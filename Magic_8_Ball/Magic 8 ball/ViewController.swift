//
//  ViewController.swift
//  Magic 8 ball
//
//  Created by Anand Batjargal on 2/8/19.
//  Copyright © 2019 anandbatjargal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var ballImageIndex = 0
    let ballArray = ["ball1", "ball2", "ball3", "ball4", "ball5"]
    @IBOutlet weak var magicBallImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBallImage()
    }
    
    @IBAction func askButtonPressed(_ sender: Any) {
        updateBallImage()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        updateBallImage()
    }
    
    func updateBallImage() {
        ballImageIndex = Int.random(in: 0...4)
        magicBallImageView.image = UIImage(named: ballArray[ballImageIndex])
    }


}

