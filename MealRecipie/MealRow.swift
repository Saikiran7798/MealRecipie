//
//  MealRow.swift
//  MealRecipie
//
//  Created by Saikiran Reddy Doddeni on 5/5/23.
//

import SwiftUI

struct MealRow: View {
    var mealImage : UIImage
    var mealTitle : String
    var mealID: String
    var body: some View {
        HStack(spacing: 30) {
            Image(uiImage: mealImage)
                .resizable()
                .frame(width: 100, height: 100)
            Text("\(mealTitle)")
            Spacer()
            Button(action: {
            }, label: {
                NavigationLink(destination: RecipieDetailView(mealID: mealID, mealTitle: mealTitle), label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                })
            })
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

struct MealRow_Previews: PreviewProvider {
    static var previews: some View {
        MealRow(mealImage: UIImage(systemName: "photo")!, mealTitle: "Hi", mealID: " ")
    }
}
