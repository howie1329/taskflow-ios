//
//  ChatViewModel.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 8/12/25.
//


import Foundation

@Observable
class ChatViewModel {
    let aiService = AIService.shared

    // State
    var messages: [ChatPrompt] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    var currentAssistantMessageId: UUID?
    
    
    
    // MARK: - Initialization
    init(){
        setupAIServiceCallbacks()
    }

    func sendMessage(_ content: String){
        guard !content.isEmpty else { return}

        let userMessage = ChatPrompt(role: .user, content: content)
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
                let assistantMessage = ChatPrompt(role: .assistant, content: textChunk.text)
                currentAssistantMessageId = assistantMessage.id
                messages.append(assistantMessage)
            }
           
        case .toolCallChunk(let toolChunk):
            print("Ai is using Tool Chunk \(toolChunk.toolName)")
        case .startChunk(let startChunk):
            isLoading = true
            print("AI Is Starting")
        case .startStepChunk(let startChunk):
            print("Start Chunk")
        case .textStartChunk(let textStart):
            let assistantMessage = ChatPrompt(role: .assistant, content: "")
            currentAssistantMessageId = assistantMessage.id
            messages.append(assistantMessage)
            print("Text Start Chunk")
        case .textEndChunk(let textEnd):
            isLoading = false
            currentAssistantMessageId = nil
            print("Text End Chunk")
        case .unknown(let type):
            print("Unknown Chunk \(type)")
        }
    }



}

struct ChatPrompt: Identifiable, Codable{
    var id = UUID()
    let role: MessageRole
    var content:String

    enum MessageRole: String, Codable{
        case user = "user"
        case assistant = "assistant"
    }
}

