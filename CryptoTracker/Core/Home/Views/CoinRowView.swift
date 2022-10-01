//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 30.09.2022.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            LeftColumn
            Spacer()
            if showHoldingsColumn {
                CenterColumn
            }
            RightColumn
            
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
        }.padding()
    }
}


extension CoinRowView {
    private var LeftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption.monospaced())
                .foregroundColor(.secondary)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline.monospaced())
                .padding(.leading, 6)
                .foregroundColor(.accentColor)
        }
    }
    
    private var CenterColumn: some View {
        VStack {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrecnyWith6Decimals())
                    .fontWeight(.semibold)
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundColor(.accentColor)
            
        }
    }
    
    private var RightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrecnyWith2Decimals())
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)
            Text(coin.priceChangePercentage24H?.asPrecentString() ?? "")
                .foregroundColor((coin.priceChange24H ?? 0) >= 0 ? .green : Color.theme.redColor)
                .font(.subheadline.monospaced())
        }
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
    }
}
