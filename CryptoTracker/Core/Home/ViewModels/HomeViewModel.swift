//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 01.10.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var altCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] result in
                self?.altCoins = result
            }
            .store(in: &cancellables)
    }
}
