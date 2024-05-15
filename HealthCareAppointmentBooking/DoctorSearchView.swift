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
    
    @State private var searchText = ""
    @State private var selectedDoctor: Doctor? = nil
    
    init(appointmentViewModel: AppointmentViewModel) {
        self.appointmentViewModel = appointmentViewModel
    }
    
    var filteredDoctors: [Doctor] {
        if searchText.isEmpty {
            return viewModel.doctors
        } else {
            return viewModel.doctors.filter { doctor in
                let searchTextLowercased = searchText.lowercased()
                return doctor.name.localizedCaseInsensitiveContains(searchTextLowercased) ||
                    doctor.specialty.localizedCaseInsensitiveContains(searchTextLowercased) ||
                    doctor.clinic.localizedCaseInsensitiveContains(searchTextLowercased) ||
                    doctor.address.localizedCaseInsensitiveContains(searchTextLowercased)
            }
        }
    }

    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search doctors", text: $searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                List(filteredDoctors) { doctor in
                    VStack(alignment: .leading) {
                        Text(doctor.name)
                            .font(.headline)
                        Text("Specialty: \(doctor.specialty)")
                        Text("Clinic: \(doctor.clinic)")
                        Text("Address: \(doctor.address)")
                        Text("Phone: \(doctor.phone)")
                    }
                    .padding(.vertical)
                    
                    NavigationLink(destination: BookAppointmentView(appointmentViewModel: appointmentViewModel, doctor: doctor)) {
                        Text("Book Appointment")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Doctors")
        }
    }
}


struct DoctorSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorSearchView(appointmentViewModel: AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel()))
    }
}
