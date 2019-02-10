//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let allQuestions = QuestionBank()
    var numberOfQuestions : Int = 0
    var pickedAnswer: Bool = false
    var questionIndex: Int = 0
    var score: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfQuestions = allQuestions.list.count
        nextQuestion()
    }

    @IBAction func answerPressed(_ sender: AnyObject) {
        if(sender.tag == 1){
            pickedAnswer = true
        }else{
            pickedAnswer = false
        }
        
        checkAnswer()
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(score)"
        
        progressLabel.text = "\(questionIndex + 1)/" + "\(numberOfQuestions)"
        
        progressBar.frame.size.width = (view.frame.size.width / CGFloat(numberOfQuestions)) * CGFloat( questionIndex + 1)
    }
    

    func nextQuestion() {
        if(questionIndex < allQuestions.list.count){
            questionLabel.text = allQuestions.list[questionIndex].questionText
            updateUI()
        }else{
            let alert = UIAlertController(title: "Your score is \(score)/" + "\(numberOfQuestions * 100)", message: nil, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Play Again", style: .default, handler: { (UIAlertAction) in
                self.startOver()
            })
            
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkAnswer() {
        let correctAnswer = allQuestions.list[questionIndex].answer
        
        if(correctAnswer == pickedAnswer){
            ProgressHUD.showSuccess("Correct!")
            score += 100
        }else{
            ProgressHUD.showError("Wrong!")
        }
        
        questionIndex += 1
        nextQuestion()
    }
    
    
    func startOver() {
        questionIndex = 0
        score = 0
        
        nextQuestion()
    }
}
