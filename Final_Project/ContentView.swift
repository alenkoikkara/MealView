//
//  ContentView.swift
//  Final_Project
//
//  Created by CDMStudent on 6/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        TabView {
            RecipeSearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "list.dash")
                }
            RandomView()
                .tabItem {
                    Label("Random", systemImage: "dice")
                }
            NearbyView()
                .tabItem {
                    Label("Nearby", systemImage: "location")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
        .environmentObject(favoritesManager)
    }
}

#Preview {
    ContentView()
}
