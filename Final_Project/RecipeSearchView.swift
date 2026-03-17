import SwiftUI

struct RecipeSearchView: View {
    @State private var searchText = ""
    @State private var recipes: [Recipe] = []
    @State private var isLoading = false
    @State private var error: String?
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearch: {
                    loadRecipes()
                })
                
                List(recipes) { recipe in
                    NavigationLink(destination: MealDetailView(recipe: recipe)) {
                        RecipeRow(recipe: recipe)
                    }
                }
            }
            .navigationTitle("Recipe Search")
        }
    }
    
    private func loadRecipes() {
        guard !searchText.isEmpty else {
            recipes = []
            return
        }
        
        isLoading = true
        error = nil
        
        guard let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(encodedQuery)") else {
            error = "Invalid search query"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
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
}

struct SearchBar: View {
    @Binding var text: String
    let onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search recipe name...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    onSearch()
                }
            
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(recipe.strMeal)
                    .font(.headline)
                if let category = recipe.strCategory {
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
