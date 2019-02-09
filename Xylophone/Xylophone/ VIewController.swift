//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    let notesArray = ["note1", "note2", "note3", "note4", "note5", "note6", "note7"]
    var soundUrl: URL?
    var audioPlayer : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notePressed(_ sender: UIButton) {
        let fileName = notesArray[sender.tag - 1]
        playSound(soundFileName: fileName)
    }
    
    func playSound(soundFileName: String) {
        soundUrl = Bundle.main.url(forResource: soundFileName, withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl!)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let error as Error {
            print(error.localizedDescription)
        }
    }

}

