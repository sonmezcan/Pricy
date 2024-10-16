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
    
    var manager = Manager()
    
    var fromCurrency = ""
    var toCurrency = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        manager.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
    }
    
    
    
}
//MARK: - PickerView

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return manager.currencies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return manager.currencies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            fromCurrency = manager.currencies[row]
        } else {
            toCurrency = manager.currencies[row]
        }
        
        
        manager.fetchExchangeRate(from: fromCurrency, to: toCurrency)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }
        
        label.text = manager.currencies[row]
        label.textAlignment = .center
        
        
        
        label.adjustsFontSizeToFitWidth = true
        return label
    }
}

//MARK: -ManagerDelegate

extension ViewController: ManagerDelegate {
    func didUpdatePrice(exchangeRate: Double) {
        DispatchQueue.main.async {
            
            self.priceLabel.text = "1 \(self.fromCurrency) = \(exchangeRate) \(self.toCurrency)"
        }
    }
    
    
    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
    
}
