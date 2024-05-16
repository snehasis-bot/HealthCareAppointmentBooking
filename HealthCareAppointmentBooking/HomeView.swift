//
//  HomeView.swift
//  HealthCareAppointmentBooking
//
//  Created by Pravin Jadhav on 13/5/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground() // Apply gradient background
                
                VStack {
                    Spacer() // Add spacer at the top to push content down

                    VStack {
                        Text("EasyAppoint")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("Your Gateway to Easy HealthCare Appointment Booking")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        // Button to navigate to DoctorSearchView
                        NavigationLink(destination: DoctorSearchView(appointmentViewModel: AppointmentViewModel(healthCareDataViewModel: HealthCareDataViewModel(), doctorSearchViewModel: DoctorSearchViewModel()))) {
                            Text("Find Practitioner")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        
                        HStack {
                            Text("Haven't Logged In yet?").foregroundColor(.gray)
                            NavigationLink(destination: LoginView()) {
                                Text("Log In").padding().foregroundColor(.black)
                            }
                        }
                        .padding(.bottom, 5)
                    }
                    
                    Spacer() // Add spacer at the bottom to keep the content centered
                }
                .padding(.horizontal)
            }
            .edgesIgnoringSafeArea(.all) // Ensure the background covers the entire screen
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

