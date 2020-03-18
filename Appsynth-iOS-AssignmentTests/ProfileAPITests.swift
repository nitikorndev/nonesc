//
//  ProfileAPITests.swift
//  Appsynth-iOS-AssignmentTests
//
//  Created by Sujin Chaichanamongkol on 18/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import RxCocoa
import Moya
@testable import Appsynth_iOS_Assignment

class ProfileAPITests: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    override func setUp() {
        
    }
    
    override class func tearDown() {
        
    }
    
    func testGetProfileSuccess() {
        let expectation = self.expectation(description: "")
        let profileAPI = ProfileAPI(provider: MoyaBase.createMoyaProvider(target: .getProfile, type: EndpointSampleResponse.networkResponse(200, ProfileAPIType.getProfile.sampleData)))
        
        profileAPI
            .getProfile()
            .subscribe(onNext: { (user) in
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetProfileFailConnection() {
        let expectation = self.expectation(description: "")
        let profileAPI = ProfileAPI(provider: MoyaBase.createMoyaProvider(target: .getProfile, type: EndpointSampleResponse.networkError(NSError())))
        
        profileAPI
            .getProfile()
            .subscribe(onNext: { (user) in
                XCTFail()
            }, onError: { (error) in
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetProfileFailMapping() {
        let expectation = self.expectation(description: "")
        let profileAPI = ProfileAPI(provider: MoyaBase.createMoyaProvider(target: .getProfile, type: EndpointSampleResponse.networkResponse(200, Data())))
        
        profileAPI
            .getProfile()
            .subscribe(onNext: { (user) in
                XCTFail()
            }, onError: { (error) in
                if let _error = error as? MoyaError {
                    switch _error {
                    case .jsonMapping:
                        expectation.fulfill()
                    default:
                        XCTFail()
                    }
                }
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetNotificationSuccess() {
        let expectation = self.expectation(description: "")
        let profileAPI = ProfileAPI(provider: MoyaBase.createMoyaProvider(target: .getNotificationList(userID: ""), type: EndpointSampleResponse.networkResponse(200, ProfileAPIType.getNotificationList(userID: "").sampleData)))
        
        profileAPI
        .getNotificationList(userID: "")
            .subscribe(onNext: { (user) in
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetNotificationFailConnection() {
        let expectation = self.expectation(description: "")
        let profileAPI = ProfileAPI(provider: MoyaBase.createMoyaProvider(target: .getNotificationList(userID: ""), type: EndpointSampleResponse.networkError(NSError())))
        
        profileAPI
        .getNotificationList(userID: "")
            .subscribe(onNext: { (user) in
                XCTFail()
            }, onError: { (error) in
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testGetNotificationFailMapping() {
        let expectation = self.expectation(description: "")
        let profileAPI = ProfileAPI(provider: MoyaBase.createMoyaProvider(target: .getNotificationList(userID: ""), type: EndpointSampleResponse.networkResponse(200, Data())))
           
           profileAPI
               .getNotificationList(userID: "")
               .subscribe(onNext: { (user) in
                   XCTFail()
               }, onError: { (error) in
                   if let _error = error as? MoyaError {
                       switch _error {
                       case .jsonMapping:
                           expectation.fulfill()
                       default:
                           XCTFail()
                       }
                   }
               }).disposed(by: disposeBag)
           
           waitForExpectations(timeout: 5, handler: nil)
       }
}
