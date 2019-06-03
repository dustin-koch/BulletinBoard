//
//  Message.swift
//  BulletinBoard
//
//  Created by Dustin Koch on 6/3/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let recordKey = "Message"
    static let textKey = "text"
    static let timestampKey = "timestamp"
}

class Message {
    var text: String
    var timeStamp: Date
    var ckRecordId: CKRecord.ID
    
    init(text: String, timeStamp: Date, ckRecordId: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timeStamp = timeStamp
        self.ckRecordId = ckRecordId
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let text = ckRecord[Constants.textKey] as? String,
        let timeStamp = ckRecord[Constants.timestampKey] as? Date else { return nil }
        
        self.init(text: text, timeStamp: timeStamp, ckRecordId: ckRecord.recordID)
    }
    
}//END OF MESSAGE CLASS

extension CKRecord {
    convenience init(message: Message) {
        self.init(recordType: Constants.recordKey, recordID: message.ckRecordId)
        self.setValue(message.text, forKey: Constants.textKey)
        self.setValue(message.timeStamp, forKey: Constants.timestampKey)
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.text == rhs.text && lhs.timeStamp == rhs.timeStamp && lhs.ckRecordId == rhs.ckRecordId
    }
}
