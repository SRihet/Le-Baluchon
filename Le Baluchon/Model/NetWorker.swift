//
//  NetWorker.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

// Performs API requests
class NetWorker {
    // A closure to provide the status of a network call to ViewControllers
    typealias Callback = (Bool, Any?) -> Void
    
    var request: URLRequest?
    var resource: Any?

    static var shared = NetWorker()
    private init() {}

    private var task: URLSessionDataTask?


    private var session = URLSession(configuration: .default)
    
    // for testing
    init(session: URLSession) {
        self.session = session
    }
}

extension NetWorker {
    /**
     Perform a session dataTask with URLRequest to different APIs

     - Parameters:
        - API: APIs type
        - input: Value input by the user and used by the API (parameters)
        - callback: Provides the status of the session and returns decoded data to the ViewControllers
     */
    func query(API: WebService, input: String = "", callback: @escaping Callback) {
        task?.cancel()

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
                    if CurrencyService.parse(data, with: decoder) as? Int == -1 {
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
     Calls `createRequest` for the different APIs
     - Parameters:
        - API: APIs type
        - input: Value input by the user and used by the API (parameters)
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

