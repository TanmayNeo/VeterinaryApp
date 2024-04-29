//
//  UIImageView+!xtension.swift
//  VeterinaryApp
//
//  Created by Tanmay on 28/04/24.
//  Copyright © 2024 Tanmay Khopkar. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String?, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let urlString = link,
              let url = URL(string: urlString) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

