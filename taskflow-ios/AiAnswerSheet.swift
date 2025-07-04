//
//  AiAnswerSheet.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/3/25.
//

import SwiftUI

struct AiAnswerSheet: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var userPrompt:String = ""
    @State private var isPresented: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack{
            // Header
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                            
                Text("Ask AI")
                    .font(.title2)
                    .fontWeight(.semibold)
                            
                Text("Ask any question and get an instant answer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            // Input Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Question")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            TextField("What would you like to know?", text: $userPrompt, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                                .focused($isTextFieldFocused)
                            
                            Button {
                                askQuestion()
                            } label: {
                                HStack {
                                    if taskViewModel.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "paperplane.fill")
                                    }
                                    Text(taskViewModel.isLoading ? "Thinking..." : "Ask AI")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background( Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            //.disabled(!canAskQuestion)
                        }
                        .padding(.horizontal)
                        
                        // Response Section
                        if !taskViewModel.aiChat.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.yellow)
                                    Text("AI Response")
                                        .font(.headline)
                                    Spacer()
                                    Button("Clear") {
                                        clearResponse()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                }
                                
                                ScrollView {
                                    Text(taskViewModel.aiChat)
                                        .font(.body)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                .frame(maxHeight: 300)
                            }
                            .padding(.horizontal)
                        }
        }
    }
    private func askQuestion(){
        guard !userPrompt.isEmpty else { return }
        isTextFieldFocused = false
        Task {
            await taskViewModel.loadAiQuestionResponse(userPrompt: userPrompt)
        }
    }
    
    private func clearResponse() {
        taskViewModel.aiChat = ""
        userPrompt = ""
        isTextFieldFocused = true
    }
    
    
}
extension View {
    func aiAnswerSheet(isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            NavigationView {
                AiAnswerSheet()
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

#Preview {
    AiAnswerSheet()
}
