//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 14.10.2022.
//

import SwiftUI


struct DetailLoadingView: View {
    
    @Binding var coin: Coin?
    
    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                Text("hello")
                    .frame(height: 150)
                overviewTitle
                Divider()
                overviewGrid
                
                additionalTitle
                Divider()
                additionalGrid
                
            }.padding()
        }
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(coin: dev.coin)
        }
        
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Detail")
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
}
