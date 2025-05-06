//
//  Untitled.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import Foundation

var dummyTaskArray: [Tasks] = [
    Tasks(
        id: UUID(),
        title: "Complete Project Proposal",
        description: "Write and submit the project proposal for the new client",
        dueDate: Date().addingTimeInterval(86400 * 2), // 2 days from now
        priority: .high,
        isCompleted: false,
        category: ["Work"],
        status: .inProgress
    ),
    Tasks(
        id: UUID(),
        title: "Grocery Shopping",
        description: "Buy groceries for the week including fruits and vegetables",
        dueDate: Date().addingTimeInterval(86400), // 1 day from now
        priority: .medium,
        isCompleted: false,
        category: ["Personal"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Team Meeting",
        description: "Weekly team sync to discuss project progress",
        dueDate: Date().addingTimeInterval(3600 * 2), // 2 hours from now
        priority: .high,
        isCompleted: false,
        category: ["Work"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Gym Session",
        description: "Complete the scheduled workout routine",
        dueDate: Date().addingTimeInterval(3600 * 4), // 4 hours from now
        priority: .medium,
        isCompleted: false,
        category: ["Health"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Read Book",
        description: "Read chapters 5-7 of the current book",
        dueDate: Date().addingTimeInterval(86400 * 3), // 3 days from now
        priority: .low,
        isCompleted: false,
        category: ["Personal","Self Growth"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Doctor Appointment",
        description: "Annual physical checkup",
        dueDate: Date().addingTimeInterval(86400 * 5), // 5 days from now
        priority: .high,
        isCompleted: false,
        category: ["Health"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Call Mom",
        description: "Catch up with mom over the phone",
        dueDate: Date().addingTimeInterval(86400), // 1 day from now
        priority: .medium,
        isCompleted: false,
        category: ["Personal"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Submit Expense Report",
        description: "Submit last month's expense report to finance",
        dueDate: Date().addingTimeInterval(86400 * 2), // 2 days from now
        priority: .high,
        isCompleted: false,
        category: ["Work"],
        status: .inProgress
    ),
    Tasks(
        id: UUID(),
        title: "Car Maintenance",
        description: "Take the car for oil change and tire rotation",
        dueDate: Date().addingTimeInterval(86400 * 7), // 7 days from now
        priority: .low,
        isCompleted: false,
        category: ["Personal"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Yoga Class",
        description: "Attend the weekly yoga class at the community center",
        dueDate: Date().addingTimeInterval(3600 * 24), // 1 day from now
        priority: .medium,
        isCompleted: false,
        category: ["Health"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Finish Online Course",
        description: "Complete the final module and quiz",
        dueDate: Date().addingTimeInterval(-86400), // 1 day ago (overdue)
        priority: .high,
        isCompleted: false,
        category: ["Self Growth"],
        status: .overDue
    ),
    Tasks(
        id: UUID(),
        title: "Laundry",
        description: "Wash and fold clothes",
        dueDate: Date().addingTimeInterval(3600 * 6), // 6 hours from now
        priority: .low,
        isCompleted: false,
        category: ["Personal"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Submit Tax Documents",
        description: "Send tax documents to accountant",
        dueDate: Date().addingTimeInterval(-86400 * 2), // 2 days ago (overdue)
        priority: .high,
        isCompleted: false,
        category: ["Finance"],
        status: .overDue
    ),
    Tasks(
        id: UUID(),
        title: "Plan Vacation",
        description: "Research and book flights and hotels",
        dueDate: Date().addingTimeInterval(86400 * 10), // 10 days from now
        priority: .medium,
        isCompleted: false,
        category: ["Personal"],
        status: .notStarted
    ),
    Tasks(
        id: UUID(),
        title: "Update Resume",
        description: "Add recent experience and skills",
        dueDate: Date().addingTimeInterval(86400 * 4), // 4 days from now
        priority: .medium,
        isCompleted: true,
        category: ["Work"],
        status: .completed
    )
]

// ... existing code ...