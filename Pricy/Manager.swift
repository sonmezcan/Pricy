//
//  Manager.swift
//  Pricy
//
//  Created by can on 16.10.2024.
//

import Foundation

protocol ManagerDelegate {
    func didUpdatePrice(exchangeRate: Double)
    func didFailWithError(error: Error)
}

struct Manager {
    
    var delegate: ManagerDelegate?
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","TRY"]
    
    func fetchExchangeRate(from: String, to: String) {
        
        //let apiKey = "your api key"
        let urlString = "https://api.exchangerate-api.com/v4/latest/\(from)"
        
        if let url = URL(string: urlString) {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error fetching exchange rate: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let rates = json["rates"] as? [String: Double],
                       let exchangeRate = rates[to] {
                        
                        self.delegate?.didUpdatePrice(exchangeRate: exchangeRate)
                        
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            
            task.resume()
        }
        
    }
}
