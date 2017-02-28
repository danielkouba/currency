//
//  Classes.swift
//  currencyAPI
//
//  Created by Daniel Kouba on 2/27/17.
//  Copyright © 2017 Daniel Kouba. All rights reserved.
//

import Foundation


class CalcSettings {
    var base: String
    var second: String
    var rate: Double
    var amount: Double?
    
    init(base: String, second: String, rate: Double, amount: Double){
        self.base = base
        self.second = second
        self.rate = rate
        self.amount = amount
    }
    
    func convert(val: Double) -> String{
        self.amount  = val
        return String(format: "%.2f", val * self.rate);
        
    }
}



class Currency {
    var name: String
    var rate: Double
    
    init(name: String, rate: Double){
        self.name = name
        self.rate = Double(rate)
    }
    
    func convert(val: Double, rate: Double) -> Double {
        return val / self.rate * rate
    }
}
