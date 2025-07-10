//
//  TaskDetailSheetView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/8/25.
//

import SwiftUI

struct TaskDetailSheetView: View {
    var task: TaskEvent
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with title and completion status
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        // Priority badge
                        HStack {
                            priorityBadge
                            Spacer()
                            completionStatus
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Divider()
                
                // Description section
                if !task.description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(task.description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // Date section
                if let date = task.date, !date.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due Date")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(date)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Priority details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Priority")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: priorityIcon)
                            .foregroundColor(priorityColor)
                        Text(task.priority.capitalized)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                
                // Task ID (for debugging/reference)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task ID")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(task.id)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Computed Properties
    
    private var priorityBadge: some View {
        Text(task.priority.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priorityColor.opacity(0.2))
            .foregroundColor(priorityColor)
            .cornerRadius(8)
    }
    
    private var completionStatus: some View {
        HStack(spacing: 4) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
            Text(task.isCompleted ? "Completed" : "Pending")
                .font(.caption)
                .foregroundColor(task.isCompleted ? .green : .gray)
        }
    }
    
    private var priorityColor: Color {
        switch task.priority.lowercased() {
        case "high":
            return .red
        case "medium":
            return .orange
        case "low":
            return .green
        default:
            return .gray
        }
    }
    
    private var priorityIcon: String {
        switch task.priority.lowercased() {
        case "high":
            return "exclamationmark.triangle.fill"
        case "medium":
            return "exclamationmark.circle.fill"
        case "low":
            return "arrow.down.circle.fill"
        default:
            return "circle.fill"
        }
    }
}


extension View {
    func TaskDetailSheetAppear(isPresented: Binding<Bool>, task: TaskEvent?) -> some View{
        self.sheet(isPresented: isPresented) {
            if let task = task{
                NavigationView{
                    TaskDetailSheetView(task: task)
                }
                .presentationDetents([.medium])
                .presentationCornerRadius(2)
                .presentationDragIndicator(.visible)
            }
            
        }
    }
}

extension View {
    func TaskDetailSheetAppearRounded(isPresented: Binding<Bool>, task: TaskEvent?) -> some View {
        self.overlay(
            ZStack {
                if isPresented.wrappedValue {
                    // Background overlay
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isPresented.wrappedValue = false
                        }
                    
                    // Custom rounded sheet
                    VStack {
                        Spacer()
                        
                        if let task = task {
                            NavigationView {
                                TaskDetailSheetView(task: task)
                            }
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5) // Space from bottom
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isPresented.wrappedValue)
        )
    }
}
