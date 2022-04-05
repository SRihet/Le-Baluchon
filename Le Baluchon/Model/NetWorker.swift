//
//  NetWorker.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

/// Perform API requests
class NetWorker {
    /// A closure to provide the state of a network call to the ViewControllers
    typealias Callback = (Bool, Any?) -> Void
    var request: URLRequest?
    /// Decoded data from an API
    var resource: Any?

    static var shared = NetWorker()
    private init() {}

    private var task: URLSessionDataTask?


    private var session = URLSession(configuration: .default)
    
    // for testing purpose
//    init(session: URLSession) {
//        self.session = session
//    }
}

extension NetWorker {
    /**
     Perform a session dataTask with URLRequest to different APIs

     - Parameters:
        - API: APIs used by Le Baluchon
        - input: Any value input by the user and used by the API to provide the expected resource
        - callback: Provides the state of the session and returns decoded data to the VCs

     - Note:
     As of november 2018, any API involved in Le Baluchon takes a String as an input type.
     To allow flexibility when calling `query` and avoid passing dummy value to the `input` parameter,
     `input` default value is an empty string.
     */
    func query(API: WebService, input: String = "", callback: @escaping Callback) {
        if API != .currency { task?.cancel() }

        guard let request = getRequest(API: API, for: input) else {
            callback(false, nil)
            return
        }

        task = session.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                let decoder = JSONDecoder()
                switch API {
                case .currency:
                    if CurrencyService.parse(data, with: decoder) as? Int == -1
                        ||
                        CurrencyService.parse(data, with: decoder) as? Int == -2
                    {
                        callback(false, nil)
                        return
                    }
                    self?.resource = CurrencyService.parse(data, with: decoder)

                case .translate:
                    if TranslateService.parse(data, with: decoder) as? Int == -1 {
                        callback(false, nil)
                        return
                    }
                    self?.resource = TranslateService.parse(data, with: decoder)
                    
                case .weather:
                    if WeatherService.parse(data, with: decoder) as? Int == -1 {
                        callback(false, nil)
                        return
                    }
                    self?.resource = WeatherService.parse(data, with: decoder)
                }

                callback(true, self?.resource)
            }
        }
        task?.resume()
    }
}

extension NetWorker {
    /**
     Call `createRequest` for each API

     - Parameters:
        - API: APIs used by Le Baluchon
        - input: Any value input by the user and used by the API to provide the expected resource

     - Note:
     As of november 2018, any API involved in Le Baluchon takes a String as an input type.
     To allow flexibility when calling `query` and avoid passing dummy values to the `input` parameter,
     `input` default value is an empty string.
     */
    private func getRequest(API: WebService, for input: String = "") -> URLRequest? {
        switch API {
        case .currency:
            request = CurrencyService.createRequest()
        case .translate:
            request = TranslateService.createRequest(for: input)
        case .weather:
            request = WeatherService.createRequest(for: input)
        }

        return request
    }
}

