//
//  taskflow_iosApp.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

@main
struct taskflow_iosApp: App {
    @StateObject var taskviewModel = TaskViewModel()
    
    var body: some Scene {
        WindowGroup {
           ContentView()
            //EventView()
            }
        .environmentObject(taskviewModel)
        }
    }
