//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 28/03/2022.
//

import Foundation


class CurrencyService {
    
    static var arrayRates: [(currencys:String,symbols:String,rates:Double)] =
    [
        ("Dollar"," $",1.091894),
        ("Yen"," ¥",134.873433),
        ("Dollar canadien"," $",1.360822),
        ("Dollar australien"," $",1.438722),
        ("Franc suisse"," Fr",1.014751),
        ("Couronne danoise"," kr",7.437805),
        ("Yuan"," 元",6.948593),
        ("Roupie indonésienne"," Rp",15678.009386),
        ("Livre sterling"," £",0.833612),
        ("Lev bulgare"," лв",1.951028),
        ("Forint"," Ft",375.110234),
        ("Couronne islandaise"," kr",140.810215),
        ("Couronne norvégienne"," kr",9.541245),
        ("Kuna croate"," kn",7.541822),
        ("Rouble russe"," ₽",91.17143),
        ("Couronne suédoise"," kr",10.28495),
        ("Hryvnia"," ₴",32.09571),
        ("Couronne tchèque"," Kč",24.356219),
        ("Euro"," €",1)
    ]
    
    // MARK: Build a URL to access Fixer API
    
    static func createRequest() -> URLRequest {
        let completeURL = CurrencyAPI.url
        let url = URL(string: completeURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}

extension CurrencyService: ParseProtocol {
    
    // MARK: Parse JSON response
    
    static func parse(_ data: Data, with decoder: JSONDecoder) -> Any {
        guard let json = try? JSONDecoder().decode(CurrencyModel.self, from: data) else {
            return (-1)
        }
        let resource = json
        return resource
    }
}
