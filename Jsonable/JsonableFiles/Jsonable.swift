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
    
    func fromJsonDictionary(d: NSDictionary) {
        setValuesForKeysWithDictionary(d)
    }
    
    func fromJsonData(data: NSData) {
        var jsonError: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
            options: .AllowFragments,
            error: &jsonError)
        fromJsonDictionary(jsonObject as NSDictionary)
    }
    
    func toJsonString() -> NSString! {
        return NSString(data: self.toJsonData(), encoding: NSUTF8StringEncoding)
    }
    
    func toJsonData() -> NSData! {
        var dictionary = self.toJsonDictionary()
        var err: NSError?
        return NSJSONSerialization.dataWithJSONObject(dictionary, options:NSJSONWritingOptions.PrettyPrinted, error: &err)
    }
    
    func toJsonDictionary() -> NSDictionary {
        
        let aClass : AnyClass? = self.dynamicType
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass = class_copyPropertyList(aClass, &propertiesCount)
        let props : NSMutableDictionary = NSMutableDictionary()
        
        for var i = 0; i < Int(propertiesCount); i++ {
            let property = propertiesInAClass[i]
            let propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            let propType = property_getAttributes(property)
            let propValue : AnyObject? = self.valueForKey(propName);

            let propTypeCode = String.fromCString(propType)!
            let propTypeCodeAttributes = propTypeCode.componentsSeparatedByString(",")
            let typeAttribute = propTypeCodeAttributes[0]

            // T@           String | Array
            // T@"NSDate"   NSDate
            // T@"<name>"   custom object
            // TB           Bool
            // Td           Double
            // Tf           Float
            // Tq           Int
            // TQ           Int            
            var typeName = ""
            if typeAttribute.contains("TB") {
                typeName = "Bool"
                props.setValue(propValue as Bool, forKey: propName)
            }
            else if typeAttribute.contains("Td") {
                typeName = "Double"
                props.setValue(propValue as Double, forKey: propName)
            }
            else if typeAttribute.contains("Tf") {
                typeName = "Float"
                props.setValue(propValue as Float, forKey: propName)
            }
            else if typeAttribute.contains("Tq") {
                typeName = "Int"
                props.setValue(propValue as Int, forKey: propName)
            }
            else if typeAttribute.contains("TQ") {
                typeName = "Int"
                props.setValue(propValue as UInt, forKey: propName)
            }
            else if typeAttribute.contains("T@") {
                typeName = "Object"
            }
            
            if typeName == "Object" {
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
}

extension Jsonable {
    override var description: String {
        get {
            var s: String = ""
            var mirror=reflect(self)
            s += mirror.summary + "\n"
            s += Reflector.listProperties(mirror)
            return s
        }
    }
}