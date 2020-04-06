//
//  SCDateUtils.swift
//  corona-go
//
//  Created by indie dev on 31/03/20.
//

import Foundation

class SCDateUtils {
    
    class func getDate(forString dateString: String?, withFormat: String) -> Date? {
        guard let dateVal = dateString else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = withFormat
        return dateFormatter.date(from: dateVal)
    }
    
}

enum SCDateFormats {
    case DATE_CONSTANT
    case TIME_CONSTANT
    case DATE_AND_TIME_WITH_T_CONSTANT
    case DATE_AND_TIME_CONSTANT
    case DATE_DISPLAY_CONSTANT
    case DOB_DATE_CONSTANT
    
    var type: String {
        switch self {
        case .DATE_CONSTANT: return "yyyy-MM-dd"
        case .TIME_CONSTANT: return "hh:mm a"
        case .DATE_AND_TIME_CONSTANT: return "yyyy-MM-dd hh:mm a"
        case .DATE_AND_TIME_WITH_T_CONSTANT: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .DATE_DISPLAY_CONSTANT: return "dd MMM, yyyy"
        case .DOB_DATE_CONSTANT: return "dd/MM/yyyy"
        }
    }
}

extension Date {
    
    func toString(dateFormat format: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func isYesterday() -> Bool{
        return Calendar.current.isDateInYesterday(self)
    }
}
