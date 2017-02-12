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


public struct UserSession {
    public static var `default` = UserSession()
    public var user = Variable<FIRUser?>(nil)
    
    public func clearSession() {
        user.value = .none
    }
}

public enum APIResponseResult: Error {
    case Success
    case Failure(Error?)
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

public protocol ValidationService {
    func validateEmail(_ email: String) -> ValidationResult
    
    func validatePassword(_ password: String) -> ValidationResult
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
        print("OK for email")
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
            print("OK for password")
            return .ok(message: "")
        }
        
    }
}


public class AuthAPI {
    let URLSession: Foundation.URLSession
    
    static let sharedAPI = AuthAPI(
        URLSession: Foundation.URLSession.shared
    )
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    func createAccount(_ email: String, _ password: String) -> Observable<Bool> {
//        let observable = Observable<APIResponseResult>.create { observer -> Disposable in
//            
//            let completion : (FIRUser?, Error?) -> Void =  {  (user, error) in
//                
//                if let error = error {
//                    UserSession.default.clearSession()
//                    observer.onError(APIResponseResult.Failure(error))
//                    observer.on(.completed)
//                    return
//                }
//                
//                UserSession.default.user.value = user!
//                observer.onNext(APIResponseResult.Success)
//                observer.on(.completed)
//                return
//            }
//            
//            FIRAuthResultCallback
//            
//            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: completion)
//            
//            observer.on(.completed)
//            return Disposables.create()
//        }
        
        return observable.delay(3.0, scheduler: MainScheduler.instance)
        
        // this is also just a mock
        let signupResult = arc4random() % 5 == 0 ? false : true
        
        return Observable.just(signupResult)
            .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    public func login(_ email: String, _ password: String) -> Observable<APIResponseResult> {

        let observable = Observable<APIResponseResult>.create { observer -> Disposable in
            
            let completion : (FIRUser?, Error?) -> Void =  {  (user, error) in
                
                if let error = error {
                    UserSession.default.clearSession()
                    observer.onError(APIResponseResult.Failure(error))
                    observer.on(.completed)
                    return
                }
                
                UserSession.default.user.value = user!
                observer.onNext(APIResponseResult.Success)
                observer.on(.completed)
                return
            }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: completion)
            
            
            observer.on(.completed)
            return Disposables.create()
        }
        
        return observable.delay(3.0, scheduler: MainScheduler.instance)
        
    }
 }

