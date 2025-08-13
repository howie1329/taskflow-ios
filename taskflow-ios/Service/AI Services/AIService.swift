//
//  AIService.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 8/12/25.
//

import Foundation
struct userPayload: Codable {
    var userId: String = ""
    var chat:[String] = []
}

class AIService {
    // MARK: - Singleton
    static let shared = AIService()
    
    // MARK: - Dependencies
    private let socket = TaskFlowSocketManager.shared
    
    // MARK: - Callbacks
    var onMessageChunk: ((AIChunk) -> Void)?
    var onMessageComplete: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    // MARK: - Proprties
    var userId: String = "user_2usb0Md2SjCvMehu1XHJBN2y03c"
    
    init() {
        setupSocketListneres()
    }
    
    func sendChatMessage(_ chatHistory: [ChatPrompt] ){
       var payLoad = formatPayload(chatHistory)
        socket.emit(event: "ai:taskflow:start", data: payLoad)
    }
    
    func formatPayload(_ chatHistory: [ChatPrompt]) -> [String: Any] {
        
        var newChatHistory: [[String: Any]] = []
        
        chatHistory.forEach { item in
            let payload = ["role": item.role.rawValue, "content": item.content]
            newChatHistory.append(payload)
        }
        
        return ["userId": userId, "chatHistory": newChatHistory]
    }
    
    func send(_ message: [String: Any]) {
        socket.emit(event: "ai:taskflow:start", data: message)
    }
    
    func setupSocketListneres(){
        socket.on(event: "ai:taskflow:stream") { [weak self] data, ack in
            print("Listner In Ai Service Here!")
            self?.handleStreamingResponse(data)
        }
    }
    
    private func handleStreamingResponse(_ data: [Any]){
        guard let responseData = data.first as? [String: Any] else { return }
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: responseData)
            
            let chunk = try JSONDecoder().decode(AIChunk.self, from: jsonData)
            
            onMessageChunk?(chunk)
        } catch {
            print("Failed To Decode Chunk: \(error)")
        }
    }
    
    
}
