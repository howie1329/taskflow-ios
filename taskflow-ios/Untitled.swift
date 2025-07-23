//
//  Untitled.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()

var dummyTaskArray: [TaskEvent] = [
    TaskEvent(
        id: UUID().uuidString,
        title: "Complete Project Proposal",
        description: "Write and submit the project proposal for the new client",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400 * 2)),
        priority: "high",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Grocery Shopping",
        description: "Buy groceries for the week including fruits and vegetables",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400)),
        priority: "medium",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Team Meeting",
        description: "Weekly team sync to discuss project progress",
        date: dateFormatter.string(from: Date().addingTimeInterval(3600 * 2)),
        priority: "high",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Gym Session",
        description: "Complete the scheduled workout routine",
        date: dateFormatter.string(from: Date().addingTimeInterval(3600 * 4)),
        priority: "medium",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Read Book",
        description: "Read chapters 5-7 of the current book",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400 * 3)),
        priority: "low",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Doctor Appointment",
        description: "Annual physical checkup",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400 * 5)),
        priority: "high",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Call Mom",
        description: "Catch up with mom over the phone",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400)),
        priority: "medium",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Submit Expense Report",
        description: "Submit last month's expense report to finance",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400 * 2)),
        priority: "high",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Car Maintenance",
        description: "Take the car for oil change and tire rotation",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400 * 7)),
        priority: "low",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Yoga Class",
        description: "Attend the weekly yoga class at the community center",
        date: dateFormatter.string(from: Date().addingTimeInterval(3600 * 24)),
        priority: "medium",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Finish Online Course",
        description: "Complete the final module and quiz",
        date: dateFormatter.string(from: Date().addingTimeInterval(-86400)),
        priority: "high",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Laundry",
        description: "Wash and fold clothes",
        date: dateFormatter.string(from: Date().addingTimeInterval(3600 * 6)),
        priority: "low",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Submit Tax Documents",
        description: "Send tax documents to accountant",
        date: dateFormatter.string(from: Date().addingTimeInterval(-86400 * 2)),
        priority: "high",
        isCompleted: false
    ),
    TaskEvent(
        id: UUID().uuidString,
        title: "Plan Vacation",
        description: "Research and book flights and hotels",
        date: dateFormatter.string(from: Date().addingTimeInterval(86400 * 10)),
        priority: "medium",
        isCompleted: false
    )
]

// ... existing code ...
