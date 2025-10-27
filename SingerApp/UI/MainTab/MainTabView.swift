//
//  MainTabView.swift
//  SingerApp
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "bag.fill")
                }
                .tag(1)
            
            WishlistView()
                .tabItem {
                    Label("Wishlist", systemImage: "heart.fill")
                }
                .tag(2)
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .tag(3)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}

