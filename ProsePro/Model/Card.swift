//
//  Card.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/6/23.
//

import Foundation
import RealmSwift


class Card: Object {
    @Persisted var front: String = ""
    @Persisted var context: String = ""
    @Persisted var note: String = ""
    @Persisted var dateCreated: Date = Date()
    
    
    convenience init(front: String, context: String, note: String) {
        self.init()
        self.front = front
        self.context = context
        self.note = note
    }
}
