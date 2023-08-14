//
//  Card.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/6/23.
//

import Foundation
import RealmSwift
import SpacedRepetitionScheduler



class RealmPromptSchedulingMetadata: EmbeddedObject {
    @Persisted var mode: String = "learning" //'learning' or 'review'
    @Persisted var step: Int = 0
    @Persisted var reviewCount: Int = 0
    @Persisted var lapseCount: Int = 0
    @Persisted var interval: TimeInterval = 0
    @Persisted var reviewSpacingFactor: Double = 2.5
    
    
    func update(with schedulingParameters: SchedulingParameters, recallEase: RecallEase, timeIntervalSincePriorReview: TimeInterval) -> PromptSchedulingMetadata{
        let learningMode = (mode == "learning") ? PromptSchedulingMode.learning(step: self.step) : PromptSchedulingMode.review
        var schedulingMetadata = PromptSchedulingMetadata(mode: learningMode,
                                     reviewCount: self.reviewCount,
                                     lapseCount: self.lapseCount,
                                     interval: self.interval,
                                     reviewSpacingFactor: self.reviewSpacingFactor)
        do {
            try schedulingMetadata.update(
                with: schedulingParameters,
                recallEase: recallEase,
                timeIntervalSincePriorReview: timeIntervalSincePriorReview
            )
            print("Next review in \(schedulingMetadata.interval) seconds.")
        } catch {
            print("An error occurred while updating the scheduling metadata.")
        }
        
        return schedulingMetadata
        

    }
    
    func printDetails() {
        print("mode: \(mode)")
        print("step: \(step)")
        print("reviewCount: \(reviewCount)")
        print("lapseCount: \(lapseCount)")
        print("interval: \(interval)")
        print("reviewSpacingFactor: \(reviewSpacingFactor)")
    }
}



class Card: Object {
    @Persisted var front: String = ""
    @Persisted var context: String = ""
    @Persisted var note: String = ""
    @Persisted var dateCreated: Date = Date()
    
    //A card can have many tasks
    @Persisted var tasks : List<CardTask>
    
    
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
    
    // Embed a single object.
    // Embedded object properties must be marked optional.
    @Persisted var schedulingMetadata : RealmPromptSchedulingMetadata?
    @Persisted var priorReviewTime: TimeInterval = 0
    @Persisted var nextDateToReview: Date = Date()
    
    //Backlink to the card
    @Persisted(originProperty: "tasks") var parentCards: LinkingObjects<Card>
    var parentCard: Card? {
        return self.parentCards.first
    }

    convenience init(taskType: TaskType, text: String){
        self.init()
        self.taskType = taskType
        self.text = text
        self.schedulingMetadata = RealmPromptSchedulingMetadata()
        
        switch taskType {
        case .GRETextCompletion:
            self.textToDisplay = parseGRETextCompletion(text)
        case .recallInSentence:
            self.textToDisplay = parseRecallInSentence(text)
        case .recallByDefinition:
            self.textToDisplay = parseRecallByDefinition(text)
            
        }
    }
    
    func printDetails() {
        print("text: \(text)")
        print("priorReviewTime: \(priorReviewTime)")
        print("nextDateToReview: \(nextDateToReview)")
        self.schedulingMetadata?.printDetails()
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


