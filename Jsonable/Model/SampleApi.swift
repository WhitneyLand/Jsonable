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
    
    // Global post event handler
    override func postResponse(index: Int, entity: Jsonable, resultJsonObject: AnyObject, result: HttpResult) {
        
        if let array = resultJsonObject as? NSArray {
            println("Received JSON Array response.")
            for item in array {
                println(item)
            }
        }
        else if let item = resultJsonObject as? NSDictionary {
            println("Received JSON Object response.")
        }
    }
}