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
    
   
    
    func fetchTasksFromServer(userId: String, completion: @escaping (Result<[TaskEvent], Error>) -> Void) {
        let baseUrl = "https://taskflow-backend-production-8812.up.railway.app"
        let urlString = "\(baseUrl)/api/test-ai/fetch-tasks/\(userId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Bad URL", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do{
                let taskResponse = try JSONDecoder().decode(TasksResponse.self, from: data)
                completion(.success(taskResponse.tasks))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
        //let tasks:[Tasks] = dummyTaskArray
        //return tasks
    }
}
