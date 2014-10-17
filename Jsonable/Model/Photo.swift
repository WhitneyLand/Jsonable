//
//  Photo.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation

class Photo : Jsonable {
    
    override class func urlName() -> String { return "photos" }
    override class func createInstance() -> Jsonable { return Photo() }
    
    var id = 0
    var albumId = 0
    var title = ""
    var url = NSURL()       // Urls can be stored as Strings or NSURL types which will be converted to strings in Json
    var thumbnailUrl = ""
}
