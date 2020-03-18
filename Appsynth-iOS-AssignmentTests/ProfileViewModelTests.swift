//
//  ProfileViewModelTests.swift
//  Appsynth-iOS-AssignmentTests
//
//  Created by Sujin Chaichanamongkol on 18/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import Appsynth_iOS_Assignment

extension ProfileViewModelTests {
    class ProfileAPIMock: ProfileAPIProtocol {
        
        var userProfile: UserProfileObject = UserProfileObject()
        var isError: Bool
    
        init(isError: Bool) {
            self.isError = isError
        }
        func getProfile() -> Observable<UserProfileObject> {
            if isError {
                return .error(NSError())
            }
            return .just(userProfile)
        }
        
        func getNotificationList(userID: String) -> Observable<[NotificationObject]> {
            if isError {
                return .error(NSError())
            }
            let notifications = Array.init(repeating: NotificationObject(), count: 20)
            return .just(notifications)
        }
    }
}

class ProfileViewModelTests: XCTestCase {
    
    var profileVC: ProfileViewController?
    var scheduler = TestScheduler(initialClock: 0)
    var disposeBag = DisposeBag()
    var mockProfile: ProfileAPIProtocol = ProfileAPI()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PROFILE_VC") as! ProfileViewController
        mockProfile = ProfileAPIMock(isError: false)
        let viewModel = ProfileViewModel(profileAPI: mockProfile)
        vc.viewModel = viewModel
        profileVC = vc
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchProfileSuccess() {
        let object = scheduler.createObserver(UserProfileObject.self)
        let mockProfile = ProfileAPIMock(isError: false)
        let userProfile = UserProfileObject()
        userProfile.userId = ""
        mockProfile.userProfile = userProfile
        
        let viewModel = ProfileViewModel(profileAPI: mockProfile)
        profileVC?.viewModel = viewModel
        scheduler.createColdObservable([.next(10, ())])
            .bind(onNext: { (_) in
                self.profileVC?.viewModel.inputs.onViewDidLoad()
            })
            .disposed(by: disposeBag)
        
        profileVC?
            .viewModel
            .outputs
            .profileData
            .drive(object)
            .disposed(by: disposeBag)
        
        scheduler.start()
                
        XCTAssertEqual(object.events, [.next(10, userProfile)])
    }
    
    func testFetchProfileFail() {
        let object = scheduler.createObserver(Error.self)
        let mockProfile = ProfileAPIMock(isError: true)
        
        let viewModel = ProfileViewModel(profileAPI: mockProfile)
        profileVC?.viewModel = viewModel
        scheduler.createColdObservable([.next(10, ())])
            .bind(onNext: { (_) in
                self.profileVC?.viewModel.inputs.onViewDidLoad()
            })
            .disposed(by: disposeBag)
        
        profileVC?
            .viewModel
            .outputs
            .isError
            .drive(object)
            .disposed(by: disposeBag)
        
        scheduler.start()
                
        
        XCTAssertEqual(object.events.count, 1)
    }
    
    func testFetchNotificationSuccess() {
        let object = scheduler.createObserver([NotificationObject].self)
         let mockProfile = ProfileAPIMock(isError: false)
         let userProfile = UserProfileObject()
         userProfile.userId = ""
         mockProfile.userProfile = userProfile
         
         let viewModel = ProfileViewModel(profileAPI: mockProfile)
         profileVC?.viewModel = viewModel
         scheduler.createColdObservable([.next(10, ())])
             .bind(onNext: { (_) in
                 self.profileVC?.viewModel.inputs.onViewDidLoad()
             })
             .disposed(by: disposeBag)
         
         profileVC?
             .viewModel
             .outputs
             .dataSource
             .drive(object)
             .disposed(by: disposeBag)
         
         scheduler.start()
                 
        XCTAssertEqual(object.events.count, 1)
    }
    
    func testFetchNotificationFail() {
        let object = scheduler.createObserver(Error.self)
          let mockProfile = ProfileAPIMock(isError: true)
          let userProfile = UserProfileObject()
          userProfile.userId = ""
          mockProfile.userProfile = userProfile
          
          let viewModel = ProfileViewModel(profileAPI: mockProfile)
          profileVC?.viewModel = viewModel
          scheduler.createColdObservable([.next(10, ())])
              .bind(onNext: { (_) in
                  self.profileVC?.viewModel.inputs.onViewDidLoad()
              })
              .disposed(by: disposeBag)
          
          profileVC?
              .viewModel
              .outputs
              .isError
              .drive(object)
              .disposed(by: disposeBag)
          
          scheduler.start()
                  
         XCTAssertEqual(object.events.count, 1)
    }
    
    func testRetryButtonSuccess() {

        let notification = scheduler.createObserver([NotificationObject].self)
        let profile = scheduler.createObserver(UserProfileObject.self)
        let mockProfile = ProfileAPIMock(isError: false)
        let userProfile = UserProfileObject()
        userProfile.userId = ""
        mockProfile.userProfile = userProfile
        
        let viewModel = ProfileViewModel(profileAPI: mockProfile)
        profileVC?.viewModel = viewModel

        profileVC?
            .viewModel
            .outputs
            .profileData
            .drive(profile)
            .disposed(by: disposeBag)
        
        profileVC?
            .viewModel
            .outputs
            .dataSource
            .drive(notification)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(onNext: { (_) in
                self.profileVC?.viewModel.inputs.onRetryButtonTapped()
            })
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssert(notification.events[0].value.element != nil)
        XCTAssert(profile.events[0].value.element != nil)
    }
    
    func testRetryButtonFail() {
        
        let object = scheduler.createObserver(Error.self)
        let mockProfile = ProfileAPIMock(isError: true)
        
        let viewModel = ProfileViewModel(profileAPI: mockProfile)
        profileVC?.viewModel = viewModel
        scheduler.createColdObservable([.next(10, ())])
            .bind(onNext: { (_) in
                self.profileVC?.viewModel.inputs.onRetryButtonTapped()
            })
            .disposed(by: disposeBag)
        
        profileVC?
            .viewModel
            .outputs
            .isError
            .drive(object)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssert(object.events[0].value.element != nil)
    }
}
