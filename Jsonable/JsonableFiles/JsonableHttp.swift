//
//  JsonableHttp.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//

import Foundation

class JsonHttpResult {

    var response: NSHTTPURLResponse?
    var data : NSData?
    var error : NSError?
    var success : Bool
    init(data : NSData?, response: NSHTTPURLResponse?, error : NSError?) {
        self.data = data
        self.response = response
        self.error = error
        
        if error != nil && response!.statusCode == 200 {
            success = true
        }
        else {
            success = false
        }
    }
    
    var text : String {
        get {
            var s = NSString(data: data!, encoding:NSUTF8StringEncoding)
            return s!
        }
    }
}

class JsonHttp {
    
    var data: AnyObject?
    
    init() {
    }

    func Post(url: NSURL, jsonObject:AnyObject, completionHandler: ((result: JsonHttpResult) -> Void)!) {
        
        var jsonError: NSError?
        var data = NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted, error: &jsonError)
        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = "POST"

        let task = NSURLSession.sharedSession().uploadTaskWithRequest(httpRequest, fromData: data) { (data, response, error) in

            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
            }
            else {
                println("JsonHttp.Post failed network: \(httpResponse.statusCode) \(httpResponse.URL)")
            }
            completionHandler(result: JsonHttpResult(data: data, response: httpResponse, error: error))
        }

        task.resume()
    }
    
    //
    // Load data from server API
    //
    func Get(url: NSURL, completionHandler: ((result: JsonHttpResult) -> Void)!) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            let httpResponse: NSHTTPURLResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
                var jsonError: NSError?
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                    options: .AllowFragments,
                    error: &jsonError)
                    as AnyObject!
                
                if let json: AnyObject = jsonObject {
                    self.data = json
                }
                else {
                    println("JsonHttp.Get failed data: \(httpResponse.statusCode) \(httpResponse.URL)")
                }
            }
            else {
                println("JsonHttp.Get failed network: \(httpResponse.statusCode) \(httpResponse.URL)")
            }
            completionHandler(result: JsonHttpResult(data: data, response: httpResponse, error: error))
        }
        task.resume()
    }
}
