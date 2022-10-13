//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 01.10.2022.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [Coin] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.allCoins = result
                self?.coinSubscription?.cancel()
            })

    }
}
