//
//  SignUpViewModel.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 12/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//
import RxSwift
import RxCocoa

struct SignUpViewModel {
    
    let validatedEmail: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedRepeatedPassword: Driver<ValidationResult>
    
    // Is submit button enabled
    let submitEnabled: Driver<Bool>
    
    let authResponse: Driver<APIResponseResult>
    
    init(
        input: (
            email: Driver<String>,
            password: Driver<String>,
            repeatedPassword: Driver<String>,
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
        
        validatedRepeatedPassword = Driver.combineLatest(input.password, input.repeatedPassword){
            password, repeatedPassword in
            return validationService.validateRepeatedPassword(password, repeatedPassword: repeatedPassword)
        }
        
        
        let emailAndPassword = Driver.combineLatest(input.email, input.password) {
            return ($0, $1)
        }
        
        submitEnabled = Driver.combineLatest(validatedEmail, validatedPassword, validatedRepeatedPassword, resultSelector: { email, password, repeatedPassword in
            return email.isValid && password.isValid && repeatedPassword.isValid
        }).distinctUntilChanged()
        
        
        authResponse = input.submitTaps.withLatestFrom(emailAndPassword).asObservable()
            .flatMapLatest{ (email, password) in
                return API.createAccount(email, password) //Observable<APIResponseResult>
            }.asDriver(onErrorJustReturn: APIResponseResult.failure(nil))
        
    }
    
    
}
