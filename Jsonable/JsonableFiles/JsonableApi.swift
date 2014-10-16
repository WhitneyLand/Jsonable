//
//  JsonableApi.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation


class Api<T:Jsonable> : SequenceType {
    
    var entityList : [T] = []
    var baseUrl: String { get { return "" } }
    
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

        Http().get(self.entityBaseUrl()) { (result) in
            
            var error: NSError?
            if let jsonArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(result.data!,
                options: .AllowFragments, error: &error) as AnyObject! {
                self.entityList = self.jsonArrayToSwiftArray(jsonArray as NSArray)
            }
            completionHandler(result: result)
        }
    }

    //
    // Get a single Json object and deserialize it to Swift
    //
    func get(id: String, completionHandler: ((result: HttpResult) -> Void)!) {
        
        Http().get(self.entityUrl(id)) { (result) in

            let entity = self.createType()
            entity.fromJsonData(result.data!)
            self.entityList.append(entity)
            completionHandler(result: result)
        }
    }

    func get(id: Int, completionHandler: ((result: HttpResult) -> Void)!) {        
        get("\(id)") { (result) in
            completionHandler(result: result)
        }
    }
    
    //
    // TODO:
    // Post Json from array of serialized Swift objects
    //
    func post(completionHandler: ((result: HttpResult) -> Void)!) {
        
        var error: NSError?
        var jsonArray = swiftArrayToJsonArray()
        var jsonData = NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error)

        Http().post(self.entityBaseUrl(), data:jsonData!) { (result) in
            
            // Update Swift objects with any newly created Id's returned from the POST
            
            completionHandler(result: result)
        }
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
    
    // Work around for Swift generics not supporting virtual constructors
    // http://stackoverflow.com/questions/26280176/swift-generics-not-preserving-type
    func createType() -> T {
        return T.createInstance() as T
    }
}
