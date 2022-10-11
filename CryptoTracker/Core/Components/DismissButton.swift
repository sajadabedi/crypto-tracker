//
//  DismissButton.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 10.10.2022.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.caption2).bold()
                .background(
                    Ellipse()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.secondary.opacity(0.2))
                )
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
