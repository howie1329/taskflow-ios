//
//  DashboardView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/9/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var showingAiSheet: Bool = false
    @State private var showingEventSheet: Bool = false
    @State private var selectedTimeFilter: TimeFilter = .today
    
    enum TimeFilter: String, CaseIterable {
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header with quick stats
                    statsHeaderView
                    
                    // Quick actions
                    quickActionsView
                    
                    // Recent tasks
                    recentTasksView
                    
                    // Priority breakdown
                    priorityBreakdownView
                    
                    // Upcoming deadlines
                    upcomingDeadlinesView
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
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
            }
            .aiAnswerSheet(isPresented: $showingAiSheet)
            .eventViewSheet(isPresented: $showingEventSheet)
            .task {
                await taskViewModel.loadTasks()
            }
        }
    }
    
    // MARK: - Stats Header View
    private var statsHeaderView: some View {
        VStack(spacing: 16) {
            // Time filter picker
            Picker("Time Filter", selection: $selectedTimeFilter) {
                ForEach(TimeFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            
            // Stats cards
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                StatCard(
                    title: "Total Tasks",
                    value: "\(filteredTasks.count)",
                    icon: "checklist",
                    color: .blue
                )
                
                StatCard(
                    title: "Completed",
                    value: "\(completedTasks.count)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatCard(
                    title: "In Progress",
                    value: "\(inProgressTasks.count)",
                    icon: "clock.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Overdue",
                    value: "\(overdueTasks.count)",
                    icon: "exclamationmark.triangle.fill",
                    color: .red
                )
            }
        }
    }
    
    // MARK: - Quick Actions View
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                QuickActionCard(
                    title: "Ask AI",
                    subtitle: "Get help with tasks",
                    icon: "brain.head.profile",
                    color: .purple
                ) {
                    showingAiSheet = true
                }
                
                QuickActionCard(
                    title: "Events",
                    subtitle: "View calendar",
                    icon: "calendar",
                    color: .blue
                ) {
                    showingEventSheet = true
                }
                
                QuickActionCard(
                    title: "Add Task",
                    subtitle: "Create new task",
                    icon: "plus.circle",
                    color: .green
                ) {
                    taskViewModel.addTask()
                }
                
                QuickActionCard(
                    title: "Analytics",
                    subtitle: "View insights",
                    icon: "chart.bar.fill",
                    color: .orange
                ) {
                    // Analytics action
                }
            }
        }
    }
    
    // MARK: - Recent Tasks View
    private var recentTasksView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Tasks")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink("View All") {
                    TaskListView()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            if taskViewModel.taskArr.isEmpty {
                EmptyStateView(
                    icon: "tray",
                    title: "No tasks yet",
                    subtitle: "Add your first task to get started"
                )
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(taskViewModel.taskArr.prefix(3))) { task in
                        RecentTaskRow(task: task)
                    }
                }
            }
        }
    }
    
    // MARK: - Priority Breakdown View
    private var priorityBreakdownView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority Breakdown")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                PriorityRow(
                    priority: "High",
                    count: highPriorityTasks.count,
                    total: filteredTasks.count,
                    color: .red
                )
                
                PriorityRow(
                    priority: "Medium",
                    count: mediumPriorityTasks.count,
                    total: filteredTasks.count,
                    color: .orange
                )
                
                PriorityRow(
                    priority: "Low",
                    count: lowPriorityTasks.count,
                    total: filteredTasks.count,
                    color: .green
                )
            }
        }
    }
    
    // MARK: - Upcoming Deadlines View
    private var upcomingDeadlinesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Deadlines")
                .font(.headline)
                .fontWeight(.semibold)
            
            let upcomingTasks = getUpcomingTasks()
            
            if upcomingTasks.isEmpty {
                EmptyStateView(
                    icon: "calendar.badge.clock",
                    title: "No upcoming deadlines",
                    subtitle: "You're all caught up!"
                )
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(upcomingTasks.prefix(3)) { task in
                        DeadlineRow(task: task)
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var filteredTasks: [TaskEvent] {
        let calendar = Calendar.current
        let now = Date()
        
        return taskViewModel.taskArr.filter { task in
            guard let dateString = task.date,
                  let taskDate = ISO8601DateFormatter().date(from: dateString) else { return false }
            
            switch selectedTimeFilter {
            case .today:
                return calendar.isDate(taskDate, inSameDayAs: now)
            case .week:
                let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
                let weekEnd = calendar.dateInterval(of: .weekOfYear, for: now)?.end ?? now
                return taskDate >= weekStart && taskDate <= weekEnd
            case .month:
                let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
                let monthEnd = calendar.dateInterval(of: .month, for: now)?.end ?? now
                return taskDate >= monthStart && taskDate <= monthEnd
            }
        }
    }
    
    private var completedTasks: [TaskEvent] {
        filteredTasks.filter { $0.isCompleted }
    }
    
    private var inProgressTasks: [TaskEvent] {
        filteredTasks.filter { !$0.isCompleted }
    }
    
    private var overdueTasks: [TaskEvent] {
        let now = Date()
        return filteredTasks.filter { task in
            guard let dateString = task.date,
                  let taskDate = ISO8601DateFormatter().date(from: dateString) else { return false }
            return !task.isCompleted && taskDate < now
        }
    }
    
    private var highPriorityTasks: [TaskEvent] {
        filteredTasks.filter { $0.priority.lowercased() == "high" }
    }
    
    private var mediumPriorityTasks: [TaskEvent] {
        filteredTasks.filter { $0.priority.lowercased() == "medium" }
    }
    
    private var lowPriorityTasks: [TaskEvent] {
        filteredTasks.filter { $0.priority.lowercased() == "low" }
    }
    
    // MARK: - Helper Methods
    private func getUpcomingTasks() -> [TaskEvent] {
        let now = Date()
        let calendar = Calendar.current
        let weekFromNow = calendar.date(byAdding: .day, value: 7, to: now) ?? now
        
        return taskViewModel.taskArr.filter { task in
            guard let dateString = task.date,
                  let taskDate = ISO8601DateFormatter().date(from: dateString) else { return false }
            return !task.isCompleted && taskDate >= now && taskDate <= weekFromNow
        }.sorted { task1, task2 in
            guard let date1 = ISO8601DateFormatter().date(from: task1.date ?? ""),
                  let date2 = ISO8601DateFormatter().date(from: task2.date ?? "") else { return false }
            return date1 < date2
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentTaskRow: View {
    let task: TaskEvent
    
    var priorityColor: Color {
        switch task.priority.lowercased() {
        case "high": return .red
        case "medium": return .orange
        case "low": return .green
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(priorityColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(task.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct PriorityRow: View {
    let priority: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(priority)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(count)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            ProgressView(value: percentage)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(width: 60)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct DeadlineRow: View {
    let task: TaskEvent
    
    private var daysUntilDeadline: Int {
        guard let dateString = task.date,
              let taskDate = ISO8601DateFormatter().date(from: dateString) else { return 0 }
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: taskDate)
        return components.day ?? 0
    }
    
    private var deadlineColor: Color {
        if daysUntilDeadline <= 1 {
            return .red
        } else if daysUntilDeadline <= 3 {
            return .orange
        } else {
            return .green
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(task.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("\(daysUntilDeadline) days")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(deadlineColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(deadlineColor.opacity(0.15))
                .cornerRadius(6)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.gray.opacity(0.5))
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.gray)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    DashboardView()
        .environmentObject(TaskViewModel())
}
