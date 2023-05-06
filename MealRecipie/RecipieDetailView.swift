//
//  RecipieDetailView.swift
//  MealRecipie
//
//  Created by Saikiran Reddy Doddeni on 5/5/23.
//

import SwiftUI

struct RecipieDetailView: View {
    @State var detailedMeals :DetailedMeals?
    var mealID : String
    var mealTitle : String
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                if let detailedMeals = detailedMeals {
                    HStack(){
                        Spacer()
                        Text("Instructions to prepare the Meal")
                            .bold()
                        Spacer()
                    }
                    ForEach(detailedMeals.instuctions, id: \.self){ item in
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                                .frame(alignment: .topTrailing)
                            Text("\(item)")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .padding(.trailing, 10)
                    }
                    HStack(){
                        Spacer()
                        Text("Ingredients and Measurements")
                            .bold()
                        Spacer()
                    }
                    ForEach(Array(detailedMeals.ingredients), id: \.key){ key, value in
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                            Text("\(key) : \(value)")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .padding(.trailing, 10)
                    }
                }
                else {
                    ProgressView()
                }
            }
        }
        .navigationTitle("\(mealTitle)")
        .onAppear(){
            Task(priority: .background){
                let detailMeals = await APIRequests.shared.getMealDetails(mealId: mealID)
                DispatchQueue.main.async {
                    self.detailedMeals = detailMeals
                }
            }
        }
    }
}

struct RecipieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipieDetailView(mealID: "", mealTitle: "")
    }
}
