//
//  RegisterView.swift
//  SingerApp
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        VStack(spacing: 10) {
                            Image(systemName: "person.badge.plus")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.green)
                            
                            Text("Create Account")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Sign up to get started")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 30)
                        
                        // Form
                        VStack(spacing: 20) {
                            TextField("Full Name", text: $fullName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            
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
                            
                            SecureField("Confirm Password", text: $confirmPassword)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            
                            Button(action: {
                                // Handle register
                                dismiss()
                            }) {
                                Text("Register")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 30)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("Register")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}

