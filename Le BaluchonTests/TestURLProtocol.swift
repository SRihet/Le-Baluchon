//
//  TestURLProtocol.swift
//  Le BaluchonTests
//
//  Created by Stéphane Rihet on 10/04/2022.
//

import Foundation
import XCTest

final class TestURLProtocol: URLProtocol {
    
    // Checks if this protocol can handle the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // Returns the canonical version of the request.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    // Handler to test the request and return mock response.
    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    // Creates the mock response as per the test case and send it to the URLProtocolClient.
    override func startLoading() {
        guard let handler = TestURLProtocol.loadingHandler else {
            XCTFail("Loading handler is not set.")
            return
        }
        // Call handler with received request and capture the tuple of response and data.
        let (response, data, _) = handler(request)
        if let data = data {
            // Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            // Send received data to the client.
            client?.urlProtocol(self, didLoad: data)
            // Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        }
        else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            // Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    // This is called if the request gets canceled or completed.
    override func stopLoading() {}
}
