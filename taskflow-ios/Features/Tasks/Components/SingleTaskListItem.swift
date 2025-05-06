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

    var priorityText: String {
        switch task.priority {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Status dot
            Circle()
                .fill(task.isCompleted ? Color.green : Color.gray.opacity(0.4))
                .frame(width: 14, height: 14)

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center) {
                    Text(task.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .strikethrough(task.isCompleted, color: .gray)
                        .lineLimit(1)
                    if task.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    // Priority pill
                    Text(priorityText)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(priorityColor.opacity(0.15))
                        .foregroundColor(priorityColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(priorityColor, lineWidth: 1)
                        )
                        .cornerRadius(12)
                }
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                HStack {
                    // Due date
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(task.dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    // Category tags
                    ForEach(task.category, id: \.self) { category in
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
        .padding(16)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray6), lineWidth: 1)
        )
        .padding(.vertical, 4)
    }
}

#Preview {
    SingleTaskListItem(task: Tasks(id: UUID(), title: "HomeWork", description: "Simple Homework Needs To Be Done", dueDate: Date.now, priority: .high, isCompleted: false, category: ["School","Grades"]))
}
