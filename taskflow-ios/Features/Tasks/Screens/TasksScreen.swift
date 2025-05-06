//
//  TasksScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct TasksScreen: View {
    @State private var selectedTask: Tasks?
    @State private var filterSheetIsPresented: Bool = false
    @State private var selectedFilter: TaskStatus = .all
    @State private var activeFilter: Bool = false
    @State private var selectedPriority: Tasks.Priority = .low

    var filteredTask: [Tasks] {
        dummyTaskArray.filter { task in
            let statusMatches = selectedFilter == .all || task.status == selectedFilter
            let priorityMatches = !activeFilter || task.priority == selectedPriority
            return statusMatches && priorityMatches
        }
    }
    var body: some View {
        NavigationStack{
            Picker("Status", selection: $selectedFilter) {
                ForEach(TaskStatus.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(status)
                }
            }
            .pickerStyle(.automatic)
            .padding(.horizontal)
            ScrollView{
                LazyVStack{
                    if filteredTask.isEmpty{
                        VStack(spacing: 4){
                            Image("TaskListEmptyState")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .opacity(0.5)
                            Text("No Tasks Found")
                                .foregroundStyle(.gray)
                                .font(.headline)
                        }
                        
                    } else{
                        ForEach(filteredTask){item in
                           NavigationLink(destination: IndividualTaskScreen(singleTask: item)){
                                SingleTaskListItem(task: item)
                            }
                           
                        }
                    }}
                .padding(.horizontal)
            }
            .navigationTitle("Tasks")
            .toolbar{
                Button{
                    filterSheetIsPresented.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.black)
                }
            }
        }
        .sheet(isPresented: $filterSheetIsPresented) {
            TaskFilterSheet(selectedPriority: $selectedPriority, activeFilter: $activeFilter, filterSheetIsPresented: $filterSheetIsPresented)
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    TasksScreen()
}

