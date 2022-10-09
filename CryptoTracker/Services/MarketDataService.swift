//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 09.10.2022.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketData? = nil
    var marketSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    private func getData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.marketData = result.data
                self?.marketSubscription?.cancel()
            })
        
    }
}
