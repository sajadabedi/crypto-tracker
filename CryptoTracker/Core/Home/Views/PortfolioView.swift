//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 10.10.2022.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantity: String = ""
    @State private var showSave: Bool = false
    
    var body: some View {
        
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.search)
                        .padding(.bottom)
                    coinLogoList
                        .padding(.bottom)
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    DismissButton().padding(.leading, 8)
                })
                ToolbarItem(placement: .navigationBarTrailing) { trilingNavBarButton }
            }
            .onChange(of: vm.search) { newValue in
                if newValue == "" { removeSelectedCoin() }
            }
        }
    }
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.search.isEmpty ? vm.portfolioCoins : vm.altCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 50)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(selectedCoin?.id == coin.id ? .accentColor.opacity(0.1) : .clear)
                        )
                }
            }
            .padding(.vertical, 2)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantity = "\(amount)"
        } else {
            quantity = ""
        }
    }
    
    private func getCurrentValue () -> Double {
        if let quantityNumber = Double(quantity) {
            return quantityNumber * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price: \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrecnyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amonut holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrecnyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var trilingNavBarButton: some View {
        Button {
            saveButtonPressed()
        } label: {
            Text("Save")
            
                .fontWeight(.semibold)
        }.opacity(
            (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity)) ? 1.0 : 0.0
        )
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
              let amount = Double(quantity) else { return }
        
        // Save to portfolio (Core Data)
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // MARK: Save portfolio
        withAnimation(.easeIn(duration: 0.1)) {
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.search = ""
    }
}
