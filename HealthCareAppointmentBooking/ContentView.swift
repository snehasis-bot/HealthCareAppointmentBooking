//
//  ContentView.swift
//  HealthCareAppointmentBooking
//
//  Created by Snehasis Sahoo on 13/5/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appointmentViewModel: AppointmentViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    HomeView()
                        .environmentObject(loginViewModel)
                } else if selectedTab == 1 {
                    AppointmentView(appointmentViewModel: appointmentViewModel)
                        .environmentObject(loginViewModel)
                } else if selectedTab == 2 {
                    ProfileView()
                        .environmentObject(loginViewModel)
                }
                Spacer()
                navButtons
            }
            .background(GradientBackground()) // Set background here
            .navigationBarHidden(true)
        }
    }

    var navButtons: some View {
        HStack {
            Spacer()
            
            Button(action: { selectedTab = 0 }) {
                Image(systemName: "house")
                    .font(.system(size: 28))
            }
            .padding(.trailing, 20)
            
            Spacer()
            
            Button(action: { selectedTab = 1 }) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 28))
            }
            .padding(.leading, 20)
            
            Spacer()
            
            Button(action: { selectedTab = 2 }) {
                Image(systemName: "person.circle")
                    .font(.system(size: 28))
            }
            .padding(.leading, 20)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let healthCareDataViewModel = HealthCareDataViewModel()
        let doctorSearchViewModel = DoctorSearchViewModel()
        let appointmentViewModel = AppointmentViewModel(healthCareDataViewModel: healthCareDataViewModel, doctorSearchViewModel: doctorSearchViewModel)
        let loginViewModel = LoginViewModel(healthCareDataViewModel: healthCareDataViewModel)
        
        return ContentView(appointmentViewModel: appointmentViewModel)
            .environmentObject(loginViewModel)
    }
}

