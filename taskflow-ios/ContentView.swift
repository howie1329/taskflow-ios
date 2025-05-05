//
//  ContentView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggin = false
    
    var body: some View {
        if isLoggin {
            TabUIView()
        } else {
            AuthUIScreen(isLoggin: $isLoggin)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
