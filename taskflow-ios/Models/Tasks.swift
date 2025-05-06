//
//  Task.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import Foundation

struct Task: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    var category: String
    
    enum Priority: String {
        case low
        case medium
        case high
    }
}
