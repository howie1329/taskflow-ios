//
//  taskflow_iosApp.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI
import Clerk

@main
struct taskflow_iosApp: App {
    @State private var clerk = Clerk.shared
    
    var body: some Scene {
        WindowGroup {
            VStack{
                ContentView()
            }
            .environment(clerk)
            .task {
                clerk.configure(publishableKey: "pk_test_aW52aXRpbmctbWlubm93LTk2LmNsZXJrLmFjY291bnRzLmRldiQ")
                try? await clerk.load()
            }
        }
    }
}
