//
//  APIService.swift
//  VeterinaryApp
//
//  Created by Tanmay on 28/04/24.
//  Copyright © 2024 Tanmay Khopkar. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func performPetsDataRequest(completionHandler: @escaping(Result<PetResponse,APIError>)->Void)
    func performClinicDetailsRequest(completionHandler: @escaping(Result<ConfigResponse,APIError>)->Void)
   
}

class APIService: APIServiceProtocol {
    private var networkManager: APIClient
    
    init(networkManager: APIClient) {
        self.networkManager = networkManager
    }
    
    func performPetsDataRequest(completionHandler: @escaping (Result<PetResponse, APIError>) -> Void) {
        networkManager.performURLSessionRequest(with: PetsAPI.pets, completionHandler: completionHandler)
    }
    
    func performClinicDetailsRequest(completionHandler: @escaping (Result<ConfigResponse, APIError>) -> Void) {
        networkManager.performURLSessionRequest(with: PetsAPI.config, completionHandler: completionHandler)
    }
}
