//
//  NetworkService.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/2/25.
//

import Foundation


class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    struct TasksResponse: Codable{
        let tasks: [TaskEvent]
    }
    
    func fetchTasksFromServer(userId: String) async throws -> [TaskEvent]{
        let baseUrl = "https://taskflow-backend-production-8812.up.railway.app"
        let urlString = "\(baseUrl)/api/test-ai/fetch-tasks/\(userId)"
        guard let url = URL(string: urlString) else {
           throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            let serverResponse = try JSONDecoder().decode(TasksResponse.self, from: data)
            return serverResponse.tasks
        } catch {
            throw NSError(domain: "Error Fetching Data", code: 0, userInfo: nil)
        }
    }
}
