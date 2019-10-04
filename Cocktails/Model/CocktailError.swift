//
//  CocktailError.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation

enum CocktailError: Error {
    case internetConnectionError
    case serviceConnectionError
    case imageLoadingError
}
