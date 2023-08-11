//
//  TypeInCardViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import UIKit

class TypeInCardViewController: CardViewController, UITextViewDelegate {
    

    
    @IBOutlet var answerTextField: UITextView!
    @IBOutlet var feedbackTextField: UITextView!
    @IBOutlet var feedbackLabel: UILabel!

    
    let chatGPT = ChatGPT()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        answerTextField.delegate = self
        loadCard()
    }
    
    

    
    // UITextViewDelegate method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // Detect return key
            textView.resignFirstResponder() // Dismiss the keyboard
            
            chatGPT.checkAnswer(answerTextField.text, (scheduledTask?.task.text)!, feedbackTextField, (scheduledTask?.task.taskType)!)
            
            separatorLine.isHidden = false
            feedbackTextField.isHidden = false
            feedbackLabel.isHidden = false
            
            
            
            againButton.isHidden = false
            hardButton.isHidden = false
            goodButton.isHidden = false
            easyButton.isHidden = false
            
            numLeftView.isHidden = true
            
            
            
            return false
        }
        return true
    }
    
    
    
    override func loadCard(){
        
        super.loadCard()
        answerTextField.isHidden = false
        feedbackTextField.isHidden = true
        feedbackLabel.isHidden = true

        
        
        
    }
    



}
