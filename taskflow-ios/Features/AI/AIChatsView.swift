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
            VStack {
                if aiDataService.chatThreads.isEmpty {
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
                        aiDataService.appendThread(MainChatThread(title: UUID().uuidString))
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
                } else {
                    List(aiDataService.chatThreads) { item in
                        NavigationLink(item.title) {
                            AiAnswerSheet(mainChatThread: item)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                aiDataService.removeThread(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .toolbar{
                if !aiDataService.chatThreads.isEmpty {
                    Button {
                        aiDataService.appendThread(MainChatThread(title: UUID().uuidString))
                        aiDataService.currentMainThread = aiDataService.chatThreads.last
                        showingAiSheet = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "brain.head.profile")
                                .font(.caption)
                            Text("New AI Chat")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .navigationTitle("AI Chats")
            .navigationBarTitleDisplayMode(.large)
        }
        
        .aiAnswerSheet(isPresented: $showingAiSheet, mainChatThread: aiDataService.currentMainThread ?? MainChatThread(title: "Error"))
    }
}

#Preview {
    AIChatsView()
}
