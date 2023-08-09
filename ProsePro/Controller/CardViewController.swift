//
//  CardViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import UIKit

class CardViewController: BaseViewController {
    var scheduledTask : ScheduledTask?
    
    @IBOutlet var gptTextField: UITextView!
    @IBOutlet var separatorLine: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var numLeftLabel: UILabel!
    @IBOutlet var numLeftView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button
        self.navigationItem.hidesBackButton = true
        loadCard()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        scheduler.increaseIndex()
        loadNextView()
    }
    
    func loadCard() {
        numLeftView.isHidden = false
        separatorLine.isHidden = true
        nextButton.isHidden = true
        
        
        
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
        
        numLeftLabel.text = "\(scheduler.getCurrentIndex())/\(scheduler.totalTasksToReview())"
    }
    
}
