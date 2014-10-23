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
            completionHandler(result: HttpResult(data: data, request: httpRequest, response: response, error: error))
        }
        task.resume()
    }
    
    func post(url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        action("POST", url: url, headers: headers, data: data ) { (result) in
            completionHandler(result: result)
        }
    }
    
    func put(url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        action("PUT", url: url, headers: headers, data: data ) { (result) in
            completionHandler(result: result)
        }
    }
    
    func delete(url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        action("DELETE", url: url, headers: headers, data: data ) { (result) in
            completionHandler(result: result)
        }
    }
    
    func action(verb: String, url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = verb
        
        for (headerKey, headerValue) in headers {
            httpRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(httpRequest, fromData: data) { (data, response, error) in
            completionHandler(result: HttpResult(data: data, request: httpRequest, response: response, error: error))
        }
        task.resume()
    }
}

class HttpResult {
    
    var request: NSURLRequest
    var response: NSHTTPURLResponse?
    var data: NSData?
    var error: NSError?
    var statusCode: Int = 0
    var success: Bool = false
    var headers : Dictionary<String, String> {
        get {
            if let responseValue = response {
                return responseValue.allHeaderFields as Dictionary<String,String>
            }
            else {
                return Dictionary<String, String>()
            }
        }
    }
    
    init() {
        request = NSURLRequest()
    }
    
    init(data: NSData?, request: NSURLRequest, response: NSURLResponse?, error : NSError?) {
        self.data = data
        self.request = request
        self.response = response as NSHTTPURLResponse?
        self.error = error
        self.success = false
        
        if error != nil {
            println("Http.\(request.HTTPMethod!): \(request.URL)")
            println("Error: \(error!.localizedDescription)")
        }
        else {
            if let responseValue = self.response {
                statusCode = responseValue.statusCode
                if statusCode >= 200 && statusCode < 300 {
                    success = true
                }
                else {
                    println("Http.\(request.HTTPMethod!) \(request.URL)")
                    println("Status: \(statusCode)")
                    if let jsonError: AnyObject = jsonObject {
                        
                        // TODO: better way to make escaped/nested json look better?
                        var err: NSError?
                        var errData = NSJSONSerialization.dataWithJSONObject(jsonError, options:NSJSONWritingOptions.PrettyPrinted, error: &err)
                        var errMessage = NSString(data: errData!, encoding: NSUTF8StringEncoding)
                        var s: String = errMessage!
                        s = s.replace("\\n", withString:"\n")
                        s = s.replace("\\t", withString:"  ")
                        s = s.replace("\\\"", withString:"\"")
                        println("Error: \(s)")
                    }
                }
            }
        }
    }
    
    var jsonObject: AnyObject? {
        var resultJsonObject: AnyObject?
        var jsonError: NSError?
        if let contentType = headers["Content-Type"] {
            if contentType.contains("application/json") {
                resultJsonObject = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: &jsonError) as AnyObject?
            }
        }
        return resultJsonObject
    }
    
    var text : String {
        get {
            var s = ""
            s += "Http.\(request.HTTPMethod!): \(request.URL)\n"
            s += "Status: \(statusCode)\n"
            if let dataValue = data {
                s += "Data:\n"
                s += "\(NSString(data: dataValue, encoding:NSUTF8StringEncoding)!)"
            }
            else {
                s += "Data: nil"
            }
            return s
        }
    }
}
