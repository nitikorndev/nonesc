//
//  ObservableExtension.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 18/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD
import RxCocoa
import Moya

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension Observable where Element: OptionalType {
    
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

extension ObservableType where Element: Any {
    func sendErrorTo(_ observer: PublishSubject<Error>) -> Observable<Element> {
        return self.catchError { (error) -> Observable<Self.Element> in
            observer.onNext(error)
            return Observable.empty()
        }
    }
    
//    func filterNil() -> Observable<E.Wrapped> {
//        return flatMap { (element) -> Observable<E.Wrapped> in
//            if let value = element.value {
//                return Observable.just(value)
//            } else {
//                return Observable.empty()
//            }
//        }
//    }
}

extension ObservableType where Self.Element == Moya.Response {
    
    func mapServiceObject<T: Codable>(type: T.Type) -> Observable<T> {
        return self.map { (response) -> T in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.isoFormatter)
            do {
                let object = try decoder.decode(type, from: response.data)
                return object
            } catch {
                throw MoyaError.jsonMapping(response)
            }
        }
    }
}

extension Reactive where Base: UIApplication {
    
    public var isNetworkIndicatorAnimated: Binder<Bool> {
        return Binder(self.base) { application, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
