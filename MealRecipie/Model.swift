//
//  Model.swift
//  MealRecipie
//
//  Created by Saikiran Reddy Doddeni on 5/5/23.
//

import Foundation

struct MealsData : Codable {
    var meals : [MealsResults]
}

struct MealsResults : Codable {
    var strMeal : String
    var strMealThumb : String
    var idMeal : String
}

struct MealDetails : Codable {
    var meals : [[String : String?]]
}

struct DetailedMeals {
    var instuctions : [String]
    var ingredients : [String : String]
}
