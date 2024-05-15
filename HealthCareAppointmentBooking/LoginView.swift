//
//  LoginView.swift
//  HealthCareAppointmentBooking
//
//  Created by Pravin Jadhav on 15/5/2024.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel(healthCareDataViewModel: HealthCareDataViewModel())
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var validationMessage = ""

    var body: some View {
        VStack {
            if !loginViewModel.isAuthenticated {
                // Login fields and buttons
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Text(validationMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)

                Button("Login") {
                    if loginViewModel.authenticateUser(username: username, password: password) {
                        // Navigate to DoctorSearchView if authentication succeeds
                        loginViewModel.isAuthenticated = true
                    } else if loginViewModel.isNewUser {
                        showAlert = true
                    } else {
                        validationMessage = "Invalid username or password"
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)

                // Link to create a user account
                NavigationLink(destination: CreateUserAccountView(loginViewModel: loginViewModel)) {
                    Text("Create Account")
                        .foregroundColor(.green)
                }
                .padding(.top, 10)
            } else {
                // Empty view, navigate to DoctorSearchView
                NavigationLink(
                    destination: DoctorSearchView(appointmentViewModel: AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel())),
                    isActive: $loginViewModel.isAuthenticated
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .navigationTitle("Login")
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Create Account"),
                message: Text("You are a new user. Please create an account."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
