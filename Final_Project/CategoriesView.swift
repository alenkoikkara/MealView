//
//  CategoriesView.swift
//  Final_Project
//
//  Created by CDMStudent on 6/9/25.
//
import SwiftUI

struct CategoriesView: View {
    @State private var categories: [Category] = []
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        NavigationView {
            List(categories, id: \.strCategory) { category in
                if let categoryName = category.strCategory {
                    NavigationLink(destination: CategoryRecipesView(category: categoryName)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(categoryName)
                                    .font(.headline)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Categories")
        }
        .onAppear {
            loadRecipes()
        }
    }
    
    private func loadRecipes() {
        isLoading = true
        error = nil
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?c=list") else {
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
                    let categoryResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    self.categories = categoryResponse.meals ?? []
                } catch {
                    self.error = "Error parsing response: \(error.localizedDescription)"
                }
                
                self.isLoading = false
            }
        }.resume()
    }
}
