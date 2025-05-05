//
//  TabUIView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct TabUIView: View {
    var body: some View {
        TabView{
            DashboardScreen()
                .badge(0)
                .tabItem {
                    Label("Dashboard", systemImage: "person.crop.circle.fill")
                }
            TasksScreen()
                .badge(0)
                .tabItem {
                    Label("Tasks", systemImage: "person.crop.circle.fill")
                }
            NotesScreen()
                .badge(0)
                .tabItem {
                    Label("Notes", systemImage: "person.crop.circle.fill")
                }
            ProjectsScreen()
                .badge(0)
                .tabItem {
                    Label("Projects", systemImage: "person.crop.circle.fill")
                }
            EventsScreen()
                .badge(0)
                .tabItem {
                    Label("Events", systemImage: "person.crop.circle.fill")
                }
            
        }
    }
}

struct TabUIView_Previews: PreviewProvider {
    static var previews: some View {
        TabUIView()
    }
}
