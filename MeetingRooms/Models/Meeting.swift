//
//  Meeting.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 14/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import Foundation

enum Session {
    case morning
    case afternoon
    case evening
}

struct Meeting {
    var title: String
//    var description : String?
    var date: Date
    var session: Session
    var meetingRoomId: Int      //Link to MeetingRoom
    var personInChargeId: Int   //UserId
    
    
}

struct MeetingRoom {
    //primary
    var id: Int
    
    var title: String
    var description : String?
    var capacity: Int
    
    init(id: Int, title: String, description: String, capacity: Int){
        self.id = id
        self.title = title
        self.description = description
        self.capacity = capacity
    }
    
}

