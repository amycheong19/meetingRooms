//
//  MeetingRoomsListViewController.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 12/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class MeetingRoomsListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let dataSource = RxTableViewSectionedReloadDataSource<MeetingRoomsListBaseSection>()
    let viewModel = MeetingRoomListViewModel()
    let disposeBag = DisposeBag()
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureList()
        databaseManager.configure(.meetings)
        databaseManager.configure(.meetingRooms)
    }
    
    func configureTableView(){
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
//        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.dataSource = nil
        tableView.delegate = self
    }
    

    func configureList(){

        //Link dataSource to tableView
        Observable.just(viewModel.rooms.value)
                  .bindTo(tableView.rx.items(dataSource: dataSource))
                  .addDisposableTo(disposeBag)
        
        //
        dataSource.configureCell = {
            dataSource, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.meetingRoomListTableViewCell)!
            var morning = false
            var noon = false
            var evening = false
            
            _ = item.meetings.map{
                switch $0.session {
                    case .morning: morning = true
                    case .afternoon: noon = true
                    case .evening: evening = true
                }
            }
            cell.set(title: item.meetingRoom.title, morning: morning, noon: noon, evening: evening)
            
            return cell
        }
        
        
        //Set tableview section header
        dataSource.titleForHeaderInSection = {
            dataSource, index in
            return dataSource.sectionModels[index].header
        }

        
        let ref = FIRDatabase.database().reference()
        //Listen when child is added
        ref.child("meetings").observe(.value) { (snapshot: FIRDataSnapshot) in
            print(snapshot.value)
        }
        
        let post = ["uid": "1234",
                    "author": "2222",
                    "title": "wewew",
                    "body": "qwqwqw"]
        ref.child("users").childByAutoId().setValue(post)
        
        //Selected
//        tableView.rx.modelSelected(MeetingRoomsListBaseSection.self).subscribe(onNext:{
//            [weak self] item in
//            
//        }).addDisposableTo(disposeBag)
    }
    
    deinit {
        databaseManager.deinit(.meetings)
        databaseManager.deinit(.meetingRooms)
    }
}
