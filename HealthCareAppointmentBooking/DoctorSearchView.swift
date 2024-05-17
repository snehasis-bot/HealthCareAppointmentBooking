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
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchText = ""
    @State private var selectedDoctor: Doctor? = nil
    @State private var showAlert = false
    @State private var isNavigating = false

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
                
                Button(action: {
                    if loginViewModel.isAuthenticated {
                        selectedDoctor = doctor
                        isNavigating = true
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Book Appointment")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle("Doctors")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Authentication Required"),
                message: Text("Please login to book an appointment."),
                dismissButton: .default(Text("OK"))
            )
        }
        .background(
            NavigationLink(
                destination: selectedDoctor.map { doctor in
                    BookAppointmentView(appointmentViewModel: appointmentViewModel, doctor: doctor)
                },
                isActive: $isNavigating,
                label: {
                    EmptyView()
                }
            )
        )
        .background(GradientBackground()) // Set background here
    }
}

struct DoctorSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let healthCareDataViewModel = HealthCareDataViewModel()
        let doctorSearchViewModel = DoctorSearchViewModel()
        let appointmentViewModel = AppointmentViewModel(healthCareDataViewModel: healthCareDataViewModel, doctorSearchViewModel: doctorSearchViewModel)
        let loginViewModel = LoginViewModel(healthCareDataViewModel: healthCareDataViewModel)
        
        // Adding some sample data for the preview
        doctorSearchViewModel.doctors = [
            Doctor(name: "Dr. Alice Johnson", specialty: "Cardiology", clinic: "Heart Care Clinic", address: "123 Heart St", phone: "123-456-7890"),
            Doctor(name: "Dr. Bob Smith", specialty: "Dermatology", clinic: "Skin Clinic", address: "456 Skin Ave", phone: "987-654-3210")
        ]
        
        return NavigationView {
            DoctorSearchView(appointmentViewModel: appointmentViewModel)
                .environmentObject(loginViewModel)
                .environmentObject(doctorSearchViewModel)
                .onAppear {
                    loginViewModel.isAuthenticated = true
                    loginViewModel.currentUser = UserEntity(context: healthCareDataViewModel.container.viewContext)
                    loginViewModel.currentUser?.userName = "TestUser"
                }
        }
    }
}
