//
//  LoginViewController.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 11/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!

@IBOutlet weak var emailTextField: UITextField!
@IBOutlet weak var emailValidationOutlet: UILabel!

@IBOutlet weak var passwordTextField: UITextField!
@IBOutlet weak var passwordValidationOutlet: UILabel!

@IBOutlet var loginButton: UIButton!
    
var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = LoginViewModel(
            input: (
                email: emailTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                submitTaps: loginButton.rx.tap.asDriver()
            ),
            dependency: (
                API: AuthAPI.sharedAPI,
                validationService: AuthValidationService.sharedValidationService
            )
        )
        
        //bindResults:
        viewModel.submitEnabled.drive(onNext: { [weak self] (valid: Bool) in
            self?.loginButton.isEnabled = valid
            self?.loginButton.alpha = valid ? 1.0 : 0.5
        }).addDisposableTo(disposeBag)
        
        viewModel.validatedEmail.debounce(0.5).drive(emailValidationOutlet.rx.validationResult).addDisposableTo(disposeBag)
        
        viewModel.validatedPassword.debounce(0.5).drive(passwordValidationOutlet.rx.validationResult).addDisposableTo(disposeBag)
        
        
        
        viewModel.authResponse.subscribe(onNext: { (result) in
                //REDIRECT
            
            }, onError: { error in
                DefaultWireframe.presentAlert("Error", error.localizedDescription)
            }).addDisposableTo(disposeBag)
        
    }
    
    
//    func configureAuth(){
//        // listen for changes in the authorization state
//        _authHandle = FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
//
//            // check if there is a current user
//            if let activeUser = user {
//                // check if the current app user is the current FIRUser
//                print("check if the current app user is the current FIRUser")
//            } else {
//                // user must sign in
//                print("user must sign in")
//            }
//        }
//
//    }
    
    
    
}

