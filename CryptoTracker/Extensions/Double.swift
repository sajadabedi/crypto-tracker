//
//  Double.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 30.09.2022.
//

import Foundation

extension Double {
    
    /// Converts a Double into a currency with 2 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Converts a Double into a currency as String with 2 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// ``
    func asCurrecnyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    /// Converts a Double into a currency with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Converts a Double into a currency as String with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert 0.123456 to "$0.123456"
    /// ``
    func asCurrecnyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Converts a Double into a string representation
    /// ```
    /// Convert 1.23456 to "1.23"
    /// ``
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    // Converts a Double into a string representation with precent symbol
    /// ```
    /// Convert 1.23456 to "1.23%"
    /// ``
    func asPrecentString() -> String {
        return asNumberString() + "%"
    }
}
