//
//  Extensions.swift
//  NewsAPIDemo
//
//  Created by Rathakrishnan Ramasamy on 08/04/22.
//

import Foundation

extension Date {
    
    var threeDayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -3, to: .now)!
    }
    
}

extension DateFormatter {
    static let df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        
        return df
    }()
}
