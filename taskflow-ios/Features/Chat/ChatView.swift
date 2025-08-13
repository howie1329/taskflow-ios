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
                Divider()
                ScrollView{
                    ForEach(viewModel.messages, id: \.id){message in
                        Text(message.content)
                    }
                }
                Divider()
                HStack{
                    TextField("Message", text: $userMessage)
                    Button {
                        viewModel.sendMessage(userMessage)
                        userMessage = ""
                    } label: {
                        Text("+")
                    }

                }
            }
            .safeAreaPadding()
            .navigationTitle("AI Chat ")
            .toolbar{
                Button {
                    viewModel.clearChat()
                } label: {
                    Text("Clear Chat")
                }

            }
        }
    }
}

#Preview {
    ChatView()
}
