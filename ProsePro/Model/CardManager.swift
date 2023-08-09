//
//  CardManager.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/7/23.
//

import Foundation
import RealmSwift

class CardManager {
    
    let chatGPT : ChatGPT
    
    init() {
        
        self.chatGPT = ChatGPT()
    }

    
    func deleteCards(_ cards: [Card]) throws {
        let realm = try! Realm()
        try realm.write {
            realm.delete(cards)
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
                card?.tasks.append(cardTask)
            }
        }
        print("finish recall")
        
    }
    
    @MainActor
    func addCard(_ front: String, _ context: String, _ note: String, _ taskTypeArray: [TaskType]) async {
        let realm = try! await Realm()
        let newCard = Card(front: front, context: context, note: note)
            
        // Generate the recallTask using ChatGPT and add it to the newCard
       
        try! realm.write {
            realm.add(newCard)
        }
        
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
    
    func loadCards() -> Results<Card>{
        let realm = try! Realm()
        return realm.objects(Card.self)
    }
    
    
    
}
