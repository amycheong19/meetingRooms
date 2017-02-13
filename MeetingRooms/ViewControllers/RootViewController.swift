//
//  ViewController.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 11/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UserNotifications

enum RootTab {
    case dashboard
    case meetingRoomList
    case settings
    
    var title: String {
        switch self {
            case .dashboard : return "Dashboard"
            case .meetingRoomList : return "Rooms"
            case .settings : return "Setting"
        }
    }
    
    var icon: UIImage {
        return #imageLiteral(resourceName: "settings_active")
    }
    
    var selected_icon: UIImage {
        return #imageLiteral(resourceName: "settings_active")
    }
    
    var controller: UINavigationController {
        switch self {
        case .meetingRoomList:
            return R.storyboard.meetingRoomsListStoryboard().instantiateInitialViewController() as! UINavigationController
        case .dashboard:
            return R.storyboard.dashboardStoryboard().instantiateInitialViewController() as! UINavigationController
        case .settings:
            return R.storyboard.settingsStoryboard().instantiateInitialViewController() as! UINavigationController

        }
    }
    
    var index: Int {
        switch self {
        case .dashboard: return 0
        case .meetingRoomList: return 1
        case .settings: return 2
        
        }
    }
    
    static let tabItems: [RootTab] = [.dashboard, .meetingRoomList,.settings]
    
}

class RootViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    func setupTabs(){
        viewControllers = RootTab.tabItems.map {
            let controller = $0.controller
            controller.tabBarItem = RootTabBarItem(tab: $0)
            return controller
        }
    }

}

class RootTabBarItem: UITabBarItem {
    
    let disposeBag = DisposeBag()
    
    let tab: RootTab
    
    init(tab: RootTab) {
        self.tab = tab
        super.init()
        
        title = tab.title
        image = tab.icon
        selectedImage = tab.selected_icon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText() {
        title = tab.title
    }
    
}

