//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 16.10.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var coin: Coin
    private let coinDetailService: CoinDetailDataService
    private var cancellable = Set<AnyCancellable>()
    
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellable)
        
        coinDetailService.$coinDetail
            .sink { [weak self] returnedCoin in
                self?.coinDescription = returnedCoin?.readableDescription
                self?.websiteURL = returnedCoin?.links?.homepage?.first
                self?.redditURL = returnedCoin?.links?.subredditURL
            }.store(in: &cancellable)
    }
    
    private func mapDataToStatistics(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        
        let overviewArray = createOverviewArray(coin: coin)
        let additionalArray = createAdditionalArray(coin: coin, coinDetail: coinDetail)
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coin: Coin) -> [Statistic] {
        // Overview
        let price = coin.currentPrice.asCurrecnyWith2Decimals()
        let pricePercentageChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, precentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, precentageChange: marketCapChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumnStat = Statistic(title: "Volume", value: volume)
        
        let overviewArray: [Statistic] = [priceStat,marketCapStat, rankStat, volumnStat]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coin: Coin, coinDetail: CoinDetail?) -> [Statistic] {
        //Additional
        let high = coin.high24H?.asCurrecnyWith2Decimals() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrecnyWith2Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrecnyWith2Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, precentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapCHange2Stat = Statistic(title: "24h Market Change", value: marketCapChange, precentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing", value: hashing)
        
        let additionalArray: [Statistic] = [ highStat, lowStat, priceChangeStat,marketCapCHange2Stat, blockStat, hashingStat]
        
        return additionalArray
    }
}
