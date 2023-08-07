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

    func addCard(_ front: String, _ context: String, _ note: String) async throws {
        let newCard = Card(front: front, context: context, note: note)
            
        // Generate the recallTask using ChatGPT and add it to the newCard
        if let recallTask = await chatGPT.generateRecallTask(front, in: context) {
            newCard.recallTask = recallTask
        }

        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(newCard)
                }
            } catch {
                print("Failed to write to Realm: \(error)")
            }
        }
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
