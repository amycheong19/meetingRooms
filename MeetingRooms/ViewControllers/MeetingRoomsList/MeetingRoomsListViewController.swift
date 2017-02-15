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

class MeetingRoomsListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let dataSource = RxTableViewSectionedReloadDataSource<MeetingRoomsListBaseSection>()
    let viewModel = MeetingRoomListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureList()
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

        //Selected
//        tableView.rx.modelSelected(MeetingRoomsListBaseSection.self).subscribe(onNext:{
//            [weak self] item in
//            
//        }).addDisposableTo(disposeBag)
    }
}
