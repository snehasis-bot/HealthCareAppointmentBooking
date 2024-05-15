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
                
                // Button to navigate to DoctorSearchView
                NavigationLink(destination: DoctorSearchView(appointmentViewModel: AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel()))) {
                    Text("Find Practitioner")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                HStack {
                    Text("Haven't Logged In yet?").foregroundColor(.gray)
                    NavigationLink(destination: LoginView()) {
                        Text("Log In").padding().foregroundColor(.green)
                    }
                }
                .padding(.bottom, 5)

            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
