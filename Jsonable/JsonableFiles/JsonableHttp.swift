//
//  JsonableHttp.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//

import Foundation

class Http {

    func get(url: NSURL, completionHandler: ((result: HttpResult) -> Void)!) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            let httpResponse: NSHTTPURLResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
            }
            else {
                println("Http.get failed network: \(httpResponse.statusCode) \(httpResponse.URL)")
            }
            var result = HttpResult(data: data, response: httpResponse, error: error)
            completionHandler(result: result)
        }
        task.resume()
    }
    
    func post(url: NSURL, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        
        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = "POST"

        let task = NSURLSession.sharedSession().uploadTaskWithRequest(httpRequest, fromData: data) { (data, response, error) in

            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
            }
            else {
                println("Http.post failed network: \(httpResponse.statusCode) \(httpResponse.URL)")
            }
            completionHandler(result: HttpResult(data: data, response: httpResponse, error: error))
        }
        task.resume()
    }
}

class HttpResult {
    
    var response: NSHTTPURLResponse?
    var data: NSData?
    var error: NSError?
    var statusCode: Int = 0
    var success: Bool = false
    init(data: NSData?, response: NSHTTPURLResponse?, error : NSError?) {
        self.data = data
        self.response = response
        self.error = error
        
        statusCode = response!.statusCode
        
        if error == nil && statusCode >= 200 && statusCode < 300 {
            success = true
        }
        else {
            success = false
        }
    }
    
    var text : String {
        get {
            var s = ""
            s += "Status: \(statusCode)\n"
            s += "Data: \(NSString(data: data!, encoding:NSUTF8StringEncoding)!)"
            return s
        }
    }
}