//
//  CardViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import UIKit
import SpacedRepetitionScheduler

class CardViewController: BaseViewController {
    var scheduledTask : ScheduledTask?
    
    @IBOutlet var gptTextField: UITextView!
    @IBOutlet var separatorLine: UIView!
    
    @IBOutlet var againButton: UIButton!
    @IBOutlet var hardButton: UIButton!
    @IBOutlet var goodButton: UIButton!
    @IBOutlet var easyButton: UIButton!
    
    @IBOutlet var numLeftLabel: UILabel!
    @IBOutlet var numLeftView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button
        self.navigationItem.hidesBackButton = true
        loadCard()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if let task = scheduledTask?.task{
            scheduler.updateMetadata(of:task, sender.tag)
        }
        
        scheduler.dequeScheduledTask()
        loadNextView()
        
    }
    
    func loadCard() {
        numLeftView.isHidden = false
        separatorLine.isHidden = true
        againButton.isHidden = true
        hardButton.isHidden = true
        goodButton.isHidden = true
        easyButton.isHidden = true
        
        
        
//        do {
//            let commonmark = scheduledTask?.task.textToDisplay
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 14.0)
//            ]
//
//            let attributedString = try NSAttributedString(commonmark: commonmark!, attributes: attributes)
//            gptTextField.attributedText = attributedString
//        } catch {
//            print("Failed to convert commonmark to attributed string: \(error)")
//        }
        gptTextField.text = scheduledTask?.task.textToDisplay
        
        numLeftLabel.text = "\(scheduler.totalTasksToReview())"
    }
    
}
