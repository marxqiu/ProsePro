//
//  LearnViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift


class LearnViewController: UIViewController {
    
    let chatGPT = ChatGPT()
    let realm = try! Realm()
    
    var isTapped = false
    
    var shuffledIndices : [Int]?
    
    var cardArray : Results<Card>? 
    

    
    var index = 0
    
    @IBOutlet var gptTextField: UITextView!
    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!
    @IBOutlet var separatorLine: UIView!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var contextLabel: UILabel!
    
    @IBOutlet var numLeftView: UIView!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
            self.view.addGestureRecognizer(tapGesture)
        
        
        
        cardArray = realm.objects(Card.self)
        shuffledIndices = Array(1..<cardArray!.count).shuffled()
        
        separatorLine.isHidden = true
        contextTextField.isHidden = true
        noteTextField.isHidden = true
        noteLabel.isHidden = true
        contextLabel.isHidden = true
        nextButton.isHidden = true
        
        print(cardArray![index].front)
        
        Task.init {
            let gptResult = await chatGPT.learnToRecall(cardArray![index].front, in: cardArray![index].context)
            gptTextField.text = gptResult
        }
        
        

        
        

        
        
    }
    
    @objc func screenTapped() {
        
        if !isTapped {
            separatorLine.isHidden = false
            contextTextField.isHidden = false
            noteTextField.isHidden = false
            noteLabel.isHidden = false
            contextLabel.isHidden = false
            
            numLeftView.isHidden = !numLeftView.isHidden
            nextButton.isHidden = !nextButton.isHidden
            
            isTapped = !isTapped
        }
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
