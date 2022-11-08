//
//  ViewController.swift
//  Project21
//
//  Created by MTMAC51 on 07/11/22.
//

import UserNotifications
import UIKit


class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var timeInterval: Double = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }


    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("ok")
            } else {
                print("not ok")
            }
        }
    }
    
    @objc func scheduleLocal(){
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        
        let content = UNMutableNotificationContent()
        content.title = "Ini title message"
        content.body = "Ini  body message"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "theId"]
        content.sound = .default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Beritahu aku", options: .foreground)
        let remindLater = UNNotificationAction(identifier: "remindLater", title: "Remind Later", options: .authenticationRequired)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,remindLater], intentIdentifiers: [], options: [])

        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("customdata is \(customData)")
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                //user swiped to unlock
                print("default identifier")
                title = "Default Identifier"
            case "show":
                title = "Show more information clicked"
            case "remindLater":
                title = "User clicked remind me later"
                timeInterval = 86400
                scheduleLocal()
            default:
                break
            }
            
            let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
        
        completionHandler()
    }
}

