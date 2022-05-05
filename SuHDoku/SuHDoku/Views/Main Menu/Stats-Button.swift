//
//  Stats-Button.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct StatsButton: View {
    
    // Button to present the statistics page
    var body: some View {
        NavigationLink(destination: StatsScreen()) {
            HStack {
                Text("Puzzle Stats")
                    .font(Font.custom("Petahja-Regular", size: 28))
                    .frame(maxWidth: 150, maxHeight: .infinity)
                    .foregroundColor(Color("regularTextColor"))
                
                Spacer()
                    .frame(maxWidth: 150)
            
                Image(systemName: "books.vertical")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color("regularTextColor"))
            }
            .padding(15)
            
        }
        .cornerRadius(15)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color("mainColor3")))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color("regularTextColor")))
    }
}

struct StatsButton_Previews: PreviewProvider {
    static var previews: some View {
        StatsButton()
    }
}
