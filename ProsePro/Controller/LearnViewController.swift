//
//  LearnViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import UIKit

class LearnViewController: BaseViewController {

    
    @IBOutlet var taskLeftLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Update your label here
        let taskLeft = scheduler.tasksLefttoReview()
        taskLeftLabel.text = String(taskLeft)
        
    }

    

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        loadNextView()
        
        
    }


}
