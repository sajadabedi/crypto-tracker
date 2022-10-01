//
//  SearchBarView.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 01.10.2022.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? .secondary.opacity(0.5) : .secondary.opacity(0.7)
                )
            TextField(text: $searchText) {
                Text("Search by name or symbol...")
            }
            .foregroundColor(.accentColor)
            .autocorrectionDisabled()
            .submitLabel(.search)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding(10)
                    .offset(x: 10)
                    .foregroundColor(.secondary)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        searchText = ""
                        UIApplication.shared.endEditing()
                    }
                , alignment: .trailing
            )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .foregroundColor(.secondary.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
