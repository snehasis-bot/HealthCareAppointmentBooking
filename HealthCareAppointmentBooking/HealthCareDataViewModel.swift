//
//  HealthCareDataViewModel.swift
//  HealthCareAppointmentBooking
//
//  Created by Snehasis Sahoo on 13/5/2024.
//

import Foundation
import CoreData

final class HealthCareDataViewModel : ObservableObject {
    
    // Setup container and entity values
    public let container: NSPersistentContainer
    private let healthCareDataContainer = "HealthCareDataModel"
    private let appointmentEntity = "AppointmentEntity"
    
    // Published array of AppointmentEntities
    @Published var appointments: [AppointmentEntity] = []
    @Published var errorMessage: String?

    // Init loads persistent container and then calls get favourites
    init() {
        container = NSPersistentContainer(name: healthCareDataContainer)
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            } else {
                print("Core Data loaded successfully!")
            }
        }
    }
}

