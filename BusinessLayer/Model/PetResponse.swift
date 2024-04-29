//
//  PetResponse.swift
//  VeterinaryApp
//
//  Created by Tanmay on 28/04/24.
//  Copyright © 2024 Tanmay Khopkar. All rights reserved.
//

import Foundation

struct PetResponse: Codable {
    var pets: [Pet]?
}

struct Pet: Codable {
    var imageURL: String?
    var title: String?
    var contentURL: String?
    var dateAdded: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case title
        case contentURL = "content_url"
        case dateAdded = "date_added"
    }
}
