//
//  Car.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation

class Car : Jsonable {

    override class func urlName() -> String { return "cars" }
    override class func createInstance() -> Jsonable { return Car() }

    // Optional  -  may or may not exist in Json
    var id : String?
    
    // Required  -  must exist in Json
    var manufacturer: String = ""
    var height: Double = 0.0
    var weight: Int = 0
    var cabriolet: Bool = false
    var doors: UInt = 0
    var maxSpeed: Float = 0.0
    var buildDate: NSDate = NSDate()
    var url = NSURL()

    // Json array of strings
    var upgrades: [String]?
    
    // Json array of numbers
    var pcodes: [Int] = []

    // Json nested object
    var engine: Engine = Engine()
    class Engine: Jsonable {
        var cooling: String = ""
        var torque: Double = 0.0
        var horsePower: Int = 0
        var turbo: Bool = false
    }
    
    // Json array of objects
    var gauges: [Gauge] = []
    class Gauge: Jsonable {
        var name: String = ""
        var max: Double = 0.0
        var size: Int = 0
        var analog: Bool = false
    }
}

