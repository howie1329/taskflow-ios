//
//  Task.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import Foundation

struct Tasks: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    var category: [String]
    var status: TaskStatus = .notStarted
    
    enum Priority: String, CaseIterable{
        case low
        case medium
        case high
    }
}

enum TaskStatus: String, CaseIterable{
    case all = "All"
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
    case overDue = "Over Due"
}
