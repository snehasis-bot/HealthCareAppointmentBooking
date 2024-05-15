//
//  HomeView.swift
//  HealthCareAppointmentBooking
//
//  Created by Pravin Jadhav on 13/5/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the EasyAppoint")
                    .font(.title)
                    .padding()
                
                // Create an instance of AppointmentViewModel
                let appointmentViewModel = AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel())
                
                // Button to navigate to DoctorSearchView
                NavigationLink(destination: DoctorSearchView(appointmentViewModel: appointmentViewModel)) {
                    Text("Find Practitioner")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
