//
//  DoctorSearchViewModel.swift
//  HealthCareAppointmentBooking
//
//  Created by Kush Mali on 13/5/2024.
//

import Foundation

class DoctorSearchViewModel: ObservableObject {
    @Published var doctors: [Doctor] = []
    @Published var selectedDoctor: Doctor? // Track the selected doctor
    
    init() {
        loadDoctorsFromJSON()
    }
    
    // Function to load JSON data
    func loadDoctorsFromJSON() {
        if let url = Bundle.main.url(forResource: "DoctorData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(DoctorData.self, from: data)
                self.doctors = decodedData.doctors
               // printDoctorDetails() // Call printDoctorDetails here
                print("JSON data loaded successfully.")
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
    
    // Function to print doctor details
    func printDoctorDetails() {
        for doctor in doctors {
            print("Name: \(doctor.name)")
            print("Specialty: \(doctor.specialty)")
            print("Clinic: \(doctor.clinic)")
            print("Address: \(doctor.address)")
            print("Phone: \(doctor.phone)")
            print("-------------------------")
        }
    }
}

