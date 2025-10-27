//
//  AccountView.swift
//  SingerApp
//

import SwiftUI

struct AccountView: View {
    @State private var showLogin = false
    @State private var showRegister = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                    
                    Text("Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            showLogin = true
                        }) {
                            HStack {
                                Text("Login")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            showRegister = true
                        }) {
                            HStack {
                                Text("Register")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Account")
            .sheet(isPresented: $showLogin) {
                LoginView()
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}

#Preview {
    AccountView()
}

