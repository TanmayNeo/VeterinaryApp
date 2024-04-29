//
//  PetsAPI.swift
//  VeterinaryApp
//
//  Created by Tanmay on 28/04/24.
//  Copyright © 2024 Tanmay Khopkar. All rights reserved.
//

import Foundation

enum PetsAPI: APIRequest {
    
    case pets
    case config
    
    var path: String {
        var urlPath = ""
        switch self {
        case .pets:
            urlPath = "/VeterinayAppJsons/pets.json"
        case .config:
            urlPath = "/VeterinayAppJsons/config.json"
        }
        return baseURL + urlPath
    }
    
    var headers: [String : String] {
        switch self {
        case .config, .pets:
            return ["Authorisation": Bundle.main.infoDictionary?["TOKEN"] as? String ?? "",
                    "Content-Type": "application/json"]
        }
    }
}
