//
//  ViewController.swift
//  Pricy
//
//  Created by can on 16.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    
    // Create an instance of Manager to handle the exchange rate fetching
    var manager = Manager()
    
    // Variables to hold the selected currencies from the picker view
    var fromCurrency = ""
    var toCurrency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate for manager to this view controller
        manager.delegate = self
        
        // Set the picker view's delegate and data source to this view controller
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
}

//MARK: - PickerView

// Extension to handle the picker view's delegate and data source methods
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of components (columns) in the picker view. In this case, 2 (for "from" and "to" currencies)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Number of rows in each component of the picker view (equal to the number of available currencies)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return manager.currencies.count
    }
    
    // Title for each row in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return manager.currencies[row]
    }
    
    // Handle the selection of a row in the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // If the user selects a row in the first component, update the fromCurrency
        if component == 0 {
            fromCurrency = manager.currencies[row]
        }
        // If the user selects a row in the second component, update the toCurrency
        else {
            toCurrency = manager.currencies[row]
        }
        
        // Fetch the exchange rate for the selected currency pair
        manager.fetchExchangeRate(from: fromCurrency, to: toCurrency)
    }
    
    // Customize the appearance of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }
        
        label.text = manager.currencies[row]
        label.textAlignment = .center
        
        // Adjust the font size to fit within the row
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
}

//MARK: - ManagerDelegate

// Extension to implement the ManagerDelegate protocol
extension ViewController: ManagerDelegate {
    
    // Update the price label when the exchange rate is successfully fetched
    func didUpdatePrice(exchangeRate: Double) {
        DispatchQueue.main.async {
            self.priceLabel.text = "1 \(self.fromCurrency) = \(exchangeRate) \(self.toCurrency)"
        }
    }
    
    // Print an error message if the fetching fails
    func didFailWithError(error: any Error) {
        print(error)
    }
}
