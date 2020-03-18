//
//  ProfileAPI.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 17/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
protocol ProfileAPIProtocol {
    func getProfile() -> Observable<UserProfileObject>
    func getNotificationList(userID: String) -> Observable<[NotificationObject]>
}

class ProfileAPI: ProfileAPIProtocol {

    private var provider: MoyaProvider<ProfileAPIType>

    init(provider: MoyaProvider<ProfileAPIType> = MoyaProvider<ProfileAPIType>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }

    func getProfile() -> Observable<UserProfileObject> {
        return provider
            .rx
            .request(.getProfile)
            .asObservable()
            .mapServiceObject(type: UserProfileObject.self)
    }
    
    func getNotificationList(userID: String) -> Observable<[NotificationObject]> {
        return provider
            .rx
            .request(.getNotificationList(userID: userID))
            .asObservable()
            .mapServiceObject(type: [NotificationObject].self)
    }
}




