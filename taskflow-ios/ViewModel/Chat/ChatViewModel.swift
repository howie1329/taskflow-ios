//
//  ChatViewModel.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 8/12/25.
//


import Foundation

struct ChatPrompt: Identifiable, Codable{
    var id = UUID()
    let role: MessageRole
    var content:String
    var type: MessageType
    
    enum MessageType: String, Codable{
        case start = "start"
        case text = "text"
        case toolCall = "toolCall"
    }

    enum MessageRole: String, Codable{
        case user = "user"
        case assistant = "assistant"
    }
}

extension ChatPrompt {
	static let dummyData: [ChatPrompt] = [
        .init(role: .assistant, content: "👋 Hey! I’m your Taskflow AI. How can I help today?",type: .text),
		.init(role: .user, content: "What’s on my schedule today?",type: .text),
		.init(role: .assistant, content: "You have Daily Standup at 9:00 AM, Code Review at 11:00 AM, and a Project Sync at 2:00 PM.",type: .text),
		.init(role: .user, content: "Summarize my open tasks and priorities.",type: .text),
		.init(role: .assistant, content: "You have 5 open tasks. Top priorities: 1) Implement auth middleware, 2) Fix iOS chat streaming bug, 3) Write unit tests for TaskService.",type: .text),
		.init(role: .user, content: "Create a subtask for auth middleware: 'Add JWT verification'.",type: .text),
		.init(role: .assistant, content: "Subtask added: Add JWT verification to the API gateway.",type: .text),
		.init(role: .user, content: "Thanks!",type: .text),
		.init(role: .assistant, content: "Anytime. Want me to draft a checklist for today?",type: .text)
	]
}

@Observable
class ChatViewModel {
    let aiService = AIService.shared

    // State
    var messages: [ChatPrompt] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    var currentAssistantMessageId: UUID?
    
    // Testing New Way of messages
    var chunkStore: [AIChunk] = []
    var assistnatMessageFinished: Bool = true
    var unfinshedChunk: AIChunk?
    
    
    
    // MARK: - Initialization
    init(){
        setupAIServiceCallbacks()
    }

    func sendMessage(_ content: String){
        guard !content.isEmpty else { return}

        let userMessage = ChatPrompt(role: .user, content: content,type: .text)
        messages.append(userMessage)
        
        isLoading = true
        errorMessage = nil
        
        // Send to AI Service
        aiService.sendChatMessage(messages)
    }
    
    func clearChat(){
        messages.removeAll()
        isLoading = false
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    private func setupAIServiceCallbacks(){
        aiService.onMessageChunk = { [weak self] chunk in
            DispatchQueue.main.async{
                self?.handleStreamingChunk(chunk)
            }
        }
    }
    
    private func handleStreamingChunk(_ chunk: AIChunk){
        switch chunk {
        case .textDeltaChunk(let textChunk):
            
            if let id = currentAssistantMessageId, let idx = messages.firstIndex(where: { $0.id == id}){
                messages[idx].content += textChunk.text
            } else {
                let assistantMessage = ChatPrompt(role: .assistant, content: textChunk.text, type: .text)
                currentAssistantMessageId = assistantMessage.id
                messages.append(assistantMessage)
            }
           
        case .toolCallChunk(let toolChunk):
            print("Ai is using Tool Chunk \(toolChunk.toolName)")
            messages.append(ChatPrompt(role: .assistant, content: "Using Tool \(toolChunk.toolName)", type: .toolCall))
        case .startChunk(let startChunk):
            messages.append(ChatPrompt(role:.assistant, content:"Starting...", type:.start))
            isLoading = true
            print("AI Is Starting")
        case .startStepChunk(let startChunk):
            print("Start Chunk")
        case .textStartChunk(let textStart):
            // Testing Chunk
            assistnatMessageFinished = false
            
            let assistantMessage = ChatPrompt(role: .assistant, content: "", type: .text)
            currentAssistantMessageId = assistantMessage.id
            messages.append(assistantMessage)
            print("Text Start Chunk")
        case .textEndChunk(let textEnd):
            messages.removeAll{$0.type == .start}
            isLoading = false
            currentAssistantMessageId = nil
            print("Text End Chunk")
        case .unknown(let type):
            print("Unknown Chunk \(type)")
        }
    }



}



