//
//  TasksScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct TasksScreen: View {
    @State private var sheetIsActive: Bool = false
    @State private var selectedFilter: TaskStatus = .all
    @State private var activeFilter: Bool = false
    @State private var selectedPriority: Tasks.Priority = .low
    @State private var actionSheetIsActive: Bool = false
    @State private var createTaskSheet: Bool = false
    @State private var selectedTask: Tasks?

    var filteredTask: [Tasks] {
        dummyTaskArray.filter { task in
            let statusMatches = selectedFilter == .all || task.status == selectedFilter
            let priorityMatches = !activeFilter || task.priority == selectedPriority
            return statusMatches && priorityMatches
        }
    }
    var body: some View {
            NavigationStack{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 8){
                        ForEach(TaskStatus.allCases, id: \.self){status in
                            Button{
                                selectedFilter = status
                            } label: {
                                Text(status.rawValue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background(selectedFilter == status ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .foregroundStyle(selectedFilter == status ? .blue : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                            }
                        }
                    }
                }
                .padding(.horizontal)
                Button{
                    createTaskSheet.toggle()
                }label: {
                    HStack{
                        Image(systemName: "plus")
                        Text("New Task")
                            
                    }
                    .font(.headline)
                    .frame(maxWidth:.infinity)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false){
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
                                Button {
                                    selectedTask = item
                                } label: {
                                    SingleTaskListItem(task: item)
                                }

                               
                            }
                        }}
                    .padding(.horizontal)
                }
                .toolbar{
                        Button{
                            sheetIsActive.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundStyle(.black)
                        }
                }
            }
            .sheet(isPresented: $sheetIsActive) {
                TaskFilterSheet(selectedPriority: $selectedPriority, activeFilter: $activeFilter, filterSheetIsPresented: $sheetIsActive)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $createTaskSheet) {
                CreateTaskScreen()
           }
            .sheet(item: $selectedTask) { task in
                TaskDetailsScreen(singleTask: task)
                    .presentationDetents([.medium])
            }
        
    }
}

#Preview {
    TasksScreen()
}

