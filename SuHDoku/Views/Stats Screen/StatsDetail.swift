//
//  StatsDetail.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct StatsDetail: View {
    var label: String = "Test Label"
    var statValue: String = "Test Value"
    
    // A view used by the statistics screen to list a statistic label and value
    var body: some View {
        HStack {
            Text(label)
                .font(Font.custom("Petahja-Regular", size: 20))
            
            Spacer()
            
            Text(statValue)
                .font(Font.custom("Petahja-Regular", size: 20))
        }
    }
}

struct StatsDetail_Previews: PreviewProvider {
    static var previews: some View {
        StatsDetail(label: "Test Value", statValue: "0")
    }
}
