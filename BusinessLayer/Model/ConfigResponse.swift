//
//  ConfigResponse.swift
//  VeterinaryApp
//
//  Created by Tanmay on 28/04/24.
//  Copyright © 2024 Tanmay Khopkar. All rights reserved.
//

import Foundation

struct ConfigResponse: Codable {
    var settings: Settings?
}

struct Settings: Codable {
    var isChatEnabled, isCallEnabled: Bool?
    var workHours: String?
}
