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


class AINetworkService {
    static let shared = AINetworkService()
    
    init(){
    }
    
    func extractTextResponse(from response: GeminiResponse) -> String? {
        return response.response.candidates.first?.content.parts.first?.text
    }
    
    func fetchAiResponse(prompt:String) async throws -> String{
        let baseUrl = "https://taskflow-backend-production-8812.up.railway.app"
        //let baseUrl = "http://localhost:3001"
        let urlString = "\(baseUrl)/api/test-ai/generate-test"
        
        guard let url = URL(string: urlString) else {
           throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do{
            request.httpBody = try encoder.encode(Prompt(text: prompt))
        } catch {
            throw NSError(domain: "Error encoding JSON", code: 0)
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Inside Bottom Do Statement: \(data)")
            
            let aiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
            
            
            
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
    
    private func buildUserPromptForAiResponse(taskContext: [TaskEvent], userPrompt: String) -> String {
        let taskList = formatTaskList(taskContext)
        let prompt: String = """
        Based on my current tasks listed below, please answer this question: \(userPrompt)
        
        My Tasks:
        \(taskList)
        
        Please provide a helpful answer based on these tasks. If you can't answer the question from the available task information, please let me know what additional details would be helpful.
"""
        
        return prompt
    }
    
    func AiTaskResponseAPICall(taskContext: [TaskEvent], userPrompt: String) async throws -> String {
        let prompt = buildUserPromptForAiResponse(taskContext: taskContext, userPrompt: userPrompt)
        return try await fetchAiResponse(prompt: prompt)
    }
    
}


