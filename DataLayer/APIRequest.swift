//
//  APIRequest.swift
//  VeterinaryApp
//
//  Created by Tanmay on 12/04/23.
//

import Foundation

protocol APIRequest {
    var baseURL: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var method: String { get }
}
extension APIRequest {
    var baseURL: String { (Bundle.main.infoDictionary?["BASEURL"] as? String)?.replacingOccurrences(of: "\\", with: "") ?? "" }
    var path: String { "" }
    var headers: [String: String] { [:] }
    var method: String { HTTPMethod.GET.rawValue }
 }
