//
//  City.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 12/03/2022.
//

import Foundation

// MARK: Struct model for match with cities JSON file
struct City: Decodable {
    let id: Int
    let name: String
    let country: String
}

extension City {

     // Decodes a response from the JSON file and return the requested resource
    static func cities(fileName: String = "cities") -> [City] {
        guard
          let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
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
