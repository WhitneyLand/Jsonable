//
//  SampleApi.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/16/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation

class SampleApi<T:Jsonable> : Api<T> {
    
    override init() {
        super.init()
        
        baseUrl = "http://jsonplaceholder.typicode.com/"
    }
    

    override func postResponseUpdate(index: Int, entity: Jsonable, resultJsonObject: AnyObject) {
        
        if let array = resultJsonObject as? NSArray {
            println("Received JSON Array response.")
            for item in array {
                println(item)
            }
        }
        else if let item = resultJsonObject as? NSDictionary {
            println("Received JSON Object response.")
        }
        
/*
        var photo: Photo = entity as Photo
        photo.id = 3
        photo.albumId = 5
        photo.url = NSURL(string: "http://")!
        photo.thumbnailUrl = "ftp://"
        println(photo)
*/
    }
}