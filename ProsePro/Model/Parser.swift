//
//  Parser.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/9/23.
//

import Foundation


struct GRETextCompletion: Decodable {
    let problem: String
    let choices: [String]
    let answer: String
    let rationale: String
    
    
}


struct recallInSentence: Decodable {
    let Word: String
    let Sentence: String
}

struct recallByDefinition: Decodable {
    let Word: String
    let Definition: String
}

func parseGRETextCompletion(_ jsonString: String) -> String {
    let jsonData = jsonString.data(using: .utf8)!

    do {
        let question = try JSONDecoder().decode(GRETextCompletion.self, from: jsonData)
        let returnText = """
        For each blank select one entry from the corresponding column of choices.
        Fill all blanks in the way that best completes the text.
        \(question.problem)
        A.\(question.choices[0])
        B.\(question.choices[1])
        C.\(question.choices[2])
        D.\(question.choices[3])
        E.\(question.choices[4])
        Type the word below
        """
        return returnText
    } catch {
        fatalError("Error decoding JSON: \(error)")
    }
}


func parseRecallInSentence(_ jsonString: String) -> String {
    let jsonData = jsonString.data(using: .utf8)!

    do {
        let question = try JSONDecoder().decode(recallInSentence.self, from: jsonData)
        let returnText = """
        What is the meaning of the word?
        \(question.Sentence)
        """
        return returnText
    } catch {
        fatalError("Error decoding JSON: \(error)")
    }
}



func parseRecallByDefinition(_ jsonString: String) -> String {
    let jsonData = jsonString.data(using: .utf8)!

    do {
        let question = try JSONDecoder().decode(recallByDefinition.self, from: jsonData)
        let returnText = """
        What is the word with the following defintion?
        \(question.Definition)
        """
        return returnText
    } catch {
        fatalError("Error decoding JSON: \(error)")
    }
}
