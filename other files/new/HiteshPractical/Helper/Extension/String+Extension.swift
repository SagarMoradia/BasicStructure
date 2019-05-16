//
//  String+Extension.swift
//  HiteshPractical
//
//  Created by MAC on 3/1/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation

extension String {    
    var StringToCurrency : String {
        var number : Double = 0.0
        if self != "" {
            number = Double(self)!
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        return formatter.string(from: number as NSNumber)!
    }
    
    var CurrencyToString : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let number = formatter.number(from: self)
        return (number?.stringValue)!
    }
}
