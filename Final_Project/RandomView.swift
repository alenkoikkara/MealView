//
//  RandomView.swift
//  Final_Project
//
//  Created by CDMStudent on 6/9/25.
//
import SwiftUI

struct RandomView: View {
    @State private var recipe: Recipe?
    @State private var isLoading = false
    @State private var error: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if let recipe = recipe {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recipe.strMeal)
                                    .font(.title)
                                    .bold()
                                
                                if let category = recipe.strCategory {
                                    Text("Category: \(category)")
                                        .font(.subheadline)
                                }
                                
                                if let area = recipe.strArea {
                                    Text("Cuisine: \(area)")
                                        .font(.subheadline)
                                }
                                
                                if let instructions = recipe.strInstructions {
                                    Text("Instructions")
                                        .font(.headline)
                                        .padding(.top)
                                    Text(instructions)
                                        .font(.body)
                                }
                                
                                if !recipe.ingredients.isEmpty {
                                    Text("Ingredients")
                                        .font(.headline)
                                        .padding(.top)
                                    
                                    ForEach(recipe.ingredients, id: \.ingredient) { ingredient, measure in
                                        Text("• \(measure) \(ingredient)")
                                            .font(.body)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                Button(action: {
                    loadRandomRecipe()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Get Another Recipe")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Random Recipe")
        }
        .onAppear {
            loadRandomRecipe()
        }
    }
    
    private func loadRandomRecipe() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php") else {
            error = "Invalid URL"
            isLoading = false
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
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
                    self.recipe = recipeResponse.meals?.first
                } catch {
                    self.error = "Error parsing response: \(error.localizedDescription)"
                }
                
                self.isLoading = false
            }
        }.resume()
    }
}
