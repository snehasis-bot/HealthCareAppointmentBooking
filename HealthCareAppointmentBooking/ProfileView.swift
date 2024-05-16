//
//  ProfileView.swift
//  HealthCareAppointmentBooking
//
//  Created by Snehasis Sahoo on 17/5/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            GradientBackground() // Set background here

            VStack {
                Spacer()
                if let user = loginViewModel.currentUser {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Username: \(user.userName ?? "Unknown")")
                            .font(.headline)
                        Text("Email: \(user.emailID ?? "Unknown")")
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                    Spacer()

                    VStack(spacing: 16) {
                        Button(action: logout) {
                            Text("Logout")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)

                        Button(action: deleteAccount) {
                            Text("Delete Account")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No user is logged in.")
                        .foregroundColor(.red)
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Profile")
            .padding()
        }
        .edgesIgnoringSafeArea(.all) // Ensure the background covers the entire screen
    }

    private func logout() {
        loginViewModel.isAuthenticated = false
        loginViewModel.currentUser = nil
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteAccount() {
        if let user = loginViewModel.currentUser {
            let context = loginViewModel.healthCareDataViewModel.container.viewContext
            context.delete(user)
            do {
                try context.save()
                logout()
            } catch {
                print("Failed to delete account: \(error.localizedDescription)")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let loginViewModel = LoginViewModel(healthCareDataViewModel: HealthCareDataViewModel())
        loginViewModel.isAuthenticated = true
        let user = UserEntity(context: loginViewModel.healthCareDataViewModel.container.viewContext)
        user.userName = "TestUser"
        user.emailID = "testuser@example.com"
        loginViewModel.currentUser = user
        
        return NavigationView {
            ProfileView()
                .environmentObject(loginViewModel)
        }
    }
}

