//
//  MessageController.swift
//  BulletinBoard
//
//  Created by Dustin Koch on 6/3/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    
    //Singleton
    static let sharedInstance = MessageController()
    
    //Sourrce of truth
    var messages: [Message] = []
    
    //Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD functions
    
    //create
    func createMessageWith(text: String, timeStamp: Date) {
        let message  = Message(text: text, timeStamp: timeStamp)
        self.saveMessage(message: message) { (_) in
            print("Error creating message 🍎")
        }
    }
    //remove
    func removeMessage(message: Message, completion: @escaping (Bool) -> ()) {
        //remove local
        guard let index = MessageController.sharedInstance.messages.firstIndex(of: message) else { return }
        MessageController.sharedInstance.messages.remove(at: index)
        //remove from cloud
        privateDB.delete(withRecordID: message.ckRecordId) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                print("Message deleted!")
                completion(true)
            }
        }
    }
    //update
    
    
    //save data
    func saveMessage(message: Message, completion: @escaping (Bool) -> ()) {
        let messageRecord = CKRecord(message: message)
        privateDB.save(messageRecord) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let record = record,
                let message = Message(ckRecord: record) else { completion(false); return }
            self.messages.append(message)
            completion(true)
        }
    }
    //load data
    func fetchMessages(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.recordKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let records = records else { completion(false); return }
            let messages = records.compactMap({Message(ckRecord: $0)})
            self.messages = messages
            completion(true)
        }
    }
    
    //SUBSCRIBE TO NOTIFICATIONS
    func subscribeToNotifications(completion: @escaping (Error?) -> Void ) {
        //Configuring what type of subscription desired
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: Constants.recordKey, predicate: predicate, options: .firesOnRecordCreation)
        //Setting up subscription info
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "New post! Would you look at that?!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        
        privateDB.save(subscription) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
}//END OF MESSAGE CONTROLLER
