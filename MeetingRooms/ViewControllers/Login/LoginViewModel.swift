//
//  LoginViewModel.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 11/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import RxSwift
import RxCocoa


struct LoginViewModel {
    
    let validatedEmail: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    
    // Is submit button enabled
    let submitEnabled: Driver<Bool>
    
    let authResponse: Driver<APIResponseResult>
    
    init(
        input: (
            email: Driver<String>,
            password: Driver<String>,
            submitTaps: Driver<Void>
        ),
        dependency: (
            API: AuthAPI,
            validationService: AuthValidationService
        )
    ) {
        
        let API = dependency.API
        let validationService = dependency.validationService
        
        
        validatedEmail = input.email
            .map { email in
                return validationService.validateEmail(email)
        }
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
        }
        

        let emailAndPassword = Driver.combineLatest(input.email, input.password) {
            return ($0, $1)
        }

        submitEnabled = Driver.combineLatest(validatedEmail, validatedPassword, resultSelector: { email, password in
            return email.isValid && password.isValid
        }).distinctUntilChanged()
        
        
        authResponse = input.submitTaps.withLatestFrom(emailAndPassword).asObservable()
                            .flatMapLatest{ (email, password) in
                            return API.login(email, password) //Observable<APIResponseResult>
        }.asDriver(onErrorJustReturn: APIResponseResult.failure(nil))
 
    }
    
    
}
