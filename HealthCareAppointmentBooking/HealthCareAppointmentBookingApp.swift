//
//  HealthCareAppointmentBookingApp.swift
//  HealthCareAppointmentBooking
//
//  Created by Snehasis Sahoo on 13/5/2024.
//

import SwiftUI

@main
struct HealthCareAppointmentBookingApp: App {
    let healthCareDataViewModel = HealthCareDataViewModel()
    let doctorSearchViewModel = DoctorSearchViewModel()
    let appointmentViewModel: AppointmentViewModel

    init() {
        appointmentViewModel = AppointmentViewModel(healthCareDataViewModel: healthCareDataViewModel,doctorSearchViewModel: doctorSearchViewModel)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appointmentViewModel: appointmentViewModel)
        }
    }
}
