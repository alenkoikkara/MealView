//
//  Category.swift
//  Final_Project
//
//  Created by CDMStudent on 6/9/25.
//

import Foundation

struct Category: Codable {
    let strCategory: String?
        
    var ingredients: [(ingredient: String, measure: String)] {
        var result: [(String, String)] = []
        let mirror = Mirror(reflecting: self)
        
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            
            if let ingredient = mirror.children.first(where: { $0.label == ingredientKey })?.value as? String,
               let measure = mirror.children.first(where: { $0.label == measureKey })?.value as? String,
               !ingredient.isEmpty {
                result.append((ingredient, measure))
            }
        }
        
        return result
    }
}

struct CategoryResponse: Codable {
    let meals: [Category]?
}
