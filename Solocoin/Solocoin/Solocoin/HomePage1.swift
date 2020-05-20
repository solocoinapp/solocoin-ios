//
//  HomePage1.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/26/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class HomePage1: UIViewController {
    
    //MARK: - IBOUTLETS

    @IBOutlet var languageOptions: [UIButton]!

    @IBOutlet weak var dailyWeekly: UISegmentedControl!
    
    //MARK: Question/Answer

    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var answer1: UIButton!
    
    @IBOutlet weak var answer2: UIButton!
    
    @IBOutlet weak var answer3: UIButton!
    
    @IBOutlet weak var answer4: UIButton!
    
    //MARK: - DATA
    
    var answerButtons: [UIButton]!
    
    var dailyCorrectAnswer: UIButton!
    
    var weeklyCorrectAnswer: UIButton!
    
    //MARK: - FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerButtons = [answer1, answer2, answer3, answer4]

        answerLayouts(answer: answer1)
        answerLayouts(answer: answer2)
        answerLayouts(answer: answer3)
        answerLayouts(answer: answer4)
        
        dailyCorrectAnswer = answer1
        weeklyCorrectAnswer = answer2
        
        dailyWeekly.selectedSegmentIndex = 0
        
        let font = UIFont.systemFont(ofSize: 23)
        dailyWeekly.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
    }
    
    func setCorrectAnswer() {
    answerButtons.forEach {
        // Reset the border on each button
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        // Reset the tag on each button
        $0.tag = 0
    }
        answerButtons[1].tag = 1
    }
    
    
    func answerLayouts(answer: UIButton) {
        answer.layer.borderColor = UIColor.systemGray4.cgColor
        answer.layer.borderWidth = 1.0
        answer.layer.cornerRadius = 5.0
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func questionChanged(_ sender: Any) {
        
        if dailyWeekly.selectedSegmentIndex == 0 {
            question.text = "What is the best way to minimize the risk of coronavirus?"
            answer1.setTitle("  A. Social Distancing", for: .normal)
            answer2.setTitle("  B. Meeting small, regular groups", for: .normal)
            answer3.setTitle("  C. Continue as usual", for: .normal)
            answer4.setTitle("  D. No clue", for: .normal)
            
            answerLayouts(answer: answer1)
            answerLayouts(answer: answer2)
            answerLayouts(answer: answer3)
            answerLayouts(answer: answer4)
        }
        
        if dailyWeekly.selectedSegmentIndex == 1 {
            question.text = "How long should I wash my hands?"
            answer1.setTitle("  A. Around 5 seconds with soap", for: .normal)
            answer2.setTitle("  B. Around 20 seconds with soap", for: .normal)
            answer3.setTitle("  C. For 15 seconds without soap", for: .normal)
            answer4.setTitle("  D. I shouldn't - it wastes water", for: .normal)
            
            
            answerLayouts(answer: answer1)
            answerLayouts(answer: answer2)
            answerLayouts(answer: answer3)
            answerLayouts(answer: answer4)
        
        }
    }
    
    @IBAction func languagePressed(_ sender: UIButton) {
        languageOptions.forEach { (button ) in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }

}
