//
//  Test.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/17/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//

import Foundation

class TestEntity : Jsonable {
    
    override class func urlName() -> String { return "Entities" }
    override class func createInstance() -> Jsonable { return TestEntity() }
    
    var id = 0
    var title = ""

    var phone = Phone()
    class Phone {
        var home: String = ""
        var cell: String = ""
    }
    
    var engine: Engine = Engine()
    class Engine: Jsonable {
        var cooling: String = ""
        var torque: Double = 0.0
        var horsePower: Int = 0
        var turbo: Bool = false
    }
}