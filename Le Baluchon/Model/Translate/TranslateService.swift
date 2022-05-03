//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 06/02/2022.
//

import Foundation

class TranslateService {
    
    // MARK: Build a URL to access Google Translate API
    
    static func createRequest(for parameters: String) -> URLRequest {
        let encodedParameters = parameters.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let completeURL = TranslationAPI.url + TranslationAPI.text + encodedParameters!
        let url = URL(string: completeURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        return request
    }
}

extension TranslateService: ParseProtocol {
    
    // MARK: Parse JSON response
    
    static func parse(_ data: Data, with decoder: JSONDecoder) -> Any {
        guard let json = try? decoder.decode(TranslateModel.self, from: data) else {
            return (-1)
        }
        let resource = json
        return resource
    }
}
