//
//  LoginViewModel.swift
//  HealthCareAppointmentBooking
//
//  Created by Pravin Jadhav on 15/5/2024.
//

import Foundation
import CoreData

class LoginViewModel: ObservableObject {
    let healthCareDataViewModel: HealthCareDataViewModel
    
    @Published var isAuthenticated: Bool = false
    @Published var isNewUser: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: UserEntity?

    init(healthCareDataViewModel: HealthCareDataViewModel) {
        self.healthCareDataViewModel = healthCareDataViewModel
    }

    func authenticateUser(username: String, password: String) -> Bool {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userName == %@", username)
        
        do {
            let users = try healthCareDataViewModel.container.viewContext.fetch(request)
            if users.isEmpty {
                // Username not found, indicating a new user
                isAuthenticated = false
                isNewUser = true
                errorMessage = "User does not exist. Please enter the correct username or create an account."
                return false
            } else if let user = users.first, user.password == password {
                // Username found and password matches
                isAuthenticated = true
                isNewUser = false
                currentUser = user  // Set the current user
                errorMessage = nil
                return true
            } else {
                // Username found but password does not match
                isAuthenticated = false
                isNewUser = false
                errorMessage = "Invalid password"
                return false
            }
        } catch {
            isAuthenticated = false
            isNewUser = false
            errorMessage = "An error occurred while fetching user data: \(error.localizedDescription)"
            return false
        }
    }

    func createUser(username: String, password: String, email: String) {
        let newUser = UserEntity(context: healthCareDataViewModel.container.viewContext)
        newUser.userID = UUID()
        newUser.userName = username
        newUser.password = password
        newUser.emailID = email
        
        do {
            try healthCareDataViewModel.container.viewContext.save()
            currentUser = newUser  // Set the current user after creation
            print("User created successfully!")
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
}


