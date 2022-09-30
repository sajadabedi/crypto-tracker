//
//  CricleButtonView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 30.09.2022.
//

import SwiftUI

struct CricleButtonView: View {
    
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.headline)
            .frame(width: 50, height: 50)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(.secondary.opacity(0.25))
            }
            .padding()
    }
}

struct CricleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CricleButtonView(icon: "sparkle")
    }
}
