//
//  CustomCurrencyCell.swift
//  currencyAPI
//
//  Created by Daniel Kouba on 2/26/17.
//  Copyright © 2017 Daniel Kouba. All rights reserved.
//

import UIKit

class CustomCurrencyCell: UITableViewCell {
    
    
    @IBOutlet weak var flagOutput: UIImageView!
    @IBOutlet weak var nameOutputLabel: UILabel!
    @IBOutlet weak var conversionRateOutputLabel: UILabel!
    
    private var _model: Currency?
    
    var model: Currency {
        get {
            return self._model!
        }
        set {
            self._model = newValue
            self.flagOutput?.image = UIImage(named: model.name)
            self.nameOutputLabel?.text = model.name
            self.conversionRateOutputLabel.text = String(format: "%.2f", model.rate)
        }
    }
    
    
    
}
