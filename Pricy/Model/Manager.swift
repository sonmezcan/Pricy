//
//  Manager.swift
//  Pricy
//
//  Created by can on 16.10.2024.
//

import Foundation

// Protocol defining methods to handle successful or failed exchange rate fetching
protocol ManagerDelegate {
    // Called when the exchange rate is successfully fetched
    func didUpdatePrice(exchangeRate: Double)
    
    // Called when there is an error during the fetching process
    func didFailWithError(error: Error)
}

struct Manager {
    
    var delegate: ManagerDelegate?
    
    // List of currencies to display in the picker view, including a placeholder
    let currencies = ["PICK CURRENCY", "AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD",
                      "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON",
                      "RUB", "SEK", "SGD", "USD", "ZAR", "TRY"]
    let switcher = ["to","from"]
    
    // Function to fetch the exchange rate for the selected currency pair
    func fetchExchangeRate(from: String, to: String) {
        // Construct the URL using the base currency
        let urlString = "https://api.exchangerate-api.com/v4/latest/\(from)"
        
        // Check if the URL is valid
        if let url = URL(string: urlString) {
            
            // Create a URLSession to handle the data task
            let session = URLSession(configuration: .default)
            
            // Create a task to fetch data from the API
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // If an error occurs, notify the delegate
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                // If data is successfully received, attempt to parse the JSON
                if let safeData = data {
                    // Parse the JSON and get the exchange rate for the desired currency pair
                    if let exchangeRate = self.parseJSON(safeData, to: to) {
                        // Notify the delegate with the fetched exchange rate
                        self.delegate?.didUpdatePrice(exchangeRate: exchangeRate)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    // Function to parse the JSON data and extract the exchange rate
    func parseJSON(_ data: Data, to: String) -> Double? {
        let decoder = JSONDecoder()
        do {
            // Decode the JSON into a CurrencyData struct
            let decodedData = try decoder.decode(CurrencyData.self, from: data)
            
            // Attempt to get the exchange rate for the target currency
            if let rate = decodedData.rates[to] {
                return rate // Return the exchange rate if found
            } else {
                return nil // Return nil if the target currency is not found
            }
        } catch {
            // Notify the delegate if there is an error in parsing the data
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
