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
    @Published var isNewUser: Bool = false // Added property for indicating if the user is new
    @Published var errorMessage: String?

    // Initializing with an instance of HealthCareDataViewModel
    init(healthCareDataViewModel: HealthCareDataViewModel) {
        self.healthCareDataViewModel = healthCareDataViewModel
    }

    // Function to authenticate user
    func authenticateUser(username: String, password: String) -> Bool {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userName == %@", username)
        
        do {
            let users = try healthCareDataViewModel.container.viewContext.fetch(request)
            print(users)
            if users.isEmpty {
                // Username not found, indicating a new user
                isAuthenticated = false
                isNewUser = true
                return false
            } else if let user = users.first, user.password == password {
                // Username found and password matches
                isAuthenticated = true
                isNewUser = false
                return true
            } else {
                // Username found but password does not match
                isAuthenticated = false
                isNewUser = false
                return false
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            isAuthenticated = false
            isNewUser = false
            return false
        }
    }

    // Function to create a new user
    func createUser(username: String, password: String, email: String) {
        let newUser = UserEntity(context: healthCareDataViewModel.container.viewContext)
        newUser.userID = UUID()
        newUser.userName = username
        newUser.password = password
        newUser.emailID = email
        
        do {
            try healthCareDataViewModel.container.viewContext.save()
            print("User created successfully!")
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
}

