//
//  JsonableApi.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation


class Api<T:Jsonable> : SequenceType {
    
    init() {
        headers["Content-Type"] = "application/json"
    }
    
    var entityList : [T] = []
    var baseUrl: String = ""
    var headers = Dictionary<String, String>()
    
    func entityBaseUrl() -> NSURL {
        var url = "\(baseUrl)\(T.urlName())"
        return NSURL(string:url)!
    }
    
    func entityUrl(id: String) -> NSURL {
        var url = "\(baseUrl)\(T.urlName())/\(id)"
        return NSURL(string:url)!
    }
    
    //
    // Get an array of Json objects and deserialize them to Swift
    //
    func get(completionHandler: ((result: HttpResult) -> Void)!) {

        Http().get(self.entityBaseUrl(), headers: headers) { (result) in
            
            if result.success {
                if let jsonObject: AnyObject = result.jsonObject {

                    self.entityList = self.jsonArrayToSwiftArray(jsonObject as NSArray)
                    
                    // If successful fire global event handler
                    for index in 0..<self.entityList.count {
                        var entity = self.entityList[index]
                        var apiNotification = ApiNotification(index: index, entity: entity, jsonObject: jsonObject, result: result)
                        self.getApiNotification(apiNotification)
                    }
                }
            }
            completionHandler(result: result)
        }
    }

    //
    // Get a single Json object and deserialize it to Swift
    //
    func get(id: String, completionHandler: ((result: HttpResult) -> Void)!) {

        Http().get(self.entityUrl(id), headers: headers) { (result) in

            if result.success {
                if let jsonObject: AnyObject = result.jsonObject {
                    let entity = self.createType()
                    entity.fromJsonDictionary(jsonObject as NSDictionary)
                    self.entityList.append(entity)

                    // If successful fire global event handler
                    for index in 0..<self.entityList.count {
                        var apiNotification = ApiNotification(index: index, entity: entity, jsonObject: jsonObject, result: result)
                        self.getApiNotification(apiNotification)
                    }
                }
            }
            
            completionHandler(result: result)
        }
    }

    func get(id: Int, completionHandler: ((result: HttpResult) -> Void)!) {        
        get("\(id)") { (result) in
            completionHandler(result: result)
        }
    }
    
    //
    // Post Json from array of serialized Swift objects
    //
    func post(completionHandler: ((result: HttpResult) -> Void)!) {
        
        if entityList.count == 0 {
            println("Warning: post called with no data.")
        }
        var error: NSError?
        var jsonArray = swiftArrayToJsonArray()
        var jsonData = NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error)

        Http().post(self.entityBaseUrl(), headers: headers, data:jsonData!) { (result) in
            
            // After getting result, allow for post processing
            if result.success {
                if let jsonObject: AnyObject = result.jsonObject {
                    for index in 0..<self.entityList.count {
                        var entity = self.entityList[index]
                        var apiNotification = ApiNotification(index: index, entity: entity, jsonObject: jsonObject, result: result)
                        self.postApiNotification(apiNotification)
                    }
                }
            }
            completionHandler(result: result)
        }
    }

    //
    // Update Json from array of serialized Swift objects
    //
    func put(completionHandler: ((result: HttpResult) -> Void)!) {
        
        if entityList.count == 0 {
            println("Warning: put called with no data.")
        }
        var error: NSError?
        var jsonArray = swiftArrayToJsonArray()
        var jsonData = NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        
        Http().put(self.entityBaseUrl(), headers: headers, data:jsonData!) { (result) in

            // After getting result, allow for post processing
            if result.success {
                if let jsonObject: AnyObject = result.jsonObject {
                    for index in 0..<self.entityList.count {
                        var entity = self.entityList[index]
                        var apiNotification = ApiNotification(index: index, entity: entity, jsonObject: jsonObject, result: result)
                        self.putApiNotification(apiNotification)
                    }
                }
            }
            completionHandler(result: result)
        }
    }
    
    //
    // Delete Json based on array of serialized Swift objects
    //
    func delete(completionHandler: ((result: HttpResult) -> Void)!) {
        
        if entityList.count == 0 {
            println("Warning: delete called with no data.")
        }
        var error: NSError?
        var jsonArray = swiftArrayToJsonArray()
        var jsonData = NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        
        Http().delete(self.entityBaseUrl(), headers: headers, data:jsonData!) { (result) in
            
            // After getting result, allow for post processing
            if result.success {
                if result.headers["Content-Type"]!.contains("application/json") {
                    if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(result.data!, options: .AllowFragments, error: &error) as AnyObject? {
                        for index in 0..<self.entityList.count {
                            var entity = self.entityList[index]
                            var apiNotification = ApiNotification(index: index, entity: entity, jsonObject: jsonObject, result: result)
                            self.deleteApiNotification(apiNotification)
                        }
                    }
                }
            }
            completionHandler(result: result)
        }
    }
    
    // allow calls with no return value or completion handler
    func post() {
        var result = HttpResult()
        self.delete() { (result) in
        }
    }

    func put() {
        var result = HttpResult()
        self.delete() { (result) in
        }
    }

    func delete() {
        var result = HttpResult()
        self.delete() { (result) in
        }
    }
    
    // -----------------------------
    // Global event handlers 
    // Virtual methods will be called when overriden
    //
    
    // Client can update Swift objects with any newly created Id's returned from POST
    func getApiNotification(apiNotification: ApiNotification) {
    }

    func postApiNotification(apiNotification: ApiNotification) {
    }
    
    func putApiNotification(apiNotification: ApiNotification) {
    }
    
    func deleteApiNotification(apiNotification: ApiNotification) {
    }
    
    func jsonArrayToSwiftArray(jsonArray: NSArray) -> [T] {
        var entityList : [T] = []
        for jsonDictionary in jsonArray {
            let entity = createType()
            entity.fromJsonDictionary(jsonDictionary as NSDictionary)
            entityList.append(entity as T)
        }
        return entityList
    }
    
    func swiftArrayToJsonArray() -> NSArray {
        var array = NSMutableArray()

        for entity in entityList {
            var jsonDictionary = entity.toJsonDictionary()
            array.addObject(jsonDictionary)
        }
        return array
    }


    func toJsonString() -> String {
        var s = ""
        s += "\"\(T.urlName())\": [\n"
        for i in 0..<entityList.count {
            var entity = entityList[i]
            s += entity.toJsonString()
            if (i < entityList.count-1) {
                s += ", \n"
            }
        }
        s += "]"
        return s
    }
    
    var className: String {
        get {
            let s = T.self.description()
            return s.componentsSeparatedByString(".")[1]
        }
    }

    // Enable for-in iteration
    func generate() -> GeneratorOf<T> {
        var nextIndex = entityList.count-1
        return GeneratorOf<T> {
            if (nextIndex < 0) {
                return nil
            }
            return self.entityList[nextIndex--]
        }
    }
    
    // Enable array style access
    subscript(index: Int) -> T {
        get {
            return entityList[index]
        }
        set(newMessage) {
            entityList[index] = newMessage
        }
    }
    
    func append(newEntity : T) {
        entityList.append(newEntity)
    }
    
    var count: Int {
        get {
            return entityList.count
        }
    }
    
    // Work around for Swift generics not supporting virtual constructors
    // http://stackoverflow.com/questions/26280176/swift-generics-not-preserving-type
    func createType() -> T {
        return T.createInstance() as T
    }
}

class ApiNotification {

    let index: Int
    let entity: Jsonable
    let jsonObject: AnyObject
    let result: HttpResult
    
    init(index: Int, entity: Jsonable, jsonObject: AnyObject, result: HttpResult) {
        self.index = index
        self.entity = entity
        self.jsonObject = jsonObject
        self.result = result
    }
}

