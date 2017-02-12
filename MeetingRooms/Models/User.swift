//
//  User.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 13/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//
import RxSwift
import RxCocoa
import Firebase


public struct UserSession {
    public static var `default` = UserSession()
    public var user = Variable<FIRUser?>(nil)
    
    public func clearSession() {
        user.value = .none
    }
}
