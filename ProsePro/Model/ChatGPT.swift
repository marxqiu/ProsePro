//
//  ChatGPT.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/6/23.
//

import Foundation
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
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .system, content: "You are an English language proficiency test examiner. The objective is to enhance the student's conversational skills, expand vocabulary complexity, and improve fluency. The main goal is formulating various types of questions"), .init(role: .user, content: instruction)], temperature: 0.7)
        do {
            let result = try await openAI.chats(query: query)
            return result
        } catch {
            print("Failed to get the response: \(error)")
            
        }
        
        return nil
        
    }
    
    
    func generateRecallInSentenceTask(_ front: String, in context: String) async -> String?{
        let instruction: String = "Formulate a question that let the student guess the meaning of '\(front)' in a sentence in about 30 words. Surround '\(front)'with two asterisks (**). (for example, 'This is the **\(front)**')."
        let chatResult = await self.chat(with: instruction)
        
        if let chatResult = chatResult {
            return chatResult.choices[0].message.content
        }
        
        return nil
    }
    
    func generateRecallByDefinitionTask(_ front: String, in context: String) async -> String?{
        let instruction: String = "Formulate a questions that lets the student guess the word by the definition."
        let chatResult = await self.chat(with: instruction)
        
        if let chatResult = chatResult {
            return chatResult.choices[0].message.content
        }
        
        return nil
    }
    
    
}
