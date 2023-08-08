//
//  BaseViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import UIKit

class BaseViewController: UIViewController {
    let scheduler = CardScheduler.shared
    
    func showCompletion() {
        
        let alertController = UIAlertController(title: "Congratulations!", message: "You have completed all your flashcards.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 {
                let targetViewController = viewControllers[1] // the second view controller in the stack
                self.navigationController?.popToViewController(targetViewController, animated: true)
            }

        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadNextView() {
        guard let nextScheduledTask = scheduler.nextScheduledTask() else {
            // If nextScheduledTask is nil, call checkCompletion() and return
            showCompletion()
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController?

        switch nextScheduledTask.task.taskType.interfaceType {
        case .basic:
            if let basicCardViewController = storyboard.instantiateViewController(withIdentifier: "BasicCardViewController") as? BasicCardViewController {
                basicCardViewController.scheduledTask = nextScheduledTask
                viewController = basicCardViewController
            }
        case .typeIn:
            if let typeInCardViewController = storyboard.instantiateViewController(withIdentifier: "TypeInCardViewController") as? TypeInCardViewController {
                // If needed, you can also set properties in TypeInCardViewController before pushing it
                typeInCardViewController.scheduledTask = nextScheduledTask
                viewController = typeInCardViewController
            }
        }

        if let viewController = viewController {
            navigationController?.pushViewController(viewController, animated: false)
        }
    }

}
