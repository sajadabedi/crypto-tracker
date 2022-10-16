//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 30.09.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false // Animate right
    @State private var showPortfolioView: Bool = false // New sheet
    
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    
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
        .sheet(isPresented: $showPortfolioView, content: { PortfolioView().environmentObject(vm) })
        .background(
            // TODO: repalcing with value:label
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin),
                           isActive: $showDetailView,
                           label: {
                               EmptyView()
                           })
        )
        
        
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
                .onTapGesture {
                    if showPortfolio { showPortfolioView.toggle() }
                }
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
        List{
            ForEach(vm.altCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(EdgeInsets(top: 20, leading: 6, bottom: 20, trailing: 20))
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            vm.reloadData()
        }
        
    }
    
    // MARK: Coin List
    private var PortfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 18))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
    }
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    // MARK: Column Title
    private var ColumnTitle: some View {
        HStack {
            HStack{
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 :0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }.onTapGesture {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack{
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 :0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }.onTapGesture {
                    withAnimation(.spring()) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdings : .holdings
                    }
                }
            }
            HStack{
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 :0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
            .onTapGesture {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.footnote.monospaced().smallCaps().weight(.medium))
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
}




