//
//  TaskFilterSheet.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/6/25.
//

import SwiftUI

struct TaskFilterSheet: View {
    @Binding var selectedPriority: Tasks.Priority
    @Binding var activeFilter: Bool
    @Binding var filterSheetIsPresented: Bool

    var body: some View {
        VStack(spacing: 24) {
            Text("Filter For Tasks")
                .font(.headline)
                .padding(.top)
            
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
                    // selectedPriority = .low
                }
                .buttonStyle(.bordered)
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    // Provide .constant values for preview
    TaskFilterSheet(
        selectedPriority: .constant(.low),
        activeFilter: .constant(false),
        filterSheetIsPresented: .constant(false)
    )
}
