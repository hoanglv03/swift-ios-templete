//
//  LoginView.swift
//  SingerApp
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showResetPassword = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        
                        Text("Welcome Back")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Login to your account")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                    
                    // Form
                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        
                        Button(action: {
                            showResetPassword = true
                        }) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Button(action: {
                            // Handle login
                            dismiss()
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                        
                        HStack {
                            Text("Don't have an account?")
                            Button(action: {
                                showRegister = true
                            }) {
                                Text("Register")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showRegister) {
                RegisterView()
            }
            .sheet(isPresented: $showResetPassword) {
                ResetPasswordView()
            }
        }
    }
}

#Preview {
    LoginView()
}

