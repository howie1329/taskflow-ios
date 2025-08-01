//
//  AINetworkService.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/3/25.
//

import Foundation

struct Prompt: Codable {
    var prompt: String
    init(text: String) {
        self.prompt = text
    }
}

// MARK: - Main Response Model
struct GeminiResponse: Codable {
    let response: ResponseData
}

// MARK: - Response Data
struct ResponseData: Codable {
    let candidates: [Candidate]
    let modelVersion: String
    let usageMetadata: UsageMetadata
}

// MARK: - Candidate
struct Candidate: Codable {
    let content: Content
    let finishReason: String
    let avgLogprobs: Double?
}

// MARK: - Content
struct Content: Codable {
    let parts: [Part]
    let role: String
}

// MARK: - Part
struct Part: Codable {
    let text: String
}

// MARK: - Usage Metadata
struct UsageMetadata: Codable {
    let promptTokenCount: Int
    let candidatesTokenCount: Int
    let totalTokenCount: Int
    let promptTokensDetails: [TokenDetail]
    let candidatesTokensDetails: [TokenDetail]?
}

// MARK: - Token Detail
struct TokenDetail: Codable {
    let modality: String
    let tokenCount: Int
}

// MARK: - Vercel AI Response
struct VercelAIResponse: Codable {
    let text: String
    let toolCalls: [VercelSingleTool]
    //let toolResults: [VercelSingleToolResults]?
}

// MARK: - Vercel AI Single Tool
struct VercelSingleTool: Codable {
    let type: String
    let toolCallId: String
    let toolName:String
}

// MARK: - Vercel AI Single Tool Results
struct VercelSingleToolResults: Codable {
    let type: String
    let toolCallId: String
    let toolName: String
    let result: VercelSingleToolResult
}

// MARK: - Vercel AI Single Tool Result
struct VercelSingleToolResult: Codable {
    let text: String
    let type: String
    let prompt: String
    let choices: [VercelSingleToolResultChoice]?
}

// MARK: - Vercel AI Single Tool Result Choice
struct VercelSingleToolResultChoice: Codable {
    let id: String
    let title: String
}

// MARK: - App/User Prompt
struct AppUserPrompt: Codable {
    var message: String
    var userId: String
    var chatHistory: [NewChatMessage]
    
    init(message: String, chatHistory: [NewChatMessage], userId:String) {
        self.message = message
        self.userId = userId
        self.chatHistory = chatHistory
    }
    
    
}


class AINetworkService {
    static let shared = AINetworkService()
    
    init(){
    }
    
    func extractTextResponse(from response: VercelAIResponse) -> String? {
        return response.text
    }
    
    func fetchAiResponse(_ sentResponse: AppUserPrompt) async throws -> String{
        //let baseUrl = "https://taskflow-backend-production-8812.up.railway.app"
        let baseUrl = "http://localhost:3001"
        let urlString = "\(baseUrl)/api/vercel-ai/taskflow-ai"
        
        
        guard let url = URL(string: urlString) else {
           throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do{
            request.httpBody = try encoder.encode(sentResponse)
        } catch {
            throw NSError(domain: "Error encoding JSON", code: 0)
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Inside Bottom Do Statement: \(data)")
            
            let aiResponse = try JSONDecoder().decode(VercelAIResponse.self, from: data)
            
            print("Response: ", aiResponse)
            
            
            
            guard let modelText = extractTextResponse(from: aiResponse) else {
                throw NSError(domain: "No Text", code: 0)
            }
            
            return modelText
            
        } catch {
            throw NSError(domain: "Error fetching data", code: 0)
        }
    }
}

extension AINetworkService {
    //MARK: Prompt Building -- Ai Fetching -- Task Context
    
    private func formatTaskList(_ taskContext: [TaskEvent]) -> String{
        let taskList =  taskContext.map{ task in
            return """
            \(task.title) Priority: \(task.priority)
            Description: \(task.description)
            Completed: \(task.isCompleted)
            """
        }.joined(separator: "\n\n")
        
        return taskList
    }
    
    private func formatChatHistory(_ chatHistory: [NewChatMessage]) -> String {
        let chatHistoryString = chatHistory.map { chatMessage in
            return "role:\(chatMessage.role): Message: \(chatMessage.content)"
        }.joined(separator: "\n\n")
        
        return chatHistoryString
    }
    
    private func buildUserPromptForAiResponse(taskContext: [TaskEvent], userPrompt: String, chatHistory:[NewChatMessage]? = nil, userId: String ) -> AppUserPrompt {
        //let taskList = formatTaskList(taskContext)
        //let chatHistoryText: String
        
        /* if let chatHistoryArray = chatHistory {
            chatHistoryText = formatChatHistory(chatHistoryArray)
        } else {
            chatHistoryText = "No Chat History"
        } */
        
        let prompt: String = """
         Please answer this question or perfrom this task: \(userPrompt)
        
        Please provide a helpful answer based on the useres tasks and past chat history. If you can't answer the question from the available task information, please let me know what additional details would be helpful. Also the use may ask questions that are not related to the task list, so for those questions you can answer directly. When answering question be percise.
"""
        
        return AppUserPrompt(message: prompt, chatHistory: chatHistory ?? [], userId: userId)
    }
    
    func AiTaskResponseAPICall(taskContext: [TaskEvent], userPrompt: String, chatHistory:[NewChatMessage]? = nil, userId: String) async throws -> String {
        let prompt = buildUserPromptForAiResponse(taskContext: taskContext, userPrompt: userPrompt, chatHistory: chatHistory, userId: userId)
        return try await fetchAiResponse(prompt)
    }
    
}


