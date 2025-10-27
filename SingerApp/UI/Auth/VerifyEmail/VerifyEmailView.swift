//
//  VerifyEmailView.swift
//  SingerApp
//

import SwiftUI

struct VerifyEmailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var verificationCode = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "envelope.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.purple)
                        
                        Text("Verify Email")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Enter the verification code sent to your email")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                    
                    // Form
                    VStack(spacing: 20) {
                        TextField("Verification Code", text: $verificationCode)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        
                        Button(action: {
                            // Handle verify
                            dismiss()
                        }) {
                            Text("Verify")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Resend code
                        }) {
                            Text("Resend Code")
                                .font(.subheadline)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
            .navigationTitle("Verify Email")
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
    VerifyEmailView()
}

