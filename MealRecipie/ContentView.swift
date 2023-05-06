//
//  ContentView.swift
//  MealRecipie
//
//  Created by Saikiran Reddy Doddeni on 5/5/23.
//

import SwiftUI

struct ContentView: View {
    @State var meals : MealsData?
    @State var mealImages = [String:UIImage]()
    @State var isScrollView = false
    var body: some View {
        NavigationView {
            VStack {
                if let meals = meals {
                    ScrollView{
                        VStack{
                            ForEach(meals.meals.sorted(by: {$0.strMeal < $1.strMeal}), id: \.idMeal){ item in
                                MealRow(mealImage: mealImages[item.idMeal]!, mealTitle: item.strMeal, mealID: item.idMeal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Desserts")
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.gray)
            )
            .padding()
            .onAppear(){
                Task(priority: .background){
                    let mealData = await APIRequests.shared.getMeals()
                    let MealImages = await APIRequests.shared.getMealImages(mealData: mealData!)
                    DispatchQueue.main.async {
                        self.meals = mealData
                        self.mealImages = MealImages
                        self.isScrollView = true
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
