//
//  ContentView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        TabView {
            // Dashboard Tab
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Dashboard")
                }
            
            // Tasks Tab
            TaskListView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Tasks")
                }
            // AI Main Chat Tab
            ChatView()
                .tabItem{
                    Image(systemName: "brain.head.profile")
                    Text("AI")
                }
            AIChatsView()
                .tabItem{
                    Image(systemName: "brain.head.profile")
                    Text("DEV")
                }
        }
        .task {
            await taskViewModel.loadTasks()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskViewModel())
}
