//
//  NSDate+Extension.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit

extension NSDate{
    
    class func getDateString(date:Date, customFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customFormat
        return dateFormatter.string(from: date)
    }
    
    class func getDateString(strDate:String, dateFormat:String, convertToCustomDateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat                   // date in this format ex: @"yyyy-MM-dd"
        let date = dateFormatter.date(from: strDate)            // String date to NSDate conversion
        dateFormatter.dateFormat = convertToCustomDateFormat    // set new formatter ex: "dd-MMM-yyyy"
        return dateFormatter.string(from: date!)                // get date string in new custom format
    }
    
    class func getDate(strDate:String, dateFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: strDate)!
    }
}
