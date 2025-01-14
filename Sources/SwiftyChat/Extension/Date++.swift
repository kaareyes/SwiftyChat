//
//  Date++.swift
//  
//
//  Created by Enes Karaosman on 16.03.2022.
//

import Foundation

internal extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    func dateFormat() -> String {
        let dateFormatter = DateFormatter()

        if Calendar.current.isDateInToday(self) {
            // Today
            dateFormatter.dateFormat = "Today, h:mm a"
        } else if Calendar.current.isDateInYesterday(self) {
            // Yesterday
            dateFormatter.dateFormat = "MMM d, h:mm a"
        } else if let startOfYear = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Date())),
                  self >= startOfYear {
            // Month-to-Date and Year-to-Date
            dateFormatter.dateFormat = "MMM d, h:mm a"
        } else {
            // Older dates
            dateFormatter.dateFormat = "MMM d, yyyy"
        }

        return dateFormatter.string(from: self)
    }
    func generateHeaderTimestamp() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        // Helper function to format the date
        func format(_ format: String) -> String {
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: self)
        }

        if calendar.isDateInToday(self) {
            // Case: Today
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            // Case: Yesterday
            return "Yesterday"
        } else if let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())),
                  self >= startOfYear {
            // Case: Month-to-Date or Year-to-Date
            return format("Ddd, MMM dd")
        } else {
            // Case: Older Dates
            return format("MMM dd, yyyy")
        }
        
        return dateFormatter.string(from: self)

    }

    var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
}


