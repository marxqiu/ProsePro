//
//  Schedular.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import Foundation
import RealmSwift

struct ScheduledTask {
    let task: CardTask
    let parentCard: Card
}

class CardScheduler {
    static let shared = CardScheduler()

    private var cards: [Card] = []
    private var currentIndex: Int = 0
    private var cardArray : Results<Card>
    private let cardManager = CardManager()
    
    private var taskArray : [ScheduledTask]
    
    private var notificationToken: NotificationToken?

    private init() {
        cardArray = cardManager.loadCards()
        taskArray = []
        
        // Load tasks initially
        updateTaskArray()
        
        // Set up an observer for cardArray changes
        notificationToken = cardArray.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // The initial data has been loaded (if available)
                break
            case .update(_, _, _, _):
                // The cardArray has been updated, update the taskArray accordingly
                self?.updateTaskArray()
            case .error(let error):
                // Handle the error
                print("Error observing cardArray: \(error)")
            }
        }
        
    }
    
    private func updateTaskArray() {
        taskArray.removeAll()
        
        // Iterate through all cards and their tasks
        for card in cardArray {
            for task in card.tasks {
                // Check the due date, or any other criteria you want to use
                if task.nextDateToReview <= Date() {
                    let scheduledTask = ScheduledTask(task: task, parentCard: card)
                    taskArray.append(scheduledTask)
                }
            }
        }
        
        // Optionally, sort the tasks by due date, priority, or any other criteria
        taskArray.shuffle()
        
    }


    func totalTasksToReview() -> Int {
        return taskArray.count
    }
    
    func tasksLefttoReview() -> Int {
        return taskArray.count - currentIndex
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }

    func nextScheduledTask() -> ScheduledTask? {
        if currentIndex < taskArray.count {
            let scheduledTask = taskArray[currentIndex]
            return scheduledTask
        }
        return nil
    }
    
    func increaseIndex(){
        currentIndex+=1
    }
    
}
