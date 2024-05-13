//
//  AppointmentViewModel.swift
//  HealthCareAppointmentBooking
//
//  Created by Kajal Maskar on 13/5/2024.
//

import Foundation
import CoreData

class AppointmentViewModel: ObservableObject {
    
    let healthCareDataViewModel: HealthCareDataViewModel
    let doctorSearchViewModel: DoctorSearchViewModel
    
    @Published var appointments: [Appointment] = []
    @Published var errorMessage: String?

    // Initializing with an instance of HealthCareDataViewModel
    init(healthCareDataViewModel: HealthCareDataViewModel, doctorSearchViewModel: DoctorSearchViewModel) {
        self.healthCareDataViewModel = healthCareDataViewModel
        self.doctorSearchViewModel = doctorSearchViewModel
    }

    // Function to book appointment
    func bookAppointment(patientName: String, clinicAddress: String, date: Date, doctorName: String, age: Int16, gender: String) {
        // Create AppointmentEntity and save it to CoreData
        let context = healthCareDataViewModel.container.viewContext
        let newAppointment = AppointmentEntity(context: context)
        
        // Generate a unique ID
        let appointmentID = UUID()
        
        newAppointment.appointmentID = appointmentID // Assign the unique ID
        newAppointment.patientName = patientName
        newAppointment.clinicAddress = clinicAddress
        newAppointment.date = date
        newAppointment.doctorName = doctorName
        newAppointment.age = age
        newAppointment.gender = gender

        do {
            try context.save()
            fetchAppointments() // Refresh appointments after booking
        } catch {
            errorMessage = "Failed to book appointment."
        }
    }

    // Function to delete appointment
    func deleteAppointment(id: UUID) {
        let context = healthCareDataViewModel.container.viewContext
        let request: NSFetchRequest<AppointmentEntity> = AppointmentEntity.fetchRequest()
        request.predicate = NSPredicate(format: "appointmentID == %@", id as CVarArg)
        
        do {
            if let appointmentEntity = try context.fetch(request).first {
                context.delete(appointmentEntity)
                try context.save()
                fetchAppointments() // Refresh appointments after deletion
            }
        } catch {
            errorMessage = "Failed to delete appointment: \(error.localizedDescription)"
        }
    }

    // Function to fetch appointments
    func fetchAppointments() {
        let request: NSFetchRequest<AppointmentEntity> = AppointmentEntity.fetchRequest()
        do {
            // Fetch appointments from Core Data
            let appointmentsFromCoreData = try healthCareDataViewModel.container.viewContext.fetch(request)
            // Convert fetched AppointmentEntity objects to Appointment objects
            appointments = appointmentsFromCoreData.compactMap { appointmentEntity in
                if let id = appointmentEntity.appointmentID {
                    let appointment = Appointment(id: id, patientName: appointmentEntity.patientName ?? "", date: appointmentEntity.date ?? Date(), clinicAddress: appointmentEntity.clinicAddress ?? "", gender: appointmentEntity.gender ?? "", age: appointmentEntity.age ?? Int16(), doctorName: appointmentEntity.doctorName ?? "")
                   // print("Fetched Appointment: \(appointment)")
                    return appointment
                }
                // Handle error case where conversion fails
                return nil
            }
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch appointments: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error occurred while fetching appointments")
        }
    }
}

