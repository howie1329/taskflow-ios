//
//  ContentView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var showingAiSheet: Bool = false
    @State var showingEventSheet: Bool = false
    
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
        }
        .aiAnswerSheet(isPresented: $showingAiSheet)
        .eventViewSheet(isPresented: $showingEventSheet)
        .task {
            await taskViewModel.loadTasks()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskViewModel())
}
