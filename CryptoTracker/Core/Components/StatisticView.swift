//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 09.10.2022.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption.monospaced().smallCaps())
                .foregroundColor(.secondary)
            Text(stat.value)
                .font(.headline)
            HStack(spacing:6){
                Text("▲")
                    .font(.caption)
                    .rotationEffect(Angle(degrees: (stat.precentageChange ?? 0) >= 0 ? 0 : 180))
                Text(stat.precentageChange?.asPrecentString() ?? "")
                    .font(.caption.bold().monospaced())
            }
            .foregroundColor((stat.precentageChange ?? 0) >= 0 ? Color.green : Color.theme.redColor)
            .opacity(stat.precentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.stat3)
    }
}
