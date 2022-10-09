//
//  Statistic.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 09.10.2022.
//

import Foundation

struct Statistic: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let precentageChange: Double?
    
    init(title: String, value: String, precentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.precentageChange = precentageChange
    }
    
}
