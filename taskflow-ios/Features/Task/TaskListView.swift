//
//  TaskListView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/8/25.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var isPresented = false
    @State var selectedTask: TaskEvent?
    @State var showingEventSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if taskViewModel.isLoading {
                    ProgressView("Loading tasks...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    taskContent
                }
            }
            .eventViewSheet(isPresented: $showingEventSheet)
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        taskViewModel.addTask()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Event") {
                        showingEventSheet = true
                    }
                }
            }
        }
    }
    
    private var taskContent: some View {
        Group {
            if taskViewModel.taskArr.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("No tasks yet!")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Add a new task to get started.")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.7))
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(taskViewModel.taskArr) { task in
                            Button {
                                isPresented.toggle()
                                selectedTask = task
                            } label: {
                                TaskListItem(task: task)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
                .TaskDetailSheetAppearRounded(isPresented: $isPresented, task: selectedTask)
                .background(Color(.systemGroupedBackground))
            }
        }
    }
}

#Preview {
    TaskListView()
}

struct TaskListItem: View {
    var task: TaskEvent
    
    var priorityColor: Color {
        switch task.priority.lowercased() {
        case "high": return .red
        case "medium": return .orange
        case "low": return .green
        default: return .blue
        }
    }
    
    var formattedDate: String {
        guard let dateString = task.date,
              let date = ISO8601DateFormatter().date(from: dateString) else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if task.isCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .imageScale(.large)
                        .padding(.top, 2)
                }
            }
            HStack {
                Label(formattedDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "flag.fill")
                        .foregroundColor(priorityColor)
                        .font(.caption)
                    Text(task.priority.capitalized)
                        .font(.caption)
                        .foregroundColor(priorityColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(priorityColor.opacity(0.15))
                        .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}
