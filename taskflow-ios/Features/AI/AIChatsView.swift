//
//  AIChatsView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/9/25.
//

import SwiftUI

struct AIChatsView: View {
    @State var aiDataService = AiDataService.shared
    @State private var showingAiSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            if aiDataService.chatThreads.isEmpty {
                VStack(spacing: 24) {
                    Spacer()
                    
                    // AI-themed empty state
                    VStack(spacing: 16) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.purple.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("No Chat Threads")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Start a conversation with your AI assistant to get help with tasks, ask questions, or get insights about your productivity.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    
                    // Call-to-action button
                    Button(action: {
                        aiDataService.appendThread(MainChatThread(title: "Number 1"))
                        aiDataService.currentMainThread = aiDataService.chatThreads.last
                        showingAiSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Start New Chat")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                List(aiDataService.chatThreads) { item in
                    NavigationLink(item.title) {
                        AiAnswerSheet(mainChatThread: item)
                    }
                }
            }
        }
        .navigationTitle("AI Chats")
        .navigationBarTitleDisplayMode(.large)
        .aiAnswerSheet(isPresented: $showingAiSheet, mainChatThread: aiDataService.currentMainThread ?? MainChatThread(title: "Error"))
    }
}

#Preview {
    AIChatsView()
}
