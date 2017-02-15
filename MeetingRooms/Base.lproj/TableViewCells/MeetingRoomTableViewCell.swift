//
//  MeetingRoomTableViewCell.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 15/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import UIKit

class MeetingRoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var eveningLabel: UILabel!
    @IBOutlet weak var noonLabel: UILabel!
    @IBOutlet weak var morningLabel: UILabel!
    //TODO: populate time
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(title: String, morning: Bool, noon: Bool, evening: Bool) {
        self.title.text = title
        self.morningLabel.textColor = !morning ? #colorLiteral(red: 0.1187036559, green: 0.1203067675, blue: 0.1623261273, alpha: 1) : #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        self.noonLabel.textColor = !noon ? #colorLiteral(red: 0.1187036559, green: 0.1203067675, blue: 0.1623261273, alpha: 1) : #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        self.eveningLabel.textColor = !evening ? #colorLiteral(red: 0.1187036559, green: 0.1203067675, blue: 0.1623261273, alpha: 1) : #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)

    }

}
