/**
 * ReachabilityService.swift
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import RxSwift
import RxCocoa
import Foundation

public enum ReachabilityStatus {
    case reachable(viaWiFi: Bool)
    case unreachable
}

extension ReachabilityStatus {
    var reachable: Bool {
        switch self {
        case .reachable:
            return true
        case .unreachable:
            return false
        }
    }
}

public protocol ReachabilityService {
    var reachability: Observable<ReachabilityStatus> { get }
}

public class DefaultReachabilityService: ReachabilityService {

    private let _reachabilitySubject: BehaviorSubject<ReachabilityStatus>

    public var reachability: Observable<ReachabilityStatus> {
        return _reachabilitySubject.asObservable()
    }

    let _reachability: Reachability

    public init?(){
        guard let reachabilityRef = Reachability() else{
            return nil
        }
        let reachabilitySubject = BehaviorSubject<ReachabilityStatus>(value: .unreachable)

        // so main thread isn't blocked when reachability via WiFi is checked
        let backgroundQueue = DispatchQueue(label: "reachability.wificheck")

        reachabilityRef.whenReachable = { reachability in
            backgroundQueue.async {
                reachabilitySubject.on(.next(.reachable(viaWiFi: reachabilityRef.isReachableViaWiFi)))
            }
        }

        reachabilityRef.whenUnreachable = { reachability in
            backgroundQueue.async {
                reachabilitySubject.on(.next(.unreachable))
            }
        }

        try! reachabilityRef.startNotifier()
        _reachability = reachabilityRef
        _reachabilitySubject = reachabilitySubject
    }

    deinit {
        _reachability.stopNotifier()
    }
}

extension ObservableConvertibleType {
    func retryOnBecomesReachable(_ valueOnFailure: E, reachabilityService: ReachabilityService) -> Observable<E> {
        return self.asObservable()
                .catchError { (e) -> Observable<E> in
                    reachabilityService.reachability
                            .filter {
                                $0.reachable
                            }
                            .flatMap { _ in
                                Observable.error(e)
                            }
                            .startWith(valueOnFailure)
                }
                .retry()
    }
}
