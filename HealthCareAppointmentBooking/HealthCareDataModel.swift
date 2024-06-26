//
//  HealthCareDataModel.swift
//  HealthCareAppointmentBooking
//
//  Created by Pravin Jadhav on 13/5/2024.
//

import Foundation

// Model class representing an Appointment
struct Appointment: Identifiable {
    let id: UUID
    let patientName: String
    let date: Date
    let clinicAddress: String
    let gender: String
    let age: Int16
    let doctorName: String
    let userID: UUID
}

struct Doctor: Identifiable, Decodable {
    var id = UUID()
    var name: String
    var specialty: String
    var clinic: String
    var address: String
    var phone: String
}

struct DoctorData: Decodable {
    var doctors: [Doctor]
}

struct User: Identifiable {
    let id: UUID
    let userName: String
    let password: String
    let emailID: String
}
