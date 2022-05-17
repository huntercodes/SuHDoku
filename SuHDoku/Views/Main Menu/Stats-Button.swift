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
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color("mainColor2"))
                        .frame(height: 55)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("regularTextColor"))
                        .frame(height: 55)
                    )
                
                Spacer()
                    .frame(maxWidth: 120)
                    
                Image(systemName: "books.vertical")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("regularTextColor"))
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color("mainColor2"))
                        .frame(width: 55, height: 55)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("regularTextColor"))
                        .frame(width: 55, height: 55)
                    )
        
            }
            .frame(minWidth: 360)
        }
        .background(Ellipse()
            .fill(Color("mainColor3"))
            .frame(maxHeight: 120)
            .aspectRatio(2, contentMode: .fill)
            .frame(maxHeight: 120)
        )
        .overlay(Ellipse()
            .stroke(Color("regularTextColor"))
            .frame(maxHeight: 120)
            .aspectRatio(2, contentMode: .fill)
            .frame(maxHeight: 120)
        )
    }
}

struct StatsButton_Previews: PreviewProvider {
    static var previews: some View {
        StatsButton()
            
    }
}
