//
//  CartView.swift
//  SingerApp
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.purple)
                    
                    Text("Cart")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Welcome to Cart Screen")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Cart")
        }
    }
}

#Preview {
    CartView()
}

