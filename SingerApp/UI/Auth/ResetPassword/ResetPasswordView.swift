//
//  ResetPasswordView.swift
//  SingerApp
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "lock.rotation")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.orange)
                        
                        Text("Reset Password")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Enter your email to reset password")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
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
                        
                        Button(action: {
                            // Handle reset password
                            dismiss()
                        }) {
                            Text("Send Reset Link")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
            .navigationTitle("Reset Password")
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
    ResetPasswordView()
}

