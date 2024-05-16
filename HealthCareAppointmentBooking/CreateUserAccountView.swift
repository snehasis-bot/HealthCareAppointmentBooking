//
//  CreateUserAccountView.swift
//  HealthCareAppointmentBooking
//
//  Created by Pravin Jadhav on 15/5/2024.
//
import SwiftUI

struct CreateUserAccountView: View {
    @StateObject private var loginViewModel: LoginViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var isEmailValid = true
    @State private var navigateToLogin = false // New state variable for navigation

    init(loginViewModel: LoginViewModel) {
        _loginViewModel = StateObject(wrappedValue: loginViewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
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

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: email) { newValue in
                        isEmailValid = isValidEmail(newValue)
                    }
                    .autocapitalization(.none)

                if !isEmailValid {
                    Text("Please enter a valid email")
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Button("Create Account") {
                    createUser()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Create Account")
            .padding()
            .background(
                NavigationLink(destination: LoginView(), isActive: $navigateToLogin) { EmptyView() }
            )
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func createUser() {
        guard isEmailValid else {
            return
        }
        loginViewModel.createUser(username: username, password: password, email: email)
        navigateToLogin = true // Set navigation flag to true after creating user
    }
}

struct CreateUserAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserAccountView(loginViewModel: LoginViewModel(healthCareDataViewModel: HealthCareDataViewModel()))
    }
}

