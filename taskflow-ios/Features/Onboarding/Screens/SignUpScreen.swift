//
//  SignUpScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

// ... existing code ...

import SwiftUI

struct SignUpScreen: View {
    @State private var name: String = ""
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
                        Text("Sign Up")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Create your account to get started.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Your name", text: $name)
                                .autocapitalization(.words)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
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
                        // Handle sign up
                    }) {
                        Text("Sign Up")
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

#Preview {
    SignUpScreen()
}
