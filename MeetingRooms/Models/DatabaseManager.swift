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

struct DatabaseManager {
    static let `default` = DatabaseManager()
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    func configureDatabase(){

    }
}
