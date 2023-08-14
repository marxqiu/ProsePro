//
//  Schedular.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/8/23.
//

import Foundation
import RealmSwift
import SpacedRepetitionScheduler


class CardScheduler {
    static let shared = CardScheduler()
    
    private let cardManager = CardManager()

    private var taskArray : Results<CardTask>
    
    private var taskNew :  Results<CardTask>
    private var taskToLearn : Results<CardTask>
    private var taskToReview :  Results<CardTask>
    
    
    private let schedulingParameters = SchedulingParameters(
        learningIntervals: [1 * .minute, 10 * .minute]
      )

    private init() {
        taskArray = cardManager.loadTasks()
        
        // Initialize the properties first
        taskNew = taskArray.where {
            $0.schedulingMetadata.mode == "learning" && $0.schedulingMetadata.step == 0
        }
        taskToLearn = taskArray.where {
            $0.schedulingMetadata.mode == "learning" && $0.schedulingMetadata.step != 0
        }
        let calendar = Calendar.current
        let endOfToday = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        taskToReview = taskArray.where {
            $0.nextDateToReview <= endOfToday && $0.schedulingMetadata.mode == "review"
        }
        
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
        
        //let schedulingMetadata = task.schedulingMetadata?.update(with: schedulingParameters, recallEase: recallEase, timeIntervalSincePriorReview: Date().timeIntervalSinceReferenceDate - task.priorReviewTime)
        
        print("prior update")
        task.printDetails()
        
        let schedulingMetadata = task.schedulingMetadata?.update(with: schedulingParameters, recallEase: recallEase, timeIntervalSincePriorReview: 24*60*60)
        do {
            try cardManager.editTask(task, schedulingMetadata)
        } catch {
            print("Fail to edit the task: \(error)")
        }
        
        print("after update")
        task.printDetails()
        
    }

    
    func numTasksLeft() -> String {
        return "\(taskNew.count), \(taskToLearn.count), \(taskToReview.count)"
    }
    
    
    

    func nextTask() -> CardTask? {
        if !taskNew.isEmpty {
            return taskNew.first
        } else if !taskToLearn.isEmpty {
            return taskToLearn.first
        } else if !taskToReview.isEmpty {
            return taskToReview.first
        } else {
            return nil
        }
    
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
