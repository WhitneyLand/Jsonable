//
//  JsonableUtility.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//

import Foundation

struct DateFormat {
    static let Iso8601 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static let DotNet = "/Date(%.0f000%@)/"
}

extension NSDate {
    
    // ISO 8601, example: 2014-09-19T07:22:00Z
    convenience init(iso: String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = DateFormat.Iso8601
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(iso)
        self.init(timeInterval:0, sinceDate:d!)
        
    }
    // Example:
    //  var date = NSDate(isoDate:"2014-09-19T07:22:00Z")
    //  println(date.stringFromFormat("h:mm a"))
    //  println(date.stringFromFormat("M/d/yyyy"))
    //
    func stringFromFormat(format: String) -> String {
        if format == DateFormat.DotNet {
            return self.dotNet
        }
        else {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.stringFromDate(self)
        }
    }
    
    var iso : String {
        get {
            return stringFromFormat(DateFormat.Iso8601)
        }
    }

    var dotNet : String {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "Z"
            var dateString = NSString(format: DateFormat.DotNet, self.timeIntervalSince1970, dateFormatter.stringFromDate(self))
            return dateString
        }
    }
}

extension String {
    
    func contains(find: String) -> Bool{
        if let temp = self.rangeOfString(find){
            return true
        }
        return false
    }
}

class Reflector {
    class func getDescription(obj: AnyObject?) -> String {
        var s: String = ""
        var mirror=reflect(obj)
        s += mirror.summary + "\n"
        s += listProperties(mirror)
        return s
    }
    
    class func listProperties(mirror: MirrorType) -> String
    {
        var s: String = ""
        for (var i=0;i<mirror.count;i++)
        {
            if (mirror[i].0 == "super")
            {
                s += listProperties(mirror[i].1)
            }
            else
            {
                var name = mirror[i].0
                var value = mirror[i].1.value
                s += "  \(name): \(value)\n"
            }
        }
        return s
    }
}