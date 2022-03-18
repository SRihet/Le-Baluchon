//
//  City.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 12/03/2022.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let country: String
}

extension City {
    static func cities() -> [City] {
        guard
          let url = Bundle.main.url(forResource: "cities", withExtension: "json"),
          let data = try? Data(contentsOf: url)
          else {
            return []
        }
        
        do {
          let decoder = JSONDecoder()
          return try decoder.decode([City].self, from: data)
        } catch {
          return []
        }
      }
    }


struct MyCities {
    static var myCity = "Nantes"
    static var myTravelCity = "New York"

}
