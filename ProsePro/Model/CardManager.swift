//
//  CardManager.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/7/23.
//

import Foundation
import RealmSwift

class CardManager {
    let realm = try! Realm()
    
    func deleteCards(_ cards: [Card]) throws {
        try realm.write {
            realm.delete(cards)
        }
    }
}
