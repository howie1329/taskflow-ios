//
//  TasksScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct TasksScreen: View {
    @State private var selectedTask: Tasks?
    var body: some View {
        NavigationStack{
            VStack{
                List(dummyTaskArray){item in
                    SingleTaskListItem(task: item)
                }
            }
            .navigationTitle("Tasks")
        }
    }
}

#Preview {
    TasksScreen()
}
