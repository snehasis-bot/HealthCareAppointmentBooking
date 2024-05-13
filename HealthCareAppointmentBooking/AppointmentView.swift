//
//  AppointmentView.swift
//  HealthCareAppointmentBooking
//
//  Created by Snehasis Sahoo on 13/5/2024.
//

import SwiftUI

struct AppointmentView: View {
    @ObservedObject var appointmentViewModel: AppointmentViewModel

    var body: some View {
        VStack {
            if let errorMessage = appointmentViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    VStack {
                        ForEach(appointmentViewModel.appointments, id: \.id) { appointment in
                            AppointmentRow(appointment: appointment, onDelete: {
                                appointmentViewModel.deleteAppointment(id: appointment.id)
                            })
                        }
                    }
                }
            }
        }
        .navigationTitle("Appointments")
        .onAppear {
            // Fetch appointments when the view appears
            appointmentViewModel.fetchAppointments()
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Patient: \(appointment.patientName)")
                Text("Gender: \(appointment.gender)")
                Text("Age: \(appointment.age)")
                Text("Consulting Doctor: \(appointment.doctorName)")
                Text("Date: \(appointment.date)")
                Text("Clinic Address: \(appointment.clinicAddress)")
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}


struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample appointment view model with dummy data
        let dummyViewModel = AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel())
        let dummyAppointments: [Appointment] = [
            Appointment(id: UUID(), patientName: "John Doe", date: Date(), clinicAddress: "123 Main St", gender: "M", age: 10, doctorName: "X"),
            Appointment(id: UUID(), patientName: "Jane Smith", date: Date(), clinicAddress: "456 Elm St",gender: "M", age: 10, doctorName: "Y")
        ]
        dummyViewModel.appointments = dummyAppointments
        
        // Return the preview of AppointmentView with the sample view model
        return AppointmentView(appointmentViewModel: dummyViewModel)
    }
}

