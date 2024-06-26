//
//  BookingAppointmentView.swift
//  HealthCareAppointmentBooking
//
//  Created by Kajal Maskar on 13/5/2024.
//

import SwiftUI

struct BookAppointmentView: View {
    @ObservedObject var appointmentViewModel: AppointmentViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    var doctor: Doctor

    @State private var patientName: String = ""
    @State private var patientAge: String = ""
    @State private var patientGender = "F"
    @State private var clinicAddress: String = ""
    @State private var date = Date()
    @State private var showAlert = false
    @State private var validationMessage = ""
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var isSubmitDisabled: Bool {
        return !validationMessage.isEmpty || patientName.isEmpty || patientAge.isEmpty || clinicAddress.isEmpty
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GradientBackground() // Apply gradient background

                VStack {
                    Spacer()

                    TextField("Patient Name", text: $patientName)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: patientName) { oldvalue,newValue in
                            validatePatientName(newValue)
                        }

                    TextField("Patient Age", text: $patientAge)
                        .padding()
                        .keyboardType(.numberPad)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: patientAge) { oldvalue,newValue in
                            validatePatientAge(newValue)
                        }

                    Picker("Gender", selection: $patientGender) {
                        Text("Female").tag("F")
                        Text("Male").tag("M")
                        Text("Others").tag("T")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    TextField("Clinic Address", text: $clinicAddress)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .disabled(true)
                        .onAppear {
                            clinicAddress = "\(doctor.clinic), \(doctor.address)"
                        }

                    DatePicker("Date", selection: $date, in: Date()..., displayedComponents: .date)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)

                    Button("Submit") {
                        if validationMessage.isEmpty {
                            if let userID = loginViewModel.currentUser?.userID {
                                appointmentViewModel.bookAppointment(
                                    patientName: patientName,
                                    clinicAddress: clinicAddress,
                                    date: date,
                                    doctorName: doctor.name,
                                    age: Int16(patientAge) ?? 0,
                                    gender: patientGender,
                                    userID: userID
                                )
                                showAlert = true
                            }
                        }
                    }
                    .padding()
                    .background(isSubmitDisabled ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(isSubmitDisabled)

                    if !validationMessage.isEmpty {
                        Text(validationMessage)
                            .foregroundColor(.red)
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("") // Empty text to maintain space
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()
                }
                .frame(width: geometry.size.width * 0.9) // Adjust width based on screen size
                .navigationTitle("Book Appointment")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Appointment Booked"),
                        message: Text("Your appointment has been successfully booked."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .edgesIgnoringSafeArea(.all) // Ensure the background covers the entire screen
        }
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
            .environmentObject(LoginViewModel(healthCareDataViewModel: HealthCareDataViewModel()))
    }
}


