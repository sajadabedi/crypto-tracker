//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 30.09.2022.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        VStack {
            homeHeader
            Spacer(minLength: 0)
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}

extension HomeView {
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
                    withAnimation {
                        showPortfolio.toggle()
                    }
                }
        }
    }
}
