//
//  TabUIView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct TabUIView: View {
    @State private var selectedTab: Int = 2

    var body: some View {
        TabView(selection: $selectedTab) {
            TasksScreen()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle.fill")
                }
                .tag(0)
            NotesScreen()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(1)
            DashboardScreen()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(2)
            ProjectsScreen()
                .tabItem {
                    Label("Projects", systemImage: "folder.fill")
                }
                .tag(3)
            EventsScreen()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
                .tag(4)
        }
        .accentColor(.purple) // Optional: customize selected tab color
    }
}

struct TabUIView_Previews: PreviewProvider {
    static var previews: some View {
        TabUIView()
    }
}
