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
    @Persisted var tasks = List<CardTask>()
    
    
    convenience init(front: String, context: String, note: String) {
        self.init()
        self.front = front
        self.context = context
        self.note = note
    }
}


class CardTask: Object {
    @Persisted var taskType : TaskType
    //JSON text
    @Persisted var text: String = ""
    @Persisted var textToDisplay: String = ""
    @Persisted var nextDateToReview: Date = Date()

    convenience init(taskType: TaskType, text: String){
        self.init()
        self.taskType = taskType
        self.text = text
        
        switch taskType {
        case .GRETextCompletion:
            self.textToDisplay = parseGRETextCompletion(text)
        case .recallInSentence:
            self.textToDisplay = parseRecallInSentence(text)
        case .recallByDefinition:
            self.textToDisplay = parseRecallByDefinition(text)
            
        }
    }
    
}

enum InterfaceType: String {
    case basic = "Basic"
    case typeIn = "TypeIn"
}


enum TaskType: String, PersistableEnum, CaseIterable {
    case recallInSentence = "Recall In Sentence"
    case recallByDefinition = "Recall By Definition"
    case GRETextCompletion = "GRETextCompletion"
    
    var interfaceType: InterfaceType {
        switch self {
        case .recallInSentence:
            return .basic
        case .recallByDefinition:
            return .typeIn
        case .GRETextCompletion:
            return .typeIn
        }
        
    }
}


