//
//  MealDetailView.swift
//  Final_Project
//
//  Created by CDMStudent on 6/9/25.
//

import SwiftUI

struct MealDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
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
                    HStack {
                        Text(recipe.strMeal)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            if favoritesManager.isFavorite(recipe) {
                                favoritesManager.removeFromFavorites(recipe)
                            } else {
                                favoritesManager.addToFavorites(recipe)
                            }
                        }) {
                            Image(systemName: favoritesManager.isFavorite(recipe) ? "heart.fill" : "heart")
                                .foregroundColor(favoritesManager.isFavorite(recipe) ? .red : .gray)
                                .font(.title2)
                        }
                    }
                    
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
        .navigationBarTitleDisplayMode(.inline)
    }
}
