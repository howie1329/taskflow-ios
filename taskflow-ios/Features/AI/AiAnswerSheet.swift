//
//  AiAnswerSheet.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/3/25.
//

import SwiftUI

struct AiAnswerSheet: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var mainChatThread: MainChatThread
    @State private var userPrompt: String = ""
    @State private var isPresented: Bool = false
    var messages:[NewChatMessage] {
        return mainChatThread.messages
    }
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Chat Messages
            chatMessagesView
            
            // Input Section
            inputSection
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            setupWelcomeMessage()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mainChatThread.title)
                    Text("AI Assistant")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Ask me anything about your tasks")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: clearChat) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                .opacity(messages.count > 1 ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: messages.count)
            }
            
            Divider()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Chat Messages View
    private var chatMessagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(mainChatThread.messages) { item in
                        ChatBubbleView(message: item)
                            .id(item.id)
                    }
                    
                    if taskViewModel.isLoading {
                        TypingIndicator()
                            .id("typing")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .onChange(of: mainChatThread.messages.count) { _, _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo(messages.last?.id ?? "typing", anchor: .bottom)
                }
            }
            .onChange(of: taskViewModel.isLoading) { _, isLoading in
                if isLoading {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo("typing", anchor: .bottom)
                    }
                }
            }
        }
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                TextField("Ask me anything...", text: $userPrompt, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .lineLimit(1...4)
                    .focused($isTextFieldFocused)
                
                Button(action: sendMessage) {
                    Image(systemName: taskViewModel.isLoading ? "stop.fill" : "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(canSendMessage ? .blue : .gray)
                }
                .disabled(!canSendMessage)
                .animation(.easeInOut(duration: 0.2), value: canSendMessage)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Computed Properties
    private var canSendMessage: Bool {
        !userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !taskViewModel.isLoading
    }
    
    // MARK: - Methods
    private func setupWelcomeMessage() {
        if mainChatThread.messages.isEmpty {
            mainChatThread.append(NewChatMessage(
                id: UUID().uuidString,
                role: "assistant",
                content: "Hi! I'm your AI assistant. I can help you with your tasks, answer questions, and provide insights. What would you like to know?",
                timestamp: Date()
            ))
        }
    }
    
    private func sendMessage() {
        guard canSendMessage else { return }
        
        let userMessage = NewChatMessage(
            id: UUID().uuidString,
            role: "user",
            content: userPrompt.trimmingCharacters(in: .whitespacesAndNewlines),
            timestamp: Date()
        )
        
        mainChatThread.append(userMessage)
        print(mainChatThread.messages)
        let currentPrompt = userPrompt
        userPrompt = ""
        isTextFieldFocused = false
        
        Task {
            await askQuestion(prompt: currentPrompt)
        }
    }
    
    private func askQuestion(prompt: String) async {
        Task {
            await taskViewModel.askAiTaskQuestion(userPromot: prompt, chatHistory: messages)
            
            // Add AI response to chat
            if !taskViewModel.aiChat.isEmpty {
                let aiMessage = NewChatMessage(
                    id: UUID().uuidString,
                    role: "assistant",
                    content: taskViewModel.aiChat,
                    timestamp: Date()
                )
                
                await MainActor.run {
                    mainChatThread.append(aiMessage)
                }
            }
        }
    }
    
    private func clearChat() {
        withAnimation(.easeInOut(duration: 0.3)) {
            mainChatThread.messages.removeAll()
            setupWelcomeMessage()
        }
    }
}

// MARK: - Chat Message Model
struct ChatMessage: Identifiable, Codable {
    let id: String
    let content: String
    let isUser: Bool
    let timestamp: Date
}

// MARK: - New Chat Message Model
struct NewChatMessage: Identifiable, Codable {
    let id: String
    let role: String
    let content: String
    let timestamp: Date
}

// MARK: - Chat Bubble View
struct ChatBubbleView: View {
    let message: NewChatMessage
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer(minLength: 60)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                        .cornerRadius(4, corners: [.topLeft, .topRight, .bottomLeft])
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "brain.head.profile")
                            .font(.title3)
                            .foregroundColor(.blue)
                            .frame(width: 24, height: 24)
                        
                        Text(message.content)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .foregroundColor(.primary)
                            .cornerRadius(18)
                            .cornerRadius(4, corners: [.topLeft, .topRight, .bottomRight])
                    }
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 60)
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: message.role == "user" ? .trailing : .leading).combined(with: .opacity),
            removal: .opacity
        ))
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .frame(width: 24, height: 24)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 8, height: 8)
                                .scaleEffect(animationOffset == CGFloat(index) ? 1.2 : 0.8)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                    value: animationOffset
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(18)
                    .cornerRadius(4, corners: [.topLeft, .topRight, .bottomRight])
                }
            }
            
            Spacer(minLength: 60)
        }
        .onAppear {
            animationOffset = 2
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Sheet Extension
extension View {
    func aiAnswerSheet(isPresented: Binding<Bool>, mainChatThread: MainChatThread) -> some View {
        self.sheet(isPresented: isPresented) {
            NavigationView {
                AiAnswerSheet(mainChatThread: mainChatThread)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
            }
        }
    }
}
