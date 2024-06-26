//
//  NotifcationView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/27/23.
//

import Foundation
import SwiftUI

// MARK: - NotificationManager

/// A singleton class to manage notifications for the app.
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    @Published var selectedMedicationId: String? // This should be String?
    
   
    
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        
        // Defining our custom actions
        let markAsTakenAction = UNNotificationAction(identifier: "MARK_AS_TAKEN", title: "Taken",options: [])
        let markAsSkippedAction = UNNotificationAction(identifier: "MARK_AS_SKIPPED", title: "Skipped", options: [])
        let markAsRemindLaterAction = UNNotificationAction(identifier: "MARK_AS_REMIND_LATER", title: "Remind me later", options: [])
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",title: "Snooze (15 mins)",options: [])
        
        // Define the notification type
        let takeMedicationCategory = UNNotificationCategory(identifier: "TAKE_MEDICATION",
                                                                        actions: [markAsTakenAction, markAsSkippedAction, markAsRemindLaterAction, snoozeAction],
                                                                        intentIdentifiers: [],
                                                                        hiddenPreviewsBodyPlaceholder: "",
                                                            options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([takeMedicationCategory])
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permissions granted.")
            } else if let error = error {
                print("Notification permissions error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(medication: Medication, at date: Date, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.userInfo = ["medicationID": medication.id.uuidString]
        content.categoryIdentifier = "TAKE_MEDICATION"
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notifcation: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        processNotification(notification)
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // processNotification(response.notification)
        
        let userInfo = response.notification.request.content.userInfo
        
        if let medicationId = userInfo["medicationID"] as? String {
            DispatchQueue.main.async {
                self.selectedMedicationId = medicationId
            }
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // Default action: ie they clicked on the notifcation body
                // desired action is to open the app and present a modal or sheet to take action  since they may not press it to see the options
                // TODO: IMPLEMENT FUNCTOIN
                break
            case "MARK_AS_TAKEN":
                // markMedicationAsTaken(medicationId: medicationId)
                break
            case "MARK_AS_SKIPPED":
                // markMedicationAsSkipped(medicationId: medicationId)
                break
            case "MARK_AS_REMIND_LATER":
                // MAY want to replace as too complicated
                // scheduleRemindLaterNotification
                break
            case "SNOOZE_ACTION":
                // scheduleFifteenMinuteLaterNotification()
                break
            default:
                break
            }
            
        }
   
    }
    
    // Call this method when the app becomes active
    func checkPendingNotification() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            if let firstNotification = notifications.first(where: { $0.request.content.userInfo["medicationId"] != nil }),
               let medicationId = firstNotification.request.content.userInfo["medicationId"] as? String {
                DispatchQueue.main.async {
                    self.selectedMedicationId = medicationId
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [firstNotification.request.identifier])
                }
            }
        }
    }
    func cancelNotifications(for medicationId: UUID) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let idsToCancel = requests.filter {
                $0.content.userInfo["medicationId"] as? String == medicationId.uuidString
            }.map { $0.identifier }
            
            center.removePendingNotificationRequests(withIdentifiers: idsToCancel)
        }
    }
    private func processNotification(_ notification: UNNotification) {
        if let medicationID = notification.request.content.userInfo["medicationId"] as? String {
            DispatchQueue.main.async {
                self.selectedMedicationId = medicationID
            }
        }
    }
}

extension NotificationManager {
    func scheduleNotificationsForMedication(_ medication: Medication) {
        var date = medication.startDate
        while date <= medication.endDate {
            if medication.daysOfWeekToTake.contains(date.dayOfWeek) {
                let notificationDate = Calendar.current.date(bySettingHour: medication.timeToTake.hour, minute: medication.timeToTake.minute, second: 0, of: date)!
                scheduleNotification(medication: medication, at: notificationDate, title: "Time to take your \(medication.name)", body: "Dosage: \(medication.dosage.amount) \(medication.dosage.unit)")
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
    }
}

