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
    var isLoading: Bool = false // Keep this for general task loading
    private let userID = "user_2usb0Md2SjCvMehu1XHJBN2y03c"
    
    init(){
       
    }
    
    @MainActor
    func loadTasks() async {
        self.isLoading = true
        
        defer{
            self.isLoading = false
        }
        await withTaskGroup(of: Void.self){group in
            group.addTask {
                await self.loadTaskFromServer()
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
    
    @MainActor
    private func loadTaskFromServer() async {
        do{
            let response = try await NetworkService.shared.fetchTasksFromServer(userId: userID)
            self.taskArr = response
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    /*
    @MainActor
    private func loadAiResponse() async {
        do{
            let response = try await AINetworkService.shared.fetchAiResponse(prompt: "What is 2 + 2")
            self.aiChat = response
        } catch {
            print("Error fetching AI response: \(error)")
        }
    }
    
    @MainActor
    func loadAiQuestionResponse(userPrompt: String) async {
        do{
            let response = try await AINetworkService.shared.fetchAiResponse(prompt: userPrompt)
            self.aiChat = response
        } catch {
            print("Error fetching AI response: \(error)")
        }
    } */
    
    @MainActor
    func askAiTaskQuestion(userPromot: String, chatHistory: [NewChatMessage]? = nil) async {
        let aiDataService = AiDataService.shared
        
        do{
            await aiDataService.setAiLoading(true)
            self.aiChat = try await AINetworkService.shared.AiTaskResponseAPICall(taskContext: self.taskArr, userPrompt: userPromot, chatHistory: chatHistory, userId: self.userID)
            await aiDataService.setAiLoading(false)
        } catch {
            await aiDataService.setAiError("Failed to get AI response. Please try again.")
            print("Error fetching AI response: \(error)")
        }
    }
    
}
