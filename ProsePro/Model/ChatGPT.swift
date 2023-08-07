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
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .system, content: "You are an experienced and communicative teacher with extensive knowledge and outstanding performance in various English language proficiency exams. The objective is to enhance my conversational skills, expand vocabulary complexity, and improve fluency."), .init(role: .user, content: instruction)], temperature: 0.7)
        do {
            let result = try await openAI.chats(query: query)
            return result
        } catch {
            print("Failed to get the response: \(error)")
            
        }
        
        return nil
        
    }
    
    
    func generateRecallTask(_ front: String, in context: String) async -> String?{
        let instruction: String = "I am learning '\(front)' now and and I want to command its meaning in \(context). Use '\(front)' in a completely different context. Remember to write the sentence in about 30 words and surround '\(front)'with two asterisks (**). (for example, 'This is the **\(front)**')."
        let chatResult = await self.chat(with: instruction)
        
        if let chatResult = chatResult {
            return chatResult.choices[0].message.content
        }
        
        return nil
    }
    
    func generateWritingTask(_ front: String, in context: String) async -> String?{
        let instruction: String = "I am learning \(front) now and and I want to command its meaning in \(context). Use it in a COMPLETELY DIFFERENT context in about 30 words."
        let chatResult = await self.chat(with: instruction)
        
        if let chatResult = chatResult {
            return chatResult.choices[0].message.content
        }
        
        return nil
    }
    
    
}
