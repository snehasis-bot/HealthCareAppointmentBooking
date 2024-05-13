//
//  ContentView.swift
//  HealthCareAppointmentBooking
//
//  Created by Snehasis Sahoo on 13/5/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appointmentViewModel: AppointmentViewModel
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    HomeView()
                } else {
                    AppointmentView(appointmentViewModel: appointmentViewModel)
                }
                Spacer()
                navButtons
            }
           // .navigationBarTitle("HBA")
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let healthCareDataViewModel = HealthCareDataViewModel()
        let doctorSearchViewModel = DoctorSearchViewModel()
        let appointmentViewModel = AppointmentViewModel(healthCareDataViewModel: healthCareDataViewModel, doctorSearchViewModel: doctorSearchViewModel)
        
        return ContentView(appointmentViewModel: appointmentViewModel)
    }
}
