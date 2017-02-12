//
//  SignUpViewController.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 12/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatedPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = SignUpViewModel(input:
            (
                email: emailTextField.rx.text.orEmpty.asDriver() ,
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordTextField.rx.text.orEmpty.asDriver(),
                submitTaps: signUpButton.rx.tap.asDriver())
            ,
            dependency: (API: AuthAPI.sharedAPI, validationService: AuthValidationService.sharedValidationService))
        
        //Binding
        viewModel.submitEnabled.drive(onNext: { [weak self] (valid: Bool) in
            self?.signUpButton.isEnabled = valid
            self?.signUpButton.alpha = valid ? 1.0 : 0.5
        }).addDisposableTo(disposeBag)
        
        viewModel.validatedEmail.debounce(0.5).drive(emailLabel.rx.validationResult).addDisposableTo(disposeBag)
        
        viewModel.validatedPassword.debounce(0.5).drive(passwordLabel.rx.validationResult).addDisposableTo(disposeBag)
        
        viewModel.validatedRepeatedPassword.debounce(0.5).drive(passwordLabel.rx.validationResult).addDisposableTo(disposeBag)

        viewModel.authResponse.drive(onNext: { (result) in
            switch result {
            case .Failure(let error):
                print("Error: \(error)")
                if (error != nil) {
                    DefaultWireframe.presentAlert("Error", error?.localizedDescription ?? "Error")
                }
            case .Success:
                print("REDIRECT")
                break
            }
            
        }).addDisposableTo(disposeBag)

    }


}
