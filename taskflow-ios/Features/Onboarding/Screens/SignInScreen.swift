//
//  SignInScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

// ... existing code ...

import SwiftUI
import Clerk

struct SignInScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                Spacer()
                // Card-like container
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sign In")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Welcome back! Please enter your details.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("name@email.com", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            HStack {
                                if isSecure {
                                    SecureField("Password", text: $password)
                                } else {
                                    TextField("Password", text: $password)
                                }
                                Button(action: { isSecure.toggle() }) {
                                    Image(systemName: isSecure ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    Button(action: {
                        Task{await submit(email: email, password: password)}
                    }) {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                )
                .padding(.horizontal, 24)
                Spacer()
            }
        }
    }
}

extension SignInScreen {
    func submit(email:String, password:String) async {
        do{
            try await SignIn.create(strategy: .identifier(email, password: password))
        } catch {
            dump(error)
        }
    }
}

#Preview {
    SignInScreen()
}
