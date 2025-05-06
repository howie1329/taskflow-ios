//
//  ContentView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI
import Clerk

struct ContentView: View {
    @State private var isLoggin = false
    @Environment(Clerk.self) private var clerk
    
    var body: some View {
        VStack{
            if let user = clerk.user {
                TabUIView()
            } else {
                AuthUIScreen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
