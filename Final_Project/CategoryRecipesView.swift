import SwiftUI

struct CategoryRecipesView: View {
    let category: String
    @State private var recipes: [Recipe] = []
    @State private var isLoading = false
    @State private var error: String?
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        List(recipes) { recipe in
            Button(action: {
                selectedRecipe = recipe
                loadFullRecipeDetails(for: recipe)
            }) {
                RecipeRow(recipe: recipe)
            }
        }
        .navigationTitle(category)
        .onAppear {
            loadRecipes()
        }
        .sheet(item: $selectedRecipe) { recipe in
            NavigationView {
                MealDetailView(recipe: recipe)
            }
        }
    }
    
    private func loadRecipes() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Network error: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }
                
                guard let data = data else {
                    self.error = "No data received"
                    self.isLoading = false
                    return
                }
                
                do {
                    let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                    self.recipes = recipeResponse.meals ?? []
                } catch {
                    self.error = "Error parsing response: \(error.localizedDescription)"
                }
                
                self.isLoading = false
            }
        }.resume()
    }
    
    private func loadFullRecipeDetails(for recipe: Recipe) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(recipe.idMeal)") else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.error = "No data received"
                    return
                }
                
                do {
                    let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                    if let fullRecipe = recipeResponse.meals?.first {
                        self.selectedRecipe = fullRecipe
                    }
                } catch {
                    self.error = "Error parsing response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
