//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 30.09.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        // MARK: Content Layer
        VStack {
            homeHeader
                .padding()
            HomeStatsView(showPortfolio: $showPortfolio)
            SearchBarView(searchText: $vm.search)
            ColumnTitle
            
            if !showPortfolio {
                AllCoinsList
                    .transition(.move(edge: .leading))
            } else {
                PortfolioCoinList
                    .transition(.move(edge: .trailing))
            }
            Spacer(minLength: 0)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
                .environmentObject(dev.homeVM)
        }
    }
}

extension HomeView {
    
    // MARK: Header
    private var homeHeader: some View {
        HStack {
            CricleButtonView(icon: showPortfolio ? "plus" : "sparkle")
                .background(
                    CricleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portoflio" : "Live Prices")
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            CricleButtonView(icon: showPortfolio ? "chevron.backward" : "chevron.forward")
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    // MARK: Coin List
    private var AllCoinsList: some View {
        List {
            ForEach(vm.altCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 18))
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: Coin List
    private var PortfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 18))
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: Column Title
    private var ColumnTitle: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        }
        .font(.footnote.monospaced().smallCaps().weight(.medium))
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
}




