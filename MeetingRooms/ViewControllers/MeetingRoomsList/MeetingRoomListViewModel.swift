//
//  MeetingRoomListModel.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 15/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Firebase
import FirebaseDatabaseUI
import SwiftDate

//MAR: Section
struct MeetingRoomsListBaseSection {
    var header: String
    var items: [MeetingRoomBooking]
}

extension MeetingRoomsListBaseSection: SectionModelType {
    typealias Item = MeetingRoomBooking
    
    var identity: String {
        return header
    }
    
    init(original: MeetingRoomsListBaseSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct MeetingRoomBooking {
    var meetingRoom: MeetingRoom
    var meetings: [Meeting]
}




class MeetingRoomListViewModel{
    //Meeting Rooms bookings
    let rooms = Variable<[MeetingRoomsListBaseSection]>([])
    
    let meetings = Variable<[Meeting]>(
        [Meeting(title: "Morning meeting A", date: Date(), session: .morning, meetingRoomId: 1, personInChargeId: 1),
         Meeting(title: "Morning meeting B", date: Date(), session: .afternoon, meetingRoomId: 2, personInChargeId: 1),
         Meeting(title: "Morning meeting C", date: Date(), session: .evening, meetingRoomId: 1, personInChargeId: 1)]
    )
    
    
    let meetingRooms = Variable<[MeetingRoom]>(
        [MeetingRoom(id: 1, title: "Tiger Den", description: "desc", capacity: 20),
         MeetingRoom(id: 2, title: "Lion Den", description: "desc", capacity: 20),
         MeetingRoom(id: 3, title: "Sheep Den", description: "desc", capacity: 10)]
    )
    
    //Rx
    let disposeBag = DisposeBag()
    
    init() {
        
        //Combine meetings with meetingRooms
        Observable.combineLatest(meetings.asObservable(), meetingRooms.asObservable()) {
            (meetings, meetingRooms) -> ([Meeting], [MeetingRoom])in
            return (meetings, meetingRooms)
        }.subscribe ( onNext: { [weak self] (meetings, meetingRooms) in
                
                let todayMeetings = meetings.filter{
                    
                    return $0.date.isToday 
                }
                
                let meetingRoomBookings = meetingRooms.map{ room -> MeetingRoomBooking in
                    let mr = todayMeetings.filter{ $0.meetingRoomId == room.id }
                    return MeetingRoomBooking(meetingRoom: room , meetings: mr)
                }
            
                self?.rooms.value = [MeetingRoomsListBaseSection(header: "", items: meetingRoomBookings)]
                
            }).addDisposableTo(disposeBag)
    }
    
}

