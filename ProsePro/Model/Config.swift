//
//  Config.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/6/23.
//

import Foundation

struct Config {
    static var openAIToken: String {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
           let openAIToken = dict["openAIToken"] as? String {
                return openAIToken
        } else {
            // Handle the error here
            fatalError("Token not found")
        }
    }
}
