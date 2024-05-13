//
//  BookingAppointmentView.swift
//  HealthCareAppointmentBooking
//
//  Created by Kajal Maskar on 13/5/2024.
//

import SwiftUI

struct BookAppointmentView: View {
    @ObservedObject var appointmentViewModel: AppointmentViewModel
    var doctor: Doctor
    
    @State private var patientName: String = ""
    @State private var patientAge: String = ""
    @State private var patientGender = "F"
    @State private var clinicAddress: String = ""
    @State private var date = Date()
    @State private var showAlert = false
    @State private var validationMessage = ""
    
    var isSubmitDisabled: Bool {
        return !validationMessage.isEmpty || patientName.isEmpty || patientAge.isEmpty || clinicAddress.isEmpty
            || (isNumeric(patientName) && isNumeric(patientAge)) || (!isNumeric(patientName) && !isNumeric(patientAge))
    }
    
    var body: some View {
        VStack {
            TextField("Patient Name", text: $patientName)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .onChange(of: patientName) { newValue in
                    validatePatientName(newValue)
                }
            TextField("Patient Age", text: $patientAge)
                .padding()
                .keyboardType(.numberPad)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .onChange(of: patientAge) { newValue in
                    validatePatientAge(newValue)
                }
            Picker("Gender", selection: $patientGender) {
                Text("Female").tag("F")
                Text("Male").tag("M")
                Text("Transgender").tag("T")
            }
            .pickerStyle(SegmentedPickerStyle())
            TextField("Clinic Address", text: $clinicAddress)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .disabled(true)
                .onAppear {
                    // Concatenate clinic and address from selectedDoctor
                    clinicAddress = "\(doctor.clinic), \(doctor.address)"
                }
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            
            Button("Submit") {
                if validationMessage.isEmpty {
                    // Pass additional parameters to bookAppointment method
                    appointmentViewModel.bookAppointment(patientName: patientName,
                                                          clinicAddress: clinicAddress,
                                                          date: date,
                                                            doctorName: doctor.name,
                                                          age: Int16(patientAge) ?? 0,
                                                          gender: patientGender)
                    showAlert = true
                }
            }
            .padding()
            .cornerRadius(8)
            .disabled(isSubmitDisabled)
            
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .foregroundColor(.red) // Display validation message
            }
        }
        .navigationTitle("Book Appointment")
        .navigationBarTitleDisplayMode(.inline) // Set navigation title display mode
        .navigationBarItems(trailing: EmptyView())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Appointment Booked"),
                message: Text("Your appointment has been successfully booked."),
                dismissButton: .default(Text("OK"))
            )
        }
        .font(.title)
    }
    
    private func validatePatientName(_ newValue: String) {
        if newValue.isEmpty {
            validationMessage = "Patient Name cannot be empty"
        } else if newValue.rangeOfCharacter(from: CharacterSet.letters.union(CharacterSet.whitespaces).inverted) != nil {
            validationMessage = "Patient Name should contain only alphabets or spaces"
        } else if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationMessage = "Patient Name should contain at least one alphabet"
        } else {
            validationMessage = ""
        }
    }

    
    private func validatePatientAge(_ newValue: String) {
        if newValue.isEmpty {
            validationMessage = "Patient Age cannot be empty"
        } else if !isNumeric(newValue) {
            validationMessage = "Patient Age should be a number"
        } else if let age = Int(newValue), !(1...110).contains(age) {
            validationMessage = "Patient Age should be between 1 and 110 years"
        } else {
            validationMessage = ""
        }
    }
    
    private func isNumeric(_ value: String) -> Bool {
        return Int(value) != nil
    }
}





struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        let appointmentViewModel = AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel())

        let doctor = Doctor(name: "Dr. Smith", specialty: "Cardiology", clinic: "Cardio Clinic", address: "123 Main St", phone: "123-456-7890")
        
        return BookAppointmentView(appointmentViewModel: appointmentViewModel, doctor: doctor)
    }
}

