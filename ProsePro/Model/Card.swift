//
//  Card.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/6/23.
//

import Foundation
import RealmSwift
import SpacedRepetitionScheduler



class RealmPromptSchedulingMetadata: Object {
    @Persisted var mode: String //'learning' or 'review'
    @Persisted var step: Int
    @Persisted var reviewCount: Int
    @Persisted var lapseCount: Int
    @Persisted var interval: TimeInterval
    @Persisted var reviewSpacingFactor: Double
    
    convenience init(
        mode: String = "learning",
        step: Int = 0,
        reviewCount: Int = 0,
        lapseCount: Int = 0,
        interval: TimeInterval = 0,
        reviewSpacingFactor: Double = 2.5
    ) {
        self.init()
        self.mode = mode
        self.step = step
        self.reviewCount = reviewCount
        self.lapseCount = lapseCount
        self.reviewSpacingFactor = reviewSpacingFactor
        self.interval = interval
    }
    
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
}



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
    @Persisted var schedulingMetadata : RealmPromptSchedulingMetadata?
    @Persisted var priorReviewTime: TimeInterval = 0
    @Persisted var nextDateToReview: Date = Date()

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


