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
    // Format a date based on specific conditions
    func dateFormat() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let timeZone = TimeZone.current

        // Ensure timezone and locale are set
        dateFormatter.timeZone = timeZone

        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "'Today,' h:mm a"
        } else if calendar.isDateInYesterday(self) {
            dateFormatter.dateFormat = "MMM d, h:mm a"
        } else if let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())),
                  self >= startOfYear {
            dateFormatter.dateFormat = "MMM d, h:mm a"
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
        }

        // Format the date and print debug info
        let result = dateFormatter.string(from: self)
        return result
    }
       
       // Generate a header timestamp
       func generateHeaderTimestamp() -> String {
           let dateFormatter = DateFormatter()
           let calendar = Calendar.current
           
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
               return format("EEE, MMM d") // Fixed the format for consistency
           } else {
               // Case: Older Dates
               return format("MMM d, yyyy")
           }
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


