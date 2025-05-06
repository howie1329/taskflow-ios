//
//  SingleTaskListItem.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import SwiftUI

struct SingleTaskListItem: View {
    var task: Tasks

    var priorityColor: Color {
        switch task.priority {
        case .high: return .red
        case .medium: return .yellow
        case .low: return .green
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Priority indicator
            Circle()
                .fill(priorityColor)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title)
                        .font(.headline)
                        .strikethrough(task.isCompleted, color: .gray)
                    if task.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    // Due date
                    Text(task.dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                // Category tag
                if !task.category.isEmpty {
                    HStack {
                        ForEach(task.category, id: \.self){ category in
                            Text(category)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }
                    }
                   
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SingleTaskListItem(task: Tasks(id: UUID(), title: "HomeWork", description: "Simple Homework Needs To Be Done", dueDate: Date.now, priority: .high, isCompleted: false, category: ["School","Grades"]))
}
