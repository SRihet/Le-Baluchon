//
//  Extension-Double.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 13/04/2022.
//

import Foundation

extension Double {
    func toString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        let doubleAsString =  formatter.string(from: NSNumber(value: self))!
        return doubleAsString
    }
}
