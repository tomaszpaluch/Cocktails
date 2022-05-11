//
//  Mocks.swift
//  CocktailsTests
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation
@testable import Cocktails

class RestServiceMock: RestService {
    enum RestServiceMockType {
        case ingredients
        case cocktails
    }
    
    enum MockResult {
        case success
        case failure(CocktailError)
    }
    
    private let mockURL: URL?
    private let result: MockResult
    
    init(of type: RestServiceMockType, with result: MockResult) {
        switch type {
        case .ingredients:
            mockURL = URL(
                fileURLWithPath: Bundle.main.path(
                    forResource: "ingredients",
                    ofType: "json"
                )!
            )
        case .cocktails:
            mockURL = URL(
                fileURLWithPath: Bundle.main.path(
                    forResource: "ingredients",
                    ofType: "json"
                )!
            )
        }
        
        self.result = result
        
        super.init()
    }
    
    override func makeInquiry<T: Codable>(
        url: (site: String, params: [URLQueryItem]?),
        completion: @escaping (Result<T, CocktailError>) -> Void)
    {
        switch result {
        case .success:
            let jsonDecoder = JSONDecoder()
            if let url = mockURL, let dataResponse = try? Data(contentsOf: url), let responseModel = try? jsonDecoder.decode(T.self, from: dataResponse) {
                completion(.success(responseModel))
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}

