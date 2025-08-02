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
    var isAiLoading: Bool = false // Add dedicated AI loading state
    var currentAiError: String? = nil // Add error handling for AI responses
    
    private init() { }
    
    func appendThread(_ thread: MainChatThread) {
        chatThreads.append(thread)
    }
    
    func removeThread(_ thread: MainChatThread) {
        chatThreads.removeAll { $0.id == thread.id }
        
        // Clear currentMainThread if it's the one being deleted
        if currentMainThread?.id == thread.id {
            currentMainThread = nil
        }
    }
    
    func removeThread(at indexSet: IndexSet) {
        for index in indexSet {
            let threadToRemove = chatThreads[index]
            if currentMainThread?.id == threadToRemove.id {
                currentMainThread = nil
            }
        }
        chatThreads.remove(atOffsets: indexSet)
    }
    
    // MARK: - AI Loading State Management
    @MainActor
    func setAiLoading(_ loading: Bool) {
        isAiLoading = loading
        if loading {
            currentAiError = nil // Clear any previous errors when starting new request
        }
    }
    
    @MainActor
    func setAiError(_ error: String?) {
        currentAiError = error
        isAiLoading = false
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
