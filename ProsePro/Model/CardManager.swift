//
//  CardManager.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/7/23.
//

import Foundation
import RealmSwift
import SpacedRepetitionScheduler
import RxSwift



class CardManager {
    
    let chatGPT : ChatGPT
    
    private let pendingTasksCountSubject = BehaviorSubject<Int>(value: 0)
    var pendingTasksCountObservable: Observable<Int> {
            return pendingTasksCountSubject.asObservable()
        }
    
    private var pendingTasksCount: Int = 0 {
        didSet {
            pendingTasksCountSubject.onNext(pendingTasksCount)
        }
    }
    
    
    init() {
        
        self.chatGPT = ChatGPT()
    }

    
    func deleteCards(_ cards: [Card]) throws {
        let realm = try Realm()
        
        //batch deletion
        try realm.write {
            for card in cards {
                // Delete associated CardTask objects
                realm.delete(card.tasks)
                
                // Delete the Card object
                realm.delete(card)
            }
        }
        
    }
    
    @MainActor
    func loadTaskInBackground(@ThreadSafe card: Card?, front: String, context: String, taskType: TaskType) async {
        
        
        var taskText:String?
        switch taskType {
        case .recallInSentence:
            taskText = await chatGPT.generateRecallInSentenceTask(front, in: context)
        case .recallByDefinition:
            taskText = await chatGPT.generateRecallByDefinitionTask(front, in: context)
        case .GRETextCompletion:
            taskText = await chatGPT.generateGRETextCompletionTask(front, in: context)
        }
        if let taskText = taskText {
            print(taskText)
            let realm = try! await Realm()
            let cardTask = CardTask(taskType: taskType, text: taskText)
            
            try! realm.write {
//                print("cradTask created")
//                cardTask.printDetails()
                
                card?.tasks.append(cardTask)
            }
        }
        
        
        pendingTasksCount -= 1 // Decrement the pending tasks count when a task is added
        print("Add")
    }
    

    
    @MainActor
    func addCard(_ front: String, _ context: String, _ note: String, _ taskTypeArray: [TaskType]) async {
        print("addCard called with \(taskTypeArray.count) task types")
        let realm = try! await Realm()
        let newCard = Card(front: front, context: context, note: note)
            
        // Generate the recallTask using ChatGPT and add it to the newCard
       
        try! realm.write {
            realm.add(newCard)
        }
        
        pendingTasksCount += taskTypeArray.count
        
        for taskType in taskTypeArray {
            await loadTaskInBackground(card: newCard, front: front, context: context, taskType: taskType)
        }
        
        
    }
    
    
    
    func editCard(_ selectedCard: Card, _ front: String, _ context: String, _ note: String) throws {
        let realm = try! Realm()
        try realm.write {
            selectedCard.front = front
            selectedCard.context = context
            selectedCard.note = note
        }
    }
    
    func editTask(_ selectedTask: CardTask, _ schedulingMetadata: PromptSchedulingMetadata?) throws {
        var mode : String
        var mode_step : Int = 0
        
        
        
        if let schedulingMetadata = schedulingMetadata {
            switch schedulingMetadata.mode {
            case .learning(let step):
                mode = "learning"
                mode_step = step
            case .review:
                mode = "review"
            }
            
            let realm = try! Realm()
            try realm.write {
                selectedTask.schedulingMetadata?.mode = mode
                selectedTask.schedulingMetadata?.step = mode_step
                selectedTask.schedulingMetadata?.reviewCount = schedulingMetadata.reviewCount
                selectedTask.schedulingMetadata?.lapseCount = schedulingMetadata.lapseCount
                selectedTask.schedulingMetadata?.reviewSpacingFactor = schedulingMetadata.reviewSpacingFactor
                selectedTask.schedulingMetadata?.interval = schedulingMetadata.interval
                selectedTask.priorReviewTime = Date().timeIntervalSinceReferenceDate
                selectedTask.nextDateToReview = Date().addingTimeInterval(schedulingMetadata.interval)
            }
            
        }
        
        
    }
    
    func loadCards() -> Results<Card>{
        let realm = try! Realm()
        return realm.objects(Card.self)
    }
    
    func loadTasks() -> Results<CardTask>{
        let realm = try! Realm()
        return realm.objects(CardTask.self)
    }
    
    
    
}
