//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getBitcoinPrice(apiURL: baseURL + currencyArray[0])
    }

    //MARK: - UIPickerView Methods
    // Determines the number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let bitcoinURL = baseURL + currencyArray[row]
        
        // Obtain the price
        getBitcoinPrice(apiURL: bitcoinURL)
    }
    
    
//    //MARK: - Networking
//    /***************************************************************/
//    
    func getBitcoinPrice(apiURL : String) {
        //Alamofire.request(baseURL, method: .get, parameters: parameters)
        Alamofire.request(apiURL, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinUI(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateBitcoinUI(json : JSON) {
        
        if let priceResult = json["ask"].double {
            let priceDisplayValue = symbolArray[currencyPicker.selectedRow(inComponent: 0)] + String(priceResult)
            
            bitcoinPriceLabel.text = priceDisplayValue
        }else{
            bitcoinPriceLabel.text = "Data Unavailable"
        }
    }

}

