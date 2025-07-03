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
    let avgLogprobs: Double
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
    let candidatesTokensDetails: [TokenDetail]
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
    
    func fetchAiResponse(complete: @escaping (Result<String, Error>) -> Void){
        let baseUrl = "https://taskflow-backend-production-8812.up.railway.app"
        //let baseUrl = "http://localhost:3001"
        let urlString = "\(baseUrl)/api/test-ai/generate-test"
        
        guard let url = URL(string: urlString) else {
            complete(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do{
            request.httpBody = try encoder.encode(Prompt(text: "What is the most popular sport in the world?"))
        } catch {
            complete(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                complete(.failure(error))
                return
            }
            
            guard let data = data else {
                complete(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            
            do{
                let aiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
                guard let modelText = self.extractTextResponse(from: aiResponse) else { complete(.failure(NSError(domain: "No Text", code: 0, userInfo: nil)))
                return }
                complete(.success(modelText))
            } catch {
                complete(.failure(error))
            }
        }.resume()
    }
}
