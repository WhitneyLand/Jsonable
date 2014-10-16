//
//  User.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/16/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import Foundation

class User : Jsonable {
    
    override class func urlName() -> String { return "users" }
    override class func createInstance() -> Jsonable { return User() }
    
    var id = 0
    var name = ""
    var username = ""
    var email = ""
    var phone = ""
    var website = ""
    
    var address = Address()
    class Address: Jsonable {
        var street = ""
        var suite = ""
        var city = ""
        var zipcode = ""
        
        var geo = Geo()
        class Geo : Jsonable {
            var lat = 0.0
            var lng = 0.0
        }
    }
    
    var company = Company()
    class Company: Jsonable {
        var name = ""
        var catchPhrase = ""
        var bs = ""
    }
}

