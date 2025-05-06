//
//  IndividualTaskScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import SwiftUI

struct IndividualTaskScreen: View {
    var singleTask: Tasks

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Title and Completion
                HStack {
                    Text(singleTask.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: singleTask.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(singleTask.isCompleted ? .green : .gray)
                        .font(.title)
                }

                // Description
                if !singleTask.description.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(singleTask.description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }

                // Due Date and Priority
                HStack {
                    VStack(alignment: .leading) {
                        Text("Due Date")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(singleTask.dueDate, style: .date)
                            .font(.body)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Priority")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(singleTask.priority.rawValue.capitalized)
                            .font(.body)
                            .foregroundColor(priorityColor(singleTask.priority))
                    }
                }

                // Categories
                if !singleTask.category.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Categories")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        HStack {
                            ForEach(singleTask.category, id: \.self) { cat in
                                Text(cat)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    // Helper for priority color
    func priorityColor(_ priority: Tasks.Priority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
}

#Preview {
    IndividualTaskScreen(singleTask: Tasks(id: UUID(), title: "HomeWork", description: "Simple Homework Needs To Be Done", dueDate: Date.now, priority: .high, isCompleted: false, category: ["School","Grades"]))
}
