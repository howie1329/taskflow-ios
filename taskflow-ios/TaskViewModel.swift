//
//  Untitled 2.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/2/25.
//

import Foundation
import SwiftData

@Observable
class TaskViewModel:ObservableObject {
    
    var taskArr: [TaskEvent] = []
    var aiChat: String = ""
    var isLoading: Bool = false
    
    init(){
       
    }
    
    func loadTasks() async {
        self.isLoading = true
        NetworkService.shared.fetchTasksFromServer(userId: "user_2usb0Md2SjCvMehu1XHJBN2y03c") { result in
            switch result {
            case .success(let tasks):
                print("Fetched Tasks Complete")
                self.taskArr = tasks
            case .failure(let error):
                print("Error fetching tasks: \(error)")
            }
        }
        
        self.isLoading = false
        
        AINetworkService.shared.fetchAiResponse{ result in
            switch result {
            case .success(let response):
                print("Fetched AI Response \(response)")
                self.aiChat = response
            case .failure(let error):
                print("Error fetching AI response: \(error)")
            }
        }
        
        
    }
    
    func addTask(){
        taskArr.append(TaskEvent(
            id: "UUID()",
            title: "Update Resume",
            description: "Add recent experience and skills",
            date: "11/15/2025", // 4 days from now
            priority: "medium",
            isCompleted: true,
        ))
    }
    
}
