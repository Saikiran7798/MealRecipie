//
//  APIRequests.swift
//  MealRecipie
//
//  Created by Saikiran Reddy Doddeni on 5/5/23.
//

import Foundation
import UIKit

class APIRequests {
    static let shared = APIRequests()
    
    func getMeals() async -> MealsData? {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoder = JSONDecoder()
            let meals = try decoder.decode(MealsData.self, from: data)
            print("meals are \(meals.meals.count)")
            return meals
        } catch {
            print("\(error.localizedDescription)")
            return nil
        }
    }
    
    func getMealImages(mealData : MealsData) async -> [String : UIImage] {
        var images = [String : UIImage]()
        do {
            images = try await withThrowingTaskGroup(of: (String, UIImage).self){ group in
                for item in mealData.meals {
                    group.addTask(priority: .background){
                        let url = URL(string: "\(item.strMealThumb)")
                        let (data, _) = try await URLSession.shared.data(from: url!)
                        return (item.idMeal, UIImage(data: data) ?? UIImage(systemName: "photo")!)
                    }
                }
                var childTaskResults = [String:UIImage]()
                for try await result in group {
                    childTaskResults[result.0] = result.1
                }
                return childTaskResults
            }
            return images
        } catch {
            print("error")
            for item in mealData.meals {
                images[item.idMeal] = UIImage(systemName: "photo")!
            }
            return images
        }
    }
    
    func getMealDetails(mealId : String) async -> DetailedMeals? {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)")
        var detailMeals : DetailedMeals = DetailedMeals(instuctions: [], ingredients: [:])
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoder = JSONDecoder()
            let mealDetails : MealDetails = try decoder.decode(MealDetails.self, from: data)
            for (key, value) in mealDetails.meals[0] {
                if let value = value {
                    if key == "strInstructions" {
                        if !value.isEmpty{
                            let subStrings = value.components(separatedBy: CharacterSet.newlines)
                            for item in subStrings {
                                if !item.isEmpty {
                                    detailMeals.instuctions.append(item)
                                }
                            }
                        }
                    }
                    for i in 1..<21 {
                        if key == "strIngredient\(i)" {
                            if !value.isEmpty {
                                detailMeals.ingredients[value] = mealDetails.meals[0]["strMeasure\(i)"] ?? ""
                            }
                        }
                    }

                }
            }
            return detailMeals
        } catch let error {
            print("\(error)")
            return nil
        }
    }
}
