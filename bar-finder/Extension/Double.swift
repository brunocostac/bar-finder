//
//  Double.swift
//  bar-finder
//
//  Created by Bruno Costa on 16/02/23.
//

import Foundation

extension Double {
    var formattedInteger: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }

    var formattedDecimal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }

    func localizedDistanceString(from location: String) -> String {
        var localizedString = NSLocalizedString("", comment: "")
        var formattedDistance = ""
        if self <= 1_000 {
            localizedString = NSLocalizedString("A %@m de %@", comment: "X meters from location")
            formattedDistance = self.formattedInteger
        } else {
            localizedString = NSLocalizedString("A %@km de %@", comment: "X kilometers from location")
            formattedDistance = (self / 1000).formattedDecimal
        }
        return String(format: localizedString, formattedDistance, location)
    }
}
