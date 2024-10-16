//
//  CurrencyData.swift
//  Pricy
//
//  Created by can on 16.10.2024.
//

import Foundation

struct CurrencyData: Decodable {
    let rates: [String: Double]
}
