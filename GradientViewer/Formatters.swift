//
//  Formatters.swift
//
//  Created by Frédéric ADDA on 02/04/2017.
//  Copyright © 2017 Frédéric ADDA. All rights reserved.
//

import Foundation


class Formatters: NSObject {

    override private init() { }

    // MARK: - Properties

    // MARK: Singleton
    static let shared = Formatters()


    // MARK: - Number formatters

    /// Integer formatter
    lazy var integerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()


    /// DoubleFormatter
    lazy var doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    // MARK: - Date formatters

    /// Server date formatter
    lazy var serverDateFormatter: DateFormatter = {
        let gmtFormatter = DateFormatter()
        gmtFormatter.locale = Locale(identifier:"en_US_POSIX")
        gmtFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // example: "2016-03-08T15:20:43Z"
        gmtFormatter.timeZone = TimeZone(abbreviation:"GMT")
        return gmtFormatter
    }()

    /// Server local date formatter
    lazy var serverDateFormatter2: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mma" // example: "3/8/2016 10:02am"
        return dateFormatter
    }()

    /// Audioplayer time formatter 'mm:ss'
    lazy var audioTimeFormatter: DateComponentsFormatter = {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.zeroFormattingBehavior = .pad
        dateComponentsFormatter.allowedUnits = [.minute, .second]
        return dateComponentsFormatter
    }()
}
