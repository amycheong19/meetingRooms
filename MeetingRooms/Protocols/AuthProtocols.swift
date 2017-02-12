//
//  AuthProtocols.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 12/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//
import RxSwift
import RxCocoa
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

//MARK: - Authentication Response
public enum APIResponseResult: Error {
    case success
    case failure(Error?)
}

public enum ValidationResult {
    case ok(message: String)
    case empty(message: String)
    case failed(message: String)
    
    public var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

//MARK: - Authentication Validation Service
public protocol ValidationService {
    func validateEmail(_ email: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}


public class AuthValidationService : ValidationService {
    let API: AuthAPI
    
    static let sharedValidationService = AuthValidationService(API: AuthAPI.sharedAPI)
    
    init (API: AuthAPI) {
        self.API = API
    }
    
    // validation
    public func validateEmail(_ email: String) -> ValidationResult {
        let numberOfCharacters = email.characters.count
        if numberOfCharacters == 0 {
            return .empty(message: "Empty email")
        }
        
        if !email.isValidEmail() {
            return .failed(message: "Invalid email")
        }
        return .ok(message: "")
    }
    
    public func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.characters.count
        
        switch numberOfCharacters {
        case 0:
            return .empty(message: "Empty password")
        case 1..<6:
            return .failed(message: "Invalid password")
        default:
            return .ok(message: "")
        }
        
    }
    
    public func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        
        guard !password.isEmpty && !repeatedPassword.isEmpty else {
            return .failed(message: "")
        }
        
        if repeatedPassword == password {
            return .ok(message: "Looks good!")
        } else {
            return .failed(message: "Password not match")
        }
    }
}


//MARK: - Firebase Authentication APIs
public class AuthAPI {
    let URLSession: Foundation.URLSession
    
    static let sharedAPI = AuthAPI(
        URLSession: Foundation.URLSession.shared
    )
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    public func login(_ email: String, _ password: String) -> Observable<APIResponseResult> {

        return Observable.create { observer -> Disposable in
            
            let completion : (FIRUser?, Error?) -> Void =  {  (user, error) in
                
                if let error = error {
                    UserSession.default.clearSession()
                    observer.onError(APIResponseResult.failure(error))
                }
                
                if let user = user {
                    UserSession.default.user.value = user
                    observer.onNext(APIResponseResult.success)
                    observer.on(.completed)
                }
            }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: completion)
            
            return Disposables.create()
        }
        
        
    }
    
    func createAccount(_ email: String, _ password: String) -> Observable<APIResponseResult> {
        let observable = Observable<APIResponseResult>.create { observer -> Disposable in
            
            let completion : (FIRUser?, Error?) -> Void =  {  (user, error) in
                
                if let error = error {
                    UserSession.default.clearSession()
                    observer.onError(APIResponseResult.failure(error))
                    return
                }
                
                UserSession.default.user.value = user!
                observer.onNext(APIResponseResult.success)
                observer.on(.completed)
                return
            }
            
            
            
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: completion)
            
            observer.on(.completed)
            return Disposables.create()
        }
        
        return observable
        
        //        return observable.delay(3.0, scheduler: MainScheduler.instance)
        //
        //        // this is also just a mock
        //        let signupResult = arc4random() % 5 == 0 ? false : true
        //
        //        return Observable.just(signupResult)
        //            .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    
    func resetPassword(with email: String) -> Observable<APIResponseResult> {
        let observable = Observable<APIResponseResult>.create { observer -> Disposable in
            
            let completion : (Error?) -> Void =  {  (error) in
                
                if let error = error {
                    UserSession.default.clearSession()
                    observer.onError(APIResponseResult.failure(error))
                    observer.on(.completed)
                    return
                }
                
                observer.onNext(APIResponseResult.success)
                observer.on(.completed)
                return
            }
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: completion)
            
            observer.on(.completed)
            return Disposables.create()
        }
        
        return observable

    }
 }

