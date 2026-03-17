import Foundation

class FavoritesManager: ObservableObject {
    @Published var favorites: [Recipe] = []
    
    func addToFavorites(_ recipe: Recipe) {
        if !favorites.contains(where: { $0.idMeal == recipe.idMeal }) {
            favorites.append(recipe)
        }
    }
    
    func removeFromFavorites(_ recipe: Recipe) {
        favorites.removeAll { $0.idMeal == recipe.idMeal }
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        favorites.contains { $0.idMeal == recipe.idMeal }
    }
} 