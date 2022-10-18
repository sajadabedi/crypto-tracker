//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 18.10.2022.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    
    init(coin: Coin) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
    }
    
    var body: some View {
        let yAxis = maxY - minY
        
        GroupBox {
            Chart {
                ForEach(data.indices, id: \.self) { index in
                    let yPosition = (data[index] - minY) / yAxis
                    LineMark(x: .value("week day", index), y: .value("second one", yPosition))
                        
                }
            }
            .foregroundColor(.green)
            .shadow(color: Color.green.opacity(0.6), radius: 5, y: 12)
        }
        .backgroundStyle(.regularMaterial)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}
