//
//  AuthUIScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct AuthUIScreen: View {
    enum AuthTab: String, CaseIterable, Identifiable {
        case signIn = "Sign In"
        case signUp = "Sign Up"
        var id: String { self.rawValue }
    }

    @State private var selectedTab: AuthTab = .signIn

    var body: some View {
        VStack(spacing: 32) {
            // App Title or Logo
            Text("TaskFlow")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            Picker("Authentication", selection: $selectedTab) {
                ForEach(AuthTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if selectedTab == .signIn {
                SignInScreen()
            } else {
                SignUpScreen()
            }
        }
    }
}