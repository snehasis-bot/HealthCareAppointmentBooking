//
//  DoctorSearchView.swift
//  HealthCareAppointmentBooking
//
//  Created by Kajal Maskar on 13/5/2024.
//

import SwiftUI

struct DoctorSearchView: View {
    @ObservedObject var viewModel = DoctorSearchViewModel()
    @ObservedObject var appointmentViewModel: AppointmentViewModel
    
    @State private var selectedDoctor: Doctor? = nil
    
    init(appointmentViewModel: AppointmentViewModel) {
        self.appointmentViewModel = appointmentViewModel
    }
    
    var body: some View {
        List(viewModel.doctors) { doctor in
            VStack(alignment: .leading) {
                Text(doctor.name)
                    .font(.headline)
                Text("Specialty: \(doctor.specialty)")
                Text("Clinic: \(doctor.clinic)")
                Text("Address: \(doctor.address)")
                Text("Phone: \(doctor.phone)")
            }
            .padding(.vertical)
            
            NavigationLink(destination: BookAppointmentView(appointmentViewModel: appointmentViewModel,doctor: doctor)) {
                Text("Book Appointment")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Doctors")
    }
}

struct DoctorSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorSearchView(appointmentViewModel: AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel()))
    }
}
