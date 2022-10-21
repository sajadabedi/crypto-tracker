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
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                ChartView(coin: vm.coin)
                    .frame(height: 150)
                overviewTitle
                Divider()
                descriptionSection
                overviewGrid
                
                additionalTitle
                Divider()
                additionalGrid
                websiteSection
                
                
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
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption).fontWeight(.medium).textCase(.uppercase)
                            .padding(.vertical, 2)
                    }.accentColor(.secondary)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSection: some View {
        HStack(spacing: 24) {
            if let websiteString = vm.websiteURL, let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            if let redditString = vm.redditURL, let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
