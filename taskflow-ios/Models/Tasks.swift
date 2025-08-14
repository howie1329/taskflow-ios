//
//  Task.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import Foundation

enum TaskStatus: String, CaseIterable{
    case all = "All"
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
    case overDue = "Over Due"
}


struct TaskEvent: Codable, Identifiable{
    let id: String
    let title: String
    var description: String
    var date: String?
    var priority: String
    var isCompleted: Bool
}
