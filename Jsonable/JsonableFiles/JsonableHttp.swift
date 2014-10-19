//
//  JsonableHttp.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//

import Foundation

class Http {

    func get(url: NSURL, headers: Dictionary<String, String>, completionHandler: ((result: HttpResult) -> Void)!) {

        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = "GET"

        for (headerKey, headerValue) in headers {
            httpRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(httpRequest) { (data, response, error) in
            
            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
            }
            else {
                println("Http.\(httpRequest.HTTPMethod) failed: \(httpResponse.statusCode) \(httpResponse.URL)")
            }
            var result = HttpResult(data: data, response: httpResponse, error: error)
            completionHandler(result: result)            
        }
        task.resume()
    }
    
    func post(url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        
        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = "POST"

        for (headerKey, headerValue) in headers {
            httpRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(httpRequest, fromData: data) { (data, response, error) in

            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
            }
            else {
                println("Http.\(httpRequest.HTTPMethod) failed: \(httpResponse.statusCode) \(httpResponse.URL)")
            }
            completionHandler(result: HttpResult(data: data, response: httpResponse, error: error))
        }
        task.resume()
    }
    
    func put(url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        
        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = "PUT"
        
        for (headerKey, headerValue) in headers {
            httpRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(httpRequest, fromData: data) { (data, response, error) in
            
            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
            }
            else {
                println("Http.\(httpRequest.HTTPMethod) failed: \(httpResponse.statusCode) \(httpResponse.URL)")
            }
            completionHandler(result: HttpResult(data: data, response: httpResponse, error: error))
        }
        task.resume()
    }
    
    func delete(url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        
        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = "DELETE"
        
        for (headerKey, headerValue) in headers {
            httpRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(httpRequest, fromData: data) { (data, response, error) in
            
            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
            }
            else {
                println("Http.\(httpRequest.HTTPMethod) failed: \(httpResponse.statusCode) \(httpResponse.URL)")
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
    var headers : Dictionary<String, String> {
        get {
            var headerDictionary = response?.allHeaderFields as Dictionary<String,String>
            return headerDictionary
        }
    }
    
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
