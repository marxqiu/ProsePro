//
//  Schedular.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import Foundation
import RealmSwift
import SpacedRepetitionScheduler

struct ScheduledTask {
    let task: CardTask
    let parentCard: Card
}

class CardScheduler {
    static let shared = CardScheduler()

    private var cards: [Card] = []
    private var cardArray : Results<Card>
    private let cardManager = CardManager()
    
    private var taskQueue =  Queue<ScheduledTask>()
    
    private var notificationToken: NotificationToken?
    
    private let schedulingParameters = SchedulingParameters(
        learningIntervals: [1 * .minute, 10 * .minute]
      )

    private init() {
        cardArray = cardManager.loadCards()
        
        // Load tasks initially
        loadTaskQueue()
        
        // Set up an observer for cardArray changes
        notificationToken = cardArray.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // The initial data has been loaded (if available)
                break
            case .update(_, _, _, _):
                // The cardArray has been updated, update the taskArray accordingly
                self?.loadTaskQueue()
            case .error(let error):
                // Handle the error
                print("Error observing cardArray: \(error)")
            }
        }
        
    }
    
    
    
    
    private func loadTaskQueue() {
        taskQueue.removeAll()
        // Iterate through all cards and their tasks
        for card in cardArray {
            for task in card.tasks {
                // Check the due date, or any other criteria you want to use
                if task.nextDateToReview <= Date() {
                    let scheduledTask = ScheduledTask(task: task, parentCard: card)
                    taskQueue.enqueue(scheduledTask)
                }
            }
        }
        
        // Optionally, sort the tasks by due date, priority, or any other criteria
        
    }
    
    func updateMetadata(of task:CardTask, _ buttonTag: Int){
        var recallEase: RecallEase
                
        switch buttonTag {
        case 0:
            recallEase = .again
        case 1:
            recallEase = .hard
        case 2:
            recallEase = .good
        case 3:
            recallEase = .easy
        default:
            fatalError("Unknown tag")
        }
        
        let schedulingMetadata = task.schedulingMetadata?.update(with: schedulingParameters, recallEase: recallEase, timeIntervalSincePriorReview: Date().timeIntervalSinceReferenceDate - task.priorReviewTime)
        do {
            try cardManager.editTask(task, schedulingMetadata)
        } catch {
            print("Fail to edit the task: \(error)")
        }
        
        
    }


    func totalTasksToReview() -> Int {
        return taskQueue.count
    }
    
    func tasksLefttoReview() -> Int {
        return taskQueue.count
    }
    

    func nextScheduledTask() -> ScheduledTask? {
        return taskQueue.peek()
    }
    
    func dequeScheduledTask()  {
        _ = taskQueue.dequeue()
    }

}


struct Queue<T> {
    private var elements: [T] = []

    mutating func enqueue(_ value: T) {
        elements.append(value)
    }
    
    var count: Int {
        return elements.count
    }

    mutating func dequeue() -> T? {
        return elements.isEmpty ? nil : elements.removeFirst()
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    func peek() -> T? {
        return elements.first
    }
    
    mutating func removeAll() {
        elements.removeAll()
    }
}
