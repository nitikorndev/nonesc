//
//  ViewModel.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 17/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
protocol ProfileVCViewModelDelegateInput {
    func onViewDidLoad()
    func onRetryButtonTapped()
}

protocol ProfileVCViewModelDelegateOutput: class {
    var onShowConnectionError: Driver<Void>! { get }
    var dataSource: Driver<[NotificationObject]> { get }
    var profileData: Driver<UserProfileObject> { get }
    var isLoading: ActivityIndicator { get }
    var isError: Driver<Error> { get }
}

typealias ProfileNotification = (UserProfileObject, [NotificationObject])

protocol ProfileVCViewModelDelegateType {
    var inputs: ProfileVCViewModelDelegateInput { get }
    var outputs: ProfileVCViewModelDelegateOutput { get }
}

class ProfileViewModel: ProfileVCViewModelDelegateType, ProfileVCViewModelDelegateInput, ProfileVCViewModelDelegateOutput {
        
    var inputs: ProfileVCViewModelDelegateInput { return self }
    var outputs: ProfileVCViewModelDelegateOutput { return self }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var onShowConnectionError: Driver<Void>!
    var _onShowConnectionError: PublishSubject<Void> = PublishSubject<Void>()
    var _dataSource: BehaviorRelay<[NotificationObject]?> = BehaviorRelay<[NotificationObject]?>(value: nil)
    var dataSource: Driver<[NotificationObject]> {
        return _dataSource.asObservable().filterNil().asDriver(onErrorDriveWith: Driver.empty())
    }
    var _profileData: BehaviorRelay<UserProfileObject?> = BehaviorRelay<UserProfileObject?>(value: nil)
    var profileData: Driver<UserProfileObject> {
        return _profileData.asObservable().filterNil().asDriver(onErrorDriveWith: Driver.empty())
    }
    var _isError: PublishSubject<Error> = PublishSubject<Error>()
    var isError: Driver<Error> {
        return _isError.asDriver(onErrorDriveWith: Driver.empty())
    }
    
    let isLoading = ActivityIndicator()
    
    var profileAPI: ProfileAPIProtocol

    init(profileAPI: ProfileAPIProtocol = ProfileAPI()) {
        self.profileAPI = profileAPI
    }
    
    func fetchProfile() {
        profileAPI
            .getProfile()
            .sendErrorTo(_isError)
            .flatMapLatest { [weak self] (user) -> Observable<ProfileNotification> in
                guard let `self` = self, let userID = user.userId else { return Observable.empty() }
                return self.profileAPI
                    .getNotificationList(userID: userID)
                    .sendErrorTo(self._isError)
                    .map { (notifications) -> ProfileNotification in
                    return (user, notifications)
                }
        } .trackActivity(self.isLoading)
            .subscribe(onNext: { (tuple) in
            self._profileData.accept(tuple.0)
            self._dataSource.accept(tuple.1)
        }).disposed(by: disposeBag)
    }
    
    func onViewDidLoad() {
        fetchProfile()
    }
    
    func onRetryButtonTapped() {
        fetchProfile()
    }
}
