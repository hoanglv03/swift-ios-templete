//
//  HomeView.swift
//  SingerApp
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Welcome to Home Screen")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

