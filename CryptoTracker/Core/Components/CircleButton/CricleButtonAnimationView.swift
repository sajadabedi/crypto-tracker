//
//  CricleButtonAnimationView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 30.09.2022.
//

import SwiftUI

struct CricleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .foregroundColor(.secondary.opacity(0.2))
            .opacity(animate ? 0.0 : 5.0)
            .animation(animate ? .easeOut(duration: 0.4) : .none, value: animate)
    }
}

struct CricleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CricleButtonAnimationView(animate: .constant(false))
    }
}
