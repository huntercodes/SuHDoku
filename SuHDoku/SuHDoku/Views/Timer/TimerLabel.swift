//
//  TimerLabel.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct TimerLabel: View {
    @EnvironmentObject var gt: GameTimer
 
    // A label used to show puzzle duration
    var body: some View {
        HStack {
            Text(String(gt.timeElapsed))
                .font(Font.custom("Petahja-Regular", size: 44))
            
            Image(systemName: "hourglass.circle")
                .resizable()
                .frame(width: 25, height: 25)
        }
    }
}

struct TimerLabel_Previews: PreviewProvider {
    static var previews: some View {
        TimerLabel()
            .environmentObject(GameTimer())
    }
}
