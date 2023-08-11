//
//  LearnViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift
import CommonMarkAttributedString

class BasicCardViewController: CardViewController {
    
    
    var isTapped = false
    

    

    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!

    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var contextLabel: UILabel!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        loadCard()
        
        
    }
    
    @objc func screenTapped() {
        print(isTapped)
        if !isTapped {
            separatorLine.isHidden = false
            contextTextField.isHidden = false
            noteTextField.isHidden = false
            noteLabel.isHidden = false
            contextLabel.isHidden = false
            
            
            againButton.isHidden = false
            hardButton.isHidden = false
            goodButton.isHidden = false
            easyButton.isHidden = false
            
            numLeftView.isHidden = true
            
            
            isTapped = !isTapped
        }
        
    }
    
    

    


    
    override func loadCard(){
        
        super.loadCard()
        contextTextField.isHidden = true
        noteTextField.isHidden = true
        noteLabel.isHidden = true
        contextLabel.isHidden = true


        
        
        
        
        contextTextField.text = scheduledTask?.parentCard.context
        noteTextField.text = scheduledTask?.parentCard.note
        
    
        
        isTapped = !isTapped
        
    }

}
