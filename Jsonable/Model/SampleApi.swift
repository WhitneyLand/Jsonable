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
    override func postApiNotification(apiNotification: ApiNotification) {
        
        if let array = apiNotification.jsonObject as? NSArray {
            println("Received JSON Array response.")
            for item in array {
                println(item)
            }
        }
        else if let item = apiNotification.jsonObject as? NSDictionary {
            println("Received JSON Object response.")
        }
    }
}