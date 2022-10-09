//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 01.10.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistic: [Statistic] = [
        Statistic(title: "Title", value: "Value", precentageChange: 1),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value", precentageChange: -7),
    ]
    
    @Published var altCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var search: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // Update allCoins
        $search
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (coins) in
                self?.altCoins = coins
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercaseText = text.lowercased()
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercaseText) || //name
            coin.symbol.lowercased().contains(lowercaseText) || //symbol
            coin.id.lowercased().contains(lowercaseText) // id
        }
    }
}
