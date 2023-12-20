//
//  DateFormatterHelper.swift
//  DemoRxSwift
//


import Foundation

class DateFormatterHelper {
    static let shared = DateFormatterHelper()
    
    private init() {}
    
    func string(from date: Date, format: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = format
           return dateFormatter.string(from: date)
       }

       func date(from string: String, format: String) -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = format
           return dateFormatter.date(from: string)
       }

       func formatTime(from dateString: String) -> String? {
           let dateFormatter = DateFormatter()
           dateFormatter.locale = Locale(identifier: "en_US_POSIX")
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

           if let date = dateFormatter.date(from: dateString) {
               let timeFormatter = DateFormatter()
               timeFormatter.dateFormat = "HH:mm"
               return timeFormatter.string(from: date)
           } else {
               return nil
           }
       }
}
