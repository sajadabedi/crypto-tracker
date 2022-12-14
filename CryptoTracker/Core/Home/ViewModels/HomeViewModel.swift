//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 01.10.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistic: [Statistic] = []
    
    @Published var altCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var search: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // Update allCoins
        $search
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (coins) in
                self?.altCoins = coins
            }
            .store(in: &cancellables)
        
        // Update Portfolio Coin
        $altCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoin) in
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinIfNeeded(coins: returnedCoin)
            }
            .store(in: &cancellables)
        
        // Market Data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.statistic = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var updatedCoin = filterCoins(text: text, coins: coins)
        // sort
        sortCoins(sort: sort, coin: &updatedCoin)
        return updatedCoin
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
    
    private func sortCoins(sort: SortOption, coin: inout [Coin]) {
        switch sort {
        case .rank,.holdings:
            coin.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coin.sort(by: {$0.rank > $1.rank })
        case .price:
            coin.sort(by: {$0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coin.sort(by: {$0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinIfNeeded(coins: [Coin]) -> [Coin] {
        // will only sort by holdings
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [PortfolioEntity]) -> [Coin] {
        allCoins.compactMap { (coin) -> Coin? in
            guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else  {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        guard let data = marketDataModel else { return stats }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, precentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let precentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + precentChange)
            return previousValue
        }.reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title: "Portfolio", value: portfolioValue.asCurrecnyWith2Decimals(), precentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}
