//
//  Jsonable.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation

class Jsonable : NSObject {
    
    class func urlName() -> String { return "" }
    class func dateFormat() -> String { return DateFormat.Iso8601 }
    class func createInstance() -> Jsonable { return Jsonable() }

    var moreProperties = Dictionary<String, AnyObject?>()
    
    func toJsonString() -> NSString! {
        return NSString(data: self.toJsonData(), encoding: NSUTF8StringEncoding)
    }
    
    func toJsonData() -> NSData! {
        var dictionary = self.toJsonDictionary()
        var err: NSError?
        return NSJSONSerialization.dataWithJSONObject(dictionary, options:NSJSONWritingOptions.PrettyPrinted, error: &err)
    }
    
    func toJsonDictionary() -> NSDictionary {
        
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass = class_copyPropertyList(self.dynamicType, &propertiesCount)
        let props : NSMutableDictionary = NSMutableDictionary()
        
        for i in 0..<Int(propertiesCount) {

            let property = propertiesInAClass[i]
            let propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            let propType = property_getAttributes(property)
            let propValue : AnyObject? = self.valueForKey(propName);

            let propTypeCode = String.fromCString(propType)!
            let propTypeCodeAttributes = propTypeCode.componentsSeparatedByString(",")
            let typeAttribute = propTypeCodeAttributes[0]

            if typeAttribute.contains("TB") {
                props.setValue(propValue as Bool, forKey: propName)
            }
            else if typeAttribute.contains("Td") {
                props.setValue(propValue as Double, forKey: propName)
            }
            else if typeAttribute.contains("Tf") {
                props.setValue(propValue as Float, forKey: propName)
            }
            else if typeAttribute.contains("Tq") {
                props.setValue(propValue as Int, forKey: propName)
            }
            else if typeAttribute.contains("TQ") {
                props.setValue(propValue as UInt, forKey: propName)
            }
            else if typeAttribute.contains("T@") {  // Object
                switch(propValue) {
                    case let dateValue as NSDate:
                        props.setValue(dateValue.stringFromFormat(Jsonable.dateFormat()), forKey: propName)
                    case let urlValue as NSURL:
                        props.setValue(urlValue.absoluteString, forKey: propName)
                    case let dataValue as NSData:
                        props.setValue(dataValue.base64EncodedStringWithOptions(nil), forKey: propName)
                    case let arrayValue as Array<Jsonable>:
                        var subArray = Array<NSDictionary>()
                        for item in arrayValue {
                            subArray.append(item.toJsonDictionary())
                        }
                        props.setValue(subArray, forKey: propName)
                    case let objectValue as Jsonable:
                        props.setValue(objectValue.toJsonDictionary(), forKey: propName)
                    default:
                        props.setValue(propValue, forKey: propName)
                }
            }
        }
        return props
    }
    
    func toDescription() -> String {
        var s = ""
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass = class_copyPropertyList(self.dynamicType, &propertiesCount)
        let props : NSMutableDictionary = NSMutableDictionary()
        
        for i in 0..<Int(propertiesCount) {
            
            let property = propertiesInAClass[i]
            let propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            let propType = property_getAttributes(property)
            let propValue : AnyObject? = self.valueForKey(propName);
            
            let propTypeCode = String.fromCString(propType)!
            let propTypeCodeAttributes = propTypeCode.componentsSeparatedByString(",")
            let typeAttribute = propTypeCodeAttributes[0]
            
            if typeAttribute.contains("TB") {
                s = s + "  \(propName): \(propValue as Bool)\n"
            }
            else if typeAttribute.contains("Td") {
                s = s + "  \(propName): \(propValue as Double)\n"
            }
            else if typeAttribute.contains("Tf") {
                s = s + "  \(propName): \(propValue as Float)\n"
            }
            else if typeAttribute.contains("Tq") {
                s = s + "  \(propName): \(propValue as Int)\n"
            }
            else if typeAttribute.contains("TQ") {
                s = s + "  \(propName): \(propValue as UInt)\n"
            }
            else if typeAttribute.contains("T@") {  // Object
                switch(propValue) {
                    case let stringValue as NSString:
                    s = s + "  \(propName): \(stringValue)\n"
                    case let dateValue as NSDate:
                        s = s + "  \(propName): \(dateValue.stringFromFormat(Jsonable.dateFormat()))\n"
                    case let urlValue as NSURL:
                        s = s + "  \(propName): \(urlValue.absoluteString)\n"
                    case let dataValue as NSData:
                        s = s + "  \(propName): \(dataValue.base64EncodedStringWithOptions(nil))\n"
                    case let arrayValue as Array<Jsonable>:
                        for item in arrayValue {
                            item.toDescription()
                        }
                    case let objectValue as Jsonable:
                        objectValue.toDescription()
                    default:
                        s = s + "  \(propName): \(propValue)\n"
                }
            }
        }
        return s
    }
    
    override var description: String {
        get {
            var s: String = ""
            s += "\(self.dynamicType.description())\n"
            s += self.toDescription()
            return s
        }
    }
    
    func fromJsonDictionary(d: NSDictionary) {
        for (key,value) in d {
            let propertyName = key as String
            
            if respondsToSelector(Selector(propertyName)) {
                super.setValue(value, forKey: propertyName)
            }
            else {
                moreProperties[propertyName] = value
                println("\(className) property not found: \(key)")
            }
        }
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if respondsToSelector(Selector(key)) {
            super.setValue(value, forKey: key)
        }
        else {
            println("\(className) property not found: \(key)")
        }
    }

    var className: String {
        get {
            let s = self.dynamicType.description()
            return s.componentsSeparatedByString(".")[1]
        }
    }

    func fromJsonData(data: NSData) {
        var jsonError: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
            options: .AllowFragments,
            error: &jsonError)
        fromJsonDictionary(jsonObject as NSDictionary)
    }
    
    func fromJsonString(text: String) {
        let data = text.dataUsingEncoding(NSUTF8StringEncoding)!
        fromJsonData(data)
    }
}


