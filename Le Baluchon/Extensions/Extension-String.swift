//
//  Extension-Strings.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 13/04/2022.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        
        if self.firstIndex(of: ",") != nil {
            formatter.decimalSeparator = ","
        } else { formatter.decimalSeparator = "." }
        
        let grade = formatter.number(from: self)
        if let doubleGrade = grade?.doubleValue {
            return doubleGrade
        } else {
            return nil
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
