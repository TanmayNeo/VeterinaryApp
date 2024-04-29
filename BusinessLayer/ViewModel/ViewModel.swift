//
//  ViewModel.swift
//  VeterinaryApp
//
//  Created by Tanmay on 28/04/24.
//  Copyright © 2024 Tanmay Khopkar. All rights reserved.
//

import Foundation

protocol IViewModel {
    func loadData()
    var dataLoadCompleted: (() -> Void)? { get set }
    var clinicDetailsFailed: ((String) -> Void)?  {get set}
    var petDataFailed: ((String) -> Void)? {get set}
}

class ViewModel: IViewModel {
    
    var dataLoadCompleted: (() -> Void)?
    var clinicDetailsFailed: ((String) -> Void)?
    var petDataFailed: ((String) -> Void)?
    
    private var apiServices: APIServiceProtocol
    private var petsResponse: PetResponse?
    var configResponse: ConfigResponse?
    private let dispatchGroup = DispatchGroup()
    
    init(apiService: APIServiceProtocol) {
        self.apiServices = apiService
    }
    
    func loadData() {
        dispatchGroup.enter()
        getPetsData()
        
        dispatchGroup.enter()
        getConfigData()
        
        dispatchGroup.notify(queue: .main) {
            self.dataLoadCompleted?()
        }
    }
    
    private func getPetsData() {
        apiServices.performPetsDataRequest { [weak self] result in
            guard let self = self else { return }
            defer {
                self.dispatchGroup.leave()
            }
            
            switch result {
            case .success(let response):
                self.petsResponse = response
            case .failure(let error):
                self.petDataFailed?(error.localizedDescription)
            }
        }
    }
    
    private func getConfigData() {
        apiServices.performClinicDetailsRequest { [weak self] result in
            guard let self = self else { return }
            defer {
                self.dispatchGroup.leave()
            }
            
            switch result {
            case .success(let response):
                self.configResponse = response
            case .failure(let error):
                self.clinicDetailsFailed?(error.localizedDescription)
            }
        }
    }
    
    func getPet(for index: Int) -> Pet? {
        self.petsResponse?.pets?[index]
    }
    
    func getClinicDetails() -> ConfigResponse? {
        self.configResponse
    }
    
    func getPetsCount() -> Int {
        self.petsResponse?.pets?.count ?? 0
    }
    
    func formatWorkHours() -> String  {
        let daysMapping = ["M": "Monday",
                           "T": "Tuesday",
                           "W": "Wednesday",
                           "Th": "Thursday",
                           "F": "Friday",
                           "Sa": "Saturday",
                           "Su": "Sunday"]
        
        guard let components = configResponse?.settings?.workHours?.components(separatedBy: " "),
              components.count > 3 else { return "Work hours has ended. Please contact us again on the next wor day"}
        
        let daysString = components[0]
        let startTime = components[1]
        let endTime = components[3]
        
        let daysArray = daysString.components(separatedBy: "-")
        guard daysArray.count == 2 else { return "Work hours has ended. Please contact us again on the next wor day"}
        
        var formattedDays = ""
        for day in daysArray {
            if let fullName = daysMapping[day] {
                formattedDays += fullName + " - "
            } else {
                return "Work hours has ended. Please contact us again on the next wor day"
            }
        }
        
        formattedDays = String(formattedDays.dropLast(3))
        let dayComponents = formattedDays.components(separatedBy: " - ")
        let lowerbound = dayComponents[0]
        let upperbound = dayComponents[1]
        let weekdays = Calendar.current.weekdaySymbols
        guard let startIndex = weekdays.firstIndex(of: lowerbound),
              let endIndex = weekdays.firstIndex(of: upperbound) else {return "Work hours has ended. Please contact us again on the next wor day"}
        let activeDays = weekdays[startIndex...endIndex]
        let currentDay = Calendar.current.component(.weekday, from: Date())

        if (currentDay - 1) < activeDays.count {
            
            let startHrs = Int(startTime.components(separatedBy: ":").first ?? "") ?? 0
            let endHrs = Int(endTime.components(separatedBy: ":").first ?? "") ?? 0
            let currentHr = Calendar.current.component(.hour, from: Date())
            return (currentHr > startHrs && currentHr < endHrs) ? "Thank you for getting in touch with us. We’ll get back" : "Work hours has ended. Please contact us again on the next wor day"
            
        } else {
            return "Work hours has ended. Please contact us again on the next wor day"
        }
    }

}
