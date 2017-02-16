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

enum FirebaseListener {
    case meetings
    case meetingRooms
    
    var path: String {
        switch self {
            case .meetings:  return "meetings"
            case .meetingRooms: return "meetingRooms"
        }
    }
}

struct DatabaseManager {
    static let `default` = DatabaseManager()
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    fileprivate var _refHandle: FIRDatabaseHandle!

    //Listen when child is added
    func configure(_ listener: FirebaseListener){
        
        switch listener {
        case .meetings:
            ref.child("meetings").observe(.value) { (snapshot: FIRDataSnapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                print(postDict)
                
            }
            
            ref.child("meetings").observeSingleEvent(of: .value, with: { (snapshot) in
                print("Inside block")
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                print(postDict)
            })
        case .meetingRooms:
            ref.child("meetingRooms").observe(.value) { (snapshot: FIRDataSnapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                print(postDict)
                
            }
        }
    }

    
    func set(newValue: String, on path: String){
        ref.child(path).setValue(newValue)
    }
    
    //Listen when child is added
    func `deinit`(_ listener: FirebaseListener){
        ref.child(listener.path).removeObserver(withHandle: _refHandle)
    }
}
