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
        NavigationStack{
            VStack{
                        if taskViewModel.isLoading {
                            ProgressView("Loading tasks...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }else {
                            
                            
                            if !taskViewModel.aiChat.isEmpty{
                                VStack(alignment: .leading) {
                                        Text("AI Response:")
                                            .font(.headline)
                                        Text(taskViewModel.aiChat)
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                    .padding()
                            }
                            
                            List(taskViewModel.taskArr){task in
                                VStack(alignment: .leading, spacing: 4) {
                                        Text(task.title)
                                            .font(.headline)
                                        Text(task.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        HStack {
                                            if let date = task.date{
                                                Text(date)
                                                    .font(.caption)
                                            }
                                            Spacer()
                                            Text(task.priority.capitalized)
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 2)
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(4)
                                        }
                                    }
                                    .padding(.vertical, 2)
                            }
                        }
                            
                    }
            .navigationTitle(Text("Task Flow"))
            .toolbar{
                ToolbarItem(placement:.topBarTrailing){
                    Button {
                        taskViewModel.addTask()
                    } label: {
                        Text("Add Task")
                    }
                }
            }
            .task {
                await taskViewModel.loadTasks()
            }
        }
        
    }
}


#Preview {
    ContentView()
}
