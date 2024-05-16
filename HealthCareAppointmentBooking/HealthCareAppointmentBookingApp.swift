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
    let loginViewModel: LoginViewModel

    init() {
        appointmentViewModel = AppointmentViewModel(healthCareDataViewModel: healthCareDataViewModel, doctorSearchViewModel: doctorSearchViewModel)
        loginViewModel = LoginViewModel(healthCareDataViewModel: healthCareDataViewModel)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appointmentViewModel: appointmentViewModel)
                .environmentObject(loginViewModel) // Inject LoginViewModel into environment
        }
    }
}

