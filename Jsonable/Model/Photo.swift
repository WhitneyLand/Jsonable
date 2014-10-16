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
    
    var id: Double = 0
    var albumId: Double = 0
    var title: String = ""
    var url = NSURL()
    var thumbnailUrl = NSURL()
}
