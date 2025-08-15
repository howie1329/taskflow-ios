//
//  ChatView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 8/12/25.
//

import SwiftUI

struct ChatView: View {
    @State var viewModel = ChatViewModel()
    @State var userMessage:String = ""
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Spacer()
                    Text("Flow Chat")
                        .font(.headline)
                    Spacer()
                    Button {
                        viewModel.clearChat()
                    } label: {
                        Image(systemName: "clear.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                Divider()
                ScrollView{
                    LazyVStack(alignment:.leading, spacing: 12){
                        ForEach(viewModel.messages, id: \.id){message in
                            Group{
                                switch message.type {
                                case .text:
                                    ChatBubble(message: message)
                                case .toolCall:
                                    ChatBubble(message: message)
                                        .transition(.move(edge: .bottom).combined(with: .opacity))
                                case .start:
                                    StartBubble(message: message)
                                        .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                    }
                }
                Divider()
                HStack(spacing: 8){
                    TextField("Message", text: $userMessage)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.black.opacity(0.12), lineWidth: 1)
                        )
                    if !userMessage.isEmpty{
                        Button {
                            let trimmed = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            viewModel.sendMessage(trimmed)
                            userMessage = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .disabled(userMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(userMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.8)),
                            removal: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.8))
                        ))
                    }
                   
                }
                .animation(.smooth(duration: 0.3), value: userMessage.isEmpty)
            }
            .safeAreaPadding()
        }.onAppear {
            //viewModel.messages = ChatPrompt.dummyData
        }
        .onDisappear {
            viewModel.messages.removeAll()
        }
    }
}

struct ChatBubble: View {
    let message: ChatPrompt
    var body: some View {
        let isUser = message.role == .user
        VStack(alignment: .leading, spacing: 4){
            Text(isUser ? "You" : "Assistant")
                .font(.caption2)
                .foregroundStyle(Color.black.opacity(0.5))
                .padding(isUser ? .trailing : .leading, 8)
                .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
            HStack(alignment: .bottom){
                if isUser { Spacer(minLength: 40) }
                Text(message.content)
                    .font(.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isUser ? Color.black : Color.white)
                    .foregroundStyle(isUser ? Color.white : Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.black.opacity(isUser ? 0 : 0.12), lineWidth: isUser ? 0 : 1)
                    )
                    .shadow(color: Color.black.opacity(isUser ? 0.15 : 0.06), radius: isUser ? 10 : 6, x: 0, y: isUser ? 6 : 2)
                    .frame(maxWidth: 300, alignment: isUser ? .trailing : .leading)
                if !isUser { Spacer(minLength: 40) }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

struct StartBubble: View {
    @State private var animationOffset: CGFloat = 0
    let message: ChatPrompt
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.black)
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
        .onAppear{
            animationOffset = 2
        }
    }
}

struct ToolCallBubble: View {
    let message: ChatPrompt
    var body: some View {
        HStack{
            Text(message.content.capitalized)
        }
    }
}

#Preview {
    ChatView()
}
