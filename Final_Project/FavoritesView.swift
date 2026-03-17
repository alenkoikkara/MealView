import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.favorites) { recipe in
                    NavigationLink(destination: MealDetailView(recipe: recipe)) {
                        RecipeRow(recipe: recipe)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        favoritesManager.removeFromFavorites(favoritesManager.favorites[index])
                    }
                }
            }
        }
        .navigationTitle("Favorites")
    }
} 
