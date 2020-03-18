//
//  DateFormatterExtension.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 18/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let isoFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    static let notificationFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
}
