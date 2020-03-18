//
//  NotificationAPIType.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 17/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation
import Moya

struct APIConstant {
    static let baseURL = "https://testapi.io/api/"
}

// MARK: - Provider setup

public enum ProfileAPIType {
    case getProfile
    case getNotificationList(userID: String)
}

extension ProfileAPIType: TargetType {
    public var baseURL: URL {
        return URL(string: APIConstant.baseURL)!
    }

    public var path: String {
        switch self {
        case .getProfile:
            return "razir/user/profile"
        case .getNotificationList(let userID):
            return "razir/users/\(userID)/notifications"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var sampleData: Data {
        switch self {
        case .getProfile:
            return "{\"userID\": \"sad\"}".data(using: .utf8) ?? Data()
        default:
            return "[{\"created\": \"2019-05-23T10:13:00.000Z\"}]".data(using: .utf8) ?? Data()
        }
    }

    public var task: Task {
        return .requestPlain
    }

    public var headers: [String : String]? {
        return nil
    }
}
