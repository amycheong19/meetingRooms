//
//  String+Extension.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 12/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import Foundation

public extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
