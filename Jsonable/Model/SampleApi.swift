//
//  SampleApi.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/16/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation

class SampleApi<T:Jsonable> : Api<T> {
    
    override var baseUrl: String { get { return "http://jsonplaceholder.typicode.com/" } }
    
    func postResponseUpdate<T:Jsonable>(entity: T, response: NSDictionary) {
//        var photo: Photo = entity as Photo
    }
}