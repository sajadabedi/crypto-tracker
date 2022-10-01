//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 01.10.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
