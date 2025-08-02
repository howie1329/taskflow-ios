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
    @State private var aiDataService = AiDataService.shared
    
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
                    
                    // Show AI loading indicator
                    if aiDataService.isAiLoading {
                        EnhancedTypingIndicator()
                            .id("typing")
                    }
                    
                    // Show error message if there's an AI error
                    if let error = aiDataService.currentAiError {
                        ErrorMessageView(error: error) {
                            Task {
                                await aiDataService.setAiError(nil)
                            }
                        }
                        .id("error")
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
            .onChange(of: aiDataService.isAiLoading) { _, isLoading in
                if isLoading {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo("typing", anchor: .bottom)
                    }
                }
            }
            .onChange(of: aiDataService.currentAiError) { _, error in
                if error != nil {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo("error", anchor: .bottom)
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
                
                Button(action: {
                    if aiDataService.isAiLoading {
                        Task {
                            await cancelAiRequest()
                        }
                    } else {
                        sendMessage()
                    }
                }) {
                    Image(systemName: aiDataService.isAiLoading ? "stop.fill" : "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(canSendMessage || aiDataService.isAiLoading ? .blue : .gray)
                }
                .disabled(!canSendMessage && !aiDataService.isAiLoading)
                .animation(.easeInOut(duration: 0.2), value: canSendMessage)
                .animation(.easeInOut(duration: 0.2), value: aiDataService.isAiLoading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Computed Properties
    private var canSendMessage: Bool {
        !userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !aiDataService.isAiLoading
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
    
    private func cancelAiRequest() async {
        await aiDataService.setAiLoading(false)
        await aiDataService.setAiError("Request cancelled")
    }
    
    private func clearChat() {
        withAnimation(.easeInOut(duration: 0.3)) {
            mainChatThread.messages.removeAll()
            setupWelcomeMessage()
        }
    }
}

// MARK: - Enhanced Typing Indicator
struct EnhancedTypingIndicator: View {
    @State private var animationOffset: CGFloat = 0
    @State private var pulseAnimation: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .frame(width: 24, height: 24)
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 4) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(Color.blue.opacity(0.6))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(animationOffset == CGFloat(index) ? 1.3 : 0.8)
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
                        
                        Text("AI is thinking...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .opacity(pulseAnimation ? 0.5 : 1.0)
                    }
                }
            }
            
            Spacer(minLength: 60)
        }
        .onAppear {
            animationOffset = 2
            pulseAnimation = true
        }
    }
}

// MARK: - Error Message View
struct ErrorMessageView: View {
    let error: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(error)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(18)
                            .cornerRadius(4, corners: [.topLeft, .topRight, .bottomRight])
                        
                        Button("Dismiss") {
                            onDismiss()
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                }
            }
            
            Spacer(minLength: 60)
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

// MARK: - Original Typing Indicator (kept for compatibility)
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
