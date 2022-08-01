//
//  Date+.swift
//  Foxpay
//
//  Created by Nguyen Huy Quang on 11/2/20.
//

import Foundation
import UIKit

extension Date {
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
    }
    
    func string(format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }
    
    /// Compare two date. -1 is self lower than date, 0 is the same, 1 is greater than date
    func compare(with date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year1 = Int(dateFormatter.string(from: self)) ?? 0
        let year2 = Int(dateFormatter.string(from: date)) ?? 0
        if year1 < year2 {
            return -1
        } else if year1 > year2 {
            return 1
        } else {
            dateFormatter.dateFormat = "M"
            let month1 = Int(dateFormatter.string(from: self)) ?? 0
            let month2 = Int(dateFormatter.string(from: date)) ?? 0
            if month1 < month2 {
                return -1
            } else if month1 > month2 {
                return 1
            } else {
                dateFormatter.dateFormat = "d"
                let day1 = Int(dateFormatter.string(from: self)) ?? 0
                let day2 = Int(dateFormatter.string(from: date)) ?? 0
                if day1 < day2 {
                    return -1
                } else if day1 > day2 {
                    return 1
                } else {
                    return 0
                }
            }
            
        }
    }
    
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func currentTimeInMicroSecond() -> Double {
      return self.timeIntervalSince1970 * pow(10.0, 6.0)
    }
    
    func currentTimeInNanoSecond() -> Double {
      return self.timeIntervalSince1970 * pow(10.0, 9.0)
    }
    
    func currentTimeInMiliSecond() -> Double {
      return (self.timeIntervalSince1970 * 1000.0)
    }
    
}

