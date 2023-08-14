//
//  ChatGPT.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/6/23.
//

import UIKit
import OpenAI


class ChatGPT {
    let configuration: OpenAI.Configuration
    let openAI: OpenAI

    init() {
        configuration = OpenAI.Configuration(token: Config.openAIToken, host: "api.chatanywhere.com.cn",  timeoutInterval: 60.0)
        openAI = OpenAI(configuration: configuration)
    }
    
    func chat(with instruction: String) async -> ChatResult? {
        //https://snackprompt.com/prompt/talk-to-an-english-teacher-who-will-help-you-succeed-in-the-proficiency-test
//        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .system, content: "You are an English language proficiency test examiner. The objective is to enhance the student's conversational skills, expand vocabulary complexity, and improve fluency. The main goal is formulating various types of questions"), .init(role: .user, content: instruction)], temperature: 0.7)
        
        
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: instruction)], temperature: 0.7)
        do {
            let result = try await openAI.chats(query: query)
            return result
        } catch {
            print("Failed to get the response: \(error)")
            
        }
        
        return nil
        
    }
    
    
    func generateRecallInSentenceTask(_ front: String, in context: String) async -> String?{
        let instruction: String = "Produce a sentence containing the word \(front) and make sure you use the word correctly. Remember the sentence is used for a recall task that encourages the student to infer what the word means, so don't include the meaning of the word explicitly. Format your response as a JSON object with Word and Sentence as the keys"
        let chatResult = await self.chat(with: instruction)
        
        if let chatResult = chatResult {
            return chatResult.choices[0].message.content
        }
        
        return nil
    }
    
    func generateRecallByDefinitionTask(_ front: String, in context: String) async -> String?{
        let instruction: String = "Give the definition of the \(front). Format your response as a JSON object with Word and Definition as the keys"
        let chatResult = await self.chat(with: instruction)
        
        if let chatResult = chatResult {
            return chatResult.choices[0].message.content
        }
        
        return nil
    }
    
    func generateGRETextCompletionTask(_ front: String, in context: String) async -> String?{
        let instruction: String = "Generate a GRE Text Completion Question with five choices (including \(front) as a choice) and provide information for the learner to infer but don't include the correct choice explicityly. Output a JSON object with problem, choices, answer and rationale as keys."
        let chatResult = await self.chat(with: instruction)
        
        if let chatResult = chatResult {
            return chatResult.choices[0].message.content
        }
        
        return nil
    }
    
    
    func checkAnswer(_ answer: String, _ taskText: String, _ feedbackTextField: UITextView, _ taskType: TaskType){
        switch taskType{
        case .GRETextCompletion:
            checkGRETextCompletion(answer, taskText, feedbackTextField)
        case .recallByDefinition:
            checkRecallByDefinition(answer, taskText, feedbackTextField)
        default:
            print("Wrong card type")
        }
    }
    
    func checkGRETextCompletion(_ answer: String, _ taskText: String, _ feedbackTextField: UITextView) {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .system, content: "You are an experienced and helpful teacher with extensive knowledge and outstanding performance in various English language proficiency exams."), .init(role: .user, content: "\(taskText). \n My answer is \(answer). Check whether it's correct and provide feedback in Chinese.")], temperature: 0.7)
        openAI.chatsStream(query: query) { partialResult in
            switch partialResult {
            case .success(let result):
                // Extract the content outside of the DispatchQueue block
                let content = result.choices[0].delta.content ?? ""
                DispatchQueue.main.async {
                    feedbackTextField.text += content
                }

            case .failure(let error):
                // Handle chunk error here
                print("Chunk error:\(error)")
            }
        } completion: { error in
            // Handle streaming error here
        }

    }
    
    func checkRecallByDefinition(_ answer: String, _ taskText: String, _ feedbackTextField: UITextView) {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .system, content: "You are an experienced and helpful teacher with extensive knowledge and outstanding performance in various English language proficiency exams."), .init(role: .user, content: "\(taskText). \n My answer is \(answer). Check whether it's correct and provide feedback in Chinese.")], temperature: 0.7)
        openAI.chatsStream(query: query) { partialResult in
            switch partialResult {
            case .success(let result):
                // Extract the content outside of the DispatchQueue block
                let content = result.choices[0].delta.content ?? ""
                DispatchQueue.main.async {
                    feedbackTextField.text += content
                }

            case .failure(let error):
                // Handle chunk error here
                print("Chunk error:\(error)")
            }
        } completion: { error in
            // Handle streaming error here
        }

    }
    
    
}
