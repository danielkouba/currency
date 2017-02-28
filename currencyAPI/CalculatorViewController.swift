//
//  CalculatorViewController.swift
//  currencyAPI
//
//  Created by Daniel Kouba on 2/26/17.
//  Copyright © 2017 Daniel Kouba. All rights reserved.
//

import UIKit
import Alamofire


class CalculatorViewController: UIViewController, conversionDelegate {
    
    var basedata: NSDictionary?
    
    var calc = CalcSettings(base: "USD", second: "GBP", rate: 0.8, amount: 1.0)
    
    ////////////////////////////////////////
    // Output Label
    @IBOutlet weak var convertedAmountOutputLabel: UITextField!
    @IBOutlet weak var baseAmountOutputLabel: UITextField!
    
    ////////////////////////////////////////////
    // Button Outlets
    @IBOutlet weak var baseButtonLabel: UIButton!
    @IBOutlet weak var secondButtonLabel: UIButton!
    
    
    var digitsEntered = [String]()
    
    ////////////////////////////////////////////
    // Catch Changes in Text Field
    @IBAction func newValueEntered(_ sender:  UITextField) {
        ////////////////////////////////////////////
        // Text Processing
        guard let baseAmount = sender.text?.currencyInputFormatting() else {
            return
        }
        
        // If the text field is empty or 0 use 0.00
        if sender.text! == "0" || Double(baseAmount) == nil{
            convertedAmountOutputLabel.text = "0.00"
            calc.amount = 0.00
        } else {
            convertedAmountOutputLabel.text = calc.convert(val: Double(baseAmount)!)
        }
        
        baseAmountOutputLabel.text = baseAmount
        
    }
    
    ////////////////////////////////////////
    // Set up segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! ConversionTableViewController
        controller.delegate = self
        controller.currentCalc = calc
        if segue.identifier == "baseIdentifier"{
            controller.lookup = self.calc.second
        } else if segue.identifier == "secondaryIdentifier"{
            controller.lookup = self.calc.base
        }
    }
    ////////////////////////////////////////
    // Cancel Button Delegate
    func cancelButtonPressedFrom(controller: ConversionTableViewController){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func conversionTableViewController(controller: ConversionTableViewController, userSelectedBase details: CalcSettings) {
        //Get the object back from the table view
        calc = details
        //Update buttons with new values
        baseButtonLabel.setTitle(details.base,for: .normal)
        secondButtonLabel.setTitle(details.second,for: .normal)
        //Recalculate the conversion
        convertedAmountOutputLabel.text = calc.convert(val: calc.amount!);
        
        //Dismiss window
        dismiss(animated: true, completion: nil)
        //Focus on base text field
        baseAmountOutputLabel.becomeFirstResponder()
    }

    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let url = "http://api.fixer.io/latest?base=USD"
        
            
            Alamofire.request(url, method: .get , parameters: nil, headers: nil)
                .responseJSON{ response in
                    
                    ////////////////////////////////////////
                    // Perform actions on response
                    if let jsonResult = response.result.value as? NSDictionary {
                        ////////////////////////////////////////
                        // Get rates from returned data
                        for (key, value) in jsonResult {
                            if String(describing: key) == "rates" {
                                self.basedata = value as? NSDictionary;
                            }
                        }
                        
                        
                        ////////////////////////////////////////
                        // Refresh Table Data
                        // Write over hardcoded data with data from API
                        print(self.calc.rate)
                        self.calc.rate = self.basedata!["GBP"]! as! Double
                        print(self.calc.rate)
                        //Update converted amount
                        self.convertedAmountOutputLabel.text = self.calc.convert(val: 1.00)
                    } else {
                        // Alamofire sometimes recieves an invalid JSON data
                        print(response)
                    }
                    
    
        
                }
        
    
        baseAmountOutputLabel.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
