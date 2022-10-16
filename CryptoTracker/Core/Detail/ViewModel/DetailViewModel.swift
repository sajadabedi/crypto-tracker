//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 16.10.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .sink { coinDetail in
                print(coinDetail)
            }
            .store(in: &cancellable)
    }
}
