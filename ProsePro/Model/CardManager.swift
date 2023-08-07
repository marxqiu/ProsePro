//
//  CardManager.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/7/23.
//

import Foundation
import RealmSwift

class CardManager {
    let realm : Realm
    let chatGPT : ChatGPT
    
    init() {
        self.realm = try! Realm()
        self.chatGPT = ChatGPT()
    }

    
    func deleteCards(_ cards: [Card]) throws {
        try realm.write {
            realm.delete(cards)
        }
    }
    
    @MainActor
    func loadRecallTaskInBackground(@ThreadSafe card: Card?, front: String, context: String) async {
        if let recallTask = await chatGPT.generateRecallTask(front, in: context) {
            print(recallTask)
            let realm = try! await Realm()
            try! realm.write {
                card?.recallTask = recallTask
            }
        }
        print("finish recall")
        
    }
    
    @MainActor
    func addCard(_ front: String, _ context: String, _ note: String) async {
        let realm = try! await Realm()
        let newCard = Card(front: front, context: context, note: note)
            
        // Generate the recallTask using ChatGPT and add it to the newCard
       
        try! realm.write {
            realm.add(newCard)
        }
        
        await loadRecallTaskInBackground(card: newCard, front: front, context: context)
        
    }
    
    

    
    func editCard(_ selectedCard: Card, _ front: String, _ context: String, _ note: String) throws {
        try realm.write {
            selectedCard.front = front
            selectedCard.context = context
            selectedCard.note = note
        }
    }
    
    func loadCards() -> Results<Card>{
        return realm.objects(Card.self)
    }
    
    
    
}
