//
//  AiDataService.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/9/25.
//

import Foundation

@Observable
class AiDataService {
    static let shared = AiDataService()
    
    var chatThreads: [MainChatThread] = []
    var currentMainThread: MainChatThread? = nil
    
    private init() { }
    
    func appendThread(_ thread: MainChatThread) {
        chatThreads.append(thread)
    }
    
    
}

@MainActor
@Observable
class MainChatThread: Identifiable {
    let id = UUID().uuidString
    var title:String
    var messages: [NewChatMessage] = []
    
    init(title: String) {
        self.title = title
    }
    
    func append(_ message: NewChatMessage) {
        messages.append(message)
    }
}
