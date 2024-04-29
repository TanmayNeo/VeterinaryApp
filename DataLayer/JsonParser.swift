//
//  JsonParser.swift
//  VeterinaryApp
//
//  Created by Tanmay on 12/04/23.
//

import Foundation

struct JsonParser {
   
    private func parseJson<T: Codable>(data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: data)
            return jsonData
        } catch let e {
            debugPrint(e)
            return nil
        }
    }
    
    func parseJson<T: Codable>(type: T.Type, data: Data) -> T? {
        return self.parseJson(data: data)
    }
}
