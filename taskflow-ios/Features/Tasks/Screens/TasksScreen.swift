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
    @State private var selectedFilter: TaskStatus = .completed
    @State private var activeFilter: Bool = false
    @State private var selectedPriority: Tasks.Priority = .low
    var filteredTask: [Tasks] {
        dummyTaskArray.filter{ !activeFilter || ($0.status == selectedFilter && $0.priority == selectedPriority) }
    }
    var body: some View {
        NavigationStack{
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
                            SingleTaskListItem(task: item)
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
            VStack(spacing: 24) {
                Text("Filter For Tasks")
                    .font(.headline)
                    .padding(.top)
                
                // Task Status Picker
                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    Picker("Status", selection: $selectedFilter) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Priority Picker
                VStack(alignment: .leading) {
                    Text("Priority")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(Tasks.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                HStack {
                    Button("Apply Filter") {
                        activeFilter = true
                        filterSheetIsPresented.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reset") {
                        activeFilter = false
                        filterSheetIsPresented.toggle()
                        // Optionally reset pickers to default values:
                        // selectedFilter = .completed
                        // selectedPriority = .low
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    TasksScreen()
}

