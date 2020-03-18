//
//  MoyaBase.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 18/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation
import Moya
class MoyaBase {
    static func createMoyaProvider<T: TargetType>(target: T, type: EndpointSampleResponse) -> MoyaProvider<T> {
        let serverErrorEndpointClosure = { (target: T) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { type },
                          method: target.method,
                          task: target.task,
                          httpHeaderFields: target.headers)
        }
        
        let serverErrorProvider = MoyaProvider<T>(endpointClosure: serverErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        return serverErrorProvider
    }
    
        static func createSuccessMoyaProvider<T: TargetType>(target: T) -> MoyaProvider<T> {
            let serverErrorEndpointClosure = { (target: T) -> Endpoint in
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                              method: target.method,
                              task: target.task,
                              httpHeaderFields: target.headers)
            }
            
            let serverErrorProvider = MoyaProvider<T>(endpointClosure: serverErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
            return serverErrorProvider
        }
    
}
