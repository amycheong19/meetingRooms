//
//  DatabaseManager.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 13/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabaseUI

class DatabaseManager {
    static let `default` = DatabaseManager()
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    init() {
        configureDatabase()
    }
    
    func configureDatabase(){
        
        //Listen when child is added
        ref.child("messages").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
//            self.messages.append(snapshot)
//            self.messagesTable.insertRows(at:[ IndexPath(row: self.messages.count - 1 , section: 0)], with: .automatic)
//            self.scrollToBottomMessage()
        }
    }
    
    deinit {
        
    }
    
    func set(newValue: String, on path: String){
        ref.child(path).setValue(newValue)
    }
}
