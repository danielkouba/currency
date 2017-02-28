//
//  conversionDelegate.swift
//  currencyAPI
//
//  Created by Daniel Kouba on 2/26/17.
//  Copyright © 2017 Daniel Kouba. All rights reserved.
//

import Foundation


protocol conversionDelegate: class{
    func conversionTableViewController(controller: ConversionTableViewController, userSelectedBase details: CalcSettings)
    func cancelButtonPressedFrom(controller: ConversionTableViewController)
}
