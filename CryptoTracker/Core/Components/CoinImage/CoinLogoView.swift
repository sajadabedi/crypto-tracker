//
//  CoinLogoView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 10.10.2022.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: Coin
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 32, height: 32)
            Text(coin.symbol.uppercased())
                .font(.callout.monospaced().bold())
                .lineLimit(1)
                .minimumScaleFactor(0.5)
//            Text(coin.name)
//                .font(.caption.monospaced())
//                .foregroundColor(.secondary)
//                .lineLimit(2)
//                .minimumScaleFactor(0.5)
//                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
    }
}
