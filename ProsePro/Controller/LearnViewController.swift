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
    
    var isTapped = true
    
    var shuffledIndices : [Int]?
    
    var cardArray : Results<Card>?
    
    let cardManager = CardManager()
    
    var index = 0
    
    @IBOutlet var gptTextField: UITextView!
    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!
    @IBOutlet var separatorLine: UIView!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var contextLabel: UILabel!
    
    @IBOutlet var numLeftView: UIView!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var numLeftLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        self.view.addGestureRecognizer(tapGesture)
        
       
        
        shuffledIndices = Array(0..<cardArray!.count).shuffled()
        
        nextCard()
        
        
        
    }
    
    @objc func screenTapped() {
        if !isTapped {
            separatorLine.isHidden = false
            contextTextField.isHidden = false
            noteTextField.isHidden = false
            noteLabel.isHidden = false
            contextLabel.isHidden = false
            
            
            nextButton.isHidden = false
            numLeftView.isHidden = true
            
            
            isTapped = !isTapped
        }
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        nextCard()
    }
    
    func nextCard(){
        
        if let shuffledIndices = shuffledIndices {
            // If the index is equal to the count, then show the congratulation message
            if index == shuffledIndices.count {
                // You can either show a congrats view or push/present a new view controller here
                // The following is an example of presenting a simple alert
                let alertController = UIAlertController(title: "Congratulations!", message: "You have completed all your flashcards.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            separatorLine.isHidden = true
            contextTextField.isHidden = true
            noteTextField.isHidden = true
            noteLabel.isHidden = true
            contextLabel.isHidden = true
            nextButton.isHidden = true
            numLeftView.isHidden = false
            
            gptTextField.text = cardArray![shuffledIndices[index]].recallTask
            contextTextField.text = cardArray![shuffledIndices[index]].context
            noteTextField.text = cardArray![shuffledIndices[index]].note
            numLeftLabel.text = "\(index+1)/\(shuffledIndices.count)"
        }
        
        index += 1
        isTapped = !isTapped
        
    }
    
    func loadCard() {
        
        cardArray = cardManager.loadCards()
        
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
