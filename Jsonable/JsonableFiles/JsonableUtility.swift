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
        var isoDateString: String?
        if iso.length == 10 {           // Allow shortcut like this:  2014-09-19
            isoDateString = "\(iso)T00:00:00Z"
        }
        else {
            isoDateString = iso
        }
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = DateFormat.Iso8601
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(isoDateString!)
        self.init(timeInterval:0, sinceDate:d!)
    }
    
    // Example:
    //  var date = NSDate(iso: "2014-09-19T07:22:00Z")
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

    var length: Int {
        get {
            return countElements(self)
        }
    }
    
    func contains(find: String) -> Bool{
        if let temp = self.rangeOfString(find){
            return true
        }
        return false
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    //  http://stackoverflow.com/a/25004154/700206
    init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in enumerate(lines) {
            self += "\(item)"
            if idx < lines.count-1 {
                self += sep
            }
        }
    }
    
    init(_ lines:String...){
        self = ""
        for (idx, item) in enumerate(lines) {
            self += "\(item)"
            if idx < lines.count-1 {
                self += "\n"
            }
        }
    }
}

// experimental
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
        var propertyCount: Int = mirror.count

        for i in 0..<propertyCount {
            if (mirror[i].0 == "super")
            {
                s += listProperties(mirror[i].1)
            }
            else
            {
                var name = mirror[i].0
                var value = mirror[i].1.value
                var disposition = mirror[i].1.disposition
                if MirrorDisposition.IndexContainer == disposition {
                    s += "  []: \(mirror[i].1.count) items."
                    return s
                }
                if name == "__test" {
                    var summary = mirror[i].1.summary
                    var valueType = mirror[i].1.valueType
                    var count = mirror[i].1.count
                }
                s += "  \(name): \(value)\n"
            }
        }
        return s
    }
}