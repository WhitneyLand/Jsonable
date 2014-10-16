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
    var baseUrl = "http://jsonplaceholder.typicode.com/"
    
    //
    // Get an array of Json objects and deserialize them to Swift
    //
    func get(completionHandler: ((result: JsonHttpResult) -> Void)!) {
        dispatch_async(dispatch_get_main_queue(), {
            let jsonHttp = JsonHttp()
            let url = NSURL(string:"\(self.baseUrl)\(T.urlName())")!
            jsonHttp.Get(url) { (result) in
                self.entityList = self.jsonArrayToSwiftArray(jsonHttp.data as NSArray)
                completionHandler(result: result)
            }
        })
    }

    //
    // TODO:
    // Get a single Json object and deserialize it to Swift
    //
    func get(id: String, completionHandler: ((result: JsonHttpResult) -> Void)!) {
    }

    //
    // TODO:
    // Post Json from serialized Swift objects
    //
    func post(completionHandler: ((result: JsonHttpResult) -> Void)!) {
    }
    
    func jsonArrayToSwiftArray(jsonArray: NSArray) -> [T] {
        var entityList : [T] = []
        for jsonDictionary in jsonArray {
            let entity = T()
            entity.fromJsonDictionary(jsonDictionary as NSDictionary)
            entityList.append(entity)
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
}
