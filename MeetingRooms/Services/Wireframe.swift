//
//  Wireframe.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 12/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//
import RxSwift
import UIKit

enum RetryResult {
    case retry
    case cancel
}

protocol Wireframe {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}


class DefaultWireframe: Wireframe {
    static let sharedInstance = DefaultWireframe()
    
    func open(url: URL) {
        UIApplication.shared.openURL(url)
    }
    
    private static func rootViewController() -> UIViewController {
        // cheating, I know
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    static func presentAlert(_ title: String, _ message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        rootViewController().present(alertView, animated: true, completion: nil)
        
    }
    
    func promptFor<Action : CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        return Observable.create { observer in
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })
            
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }
            
            DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)
            
            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
    }
}


extension RetryResult : CustomStringConvertible {
    var description: String {
        switch self {
        case .retry:
            return "Retry"
        case .cancel:
            return "Cancel"
        }
    }
}
