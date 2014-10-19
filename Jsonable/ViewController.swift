//
//  ViewController.swift
//  Jsonable
//
//  Created by Lee Whitney on 10/15/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//
import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var jsonView: UITextView!
    @IBOutlet weak var swiftView: UITextView!
    @IBOutlet weak var getJsonButton: UIButton!
    @IBOutlet weak var getSwiftButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //--------------------------------------------------
    //  Convert a Swift object to JSON
    //
    @IBAction func getJson_TouchUp(sender: AnyObject) {

        var car = Car()
        
        car.manufacturer = "Porche"
        car.height = 51.02
        car.weight = 3538
        car.cabriolet = true
        car.doors = 2
        car.maxSpeed = 197
        car.buildDate = NSDate(iso: "2014-09-19T07:22:00Z")
        car.url = NSURL(string: "http://whitneyland.com")!
        
        car.upgrades = ["Leather Dashboard", "Sport Chrono"]
        
        car.engine = Car.Engine()
        car.engine.cooling = "Water"
        car.engine.torque = 516.2
        car.engine.horsePower = 560
        car.engine.turbo = true
        
        var carGuage1 = Car.Gauge()
        carGuage1.name = "Spedometer"
        carGuage1.max = 200
        carGuage1.size = 4
        carGuage1.analog = true
        car.gauges.append(carGuage1)
        
        var carGuage2 = Car.Gauge()
        carGuage2.name = "Tachometer"
        carGuage2.max = 9000
        carGuage2.size = 6
        carGuage2.analog = true
        car.gauges.append(carGuage2)
        
        jsonView.text = car.toJsonString()
    }

    //---------------------------------------------------
    //  Convert JSON to a Swift object
    //
    @IBAction func getSwift_TouchUp(sender: AnyObject) {
        
        var json = String(sep:" ",
            "{",
            "    \"cabriolet\": true,",
            "    \"maxSpeed\": 197,",
            "    \"doors\": 2,",
            "    \"url\": \"http://whitneyland.com\",",
            "    \"weight\": 3538,",
            "    \"engine\": {",
            "        \"horsePower\": 560,",
            "        \"turbo\": true,",
            "        \"torque\": 516.2,",
            "        \"cooling\": \"Water\"",
            "    },",
            "    \"gauges\": [",
            "        {",
            "            \"size\": 4,",
            "            \"analog\": true,",
            "            \"name\": \"Spedometer\",",
            "            \"max\": 200",
            "        },",
            "        {",
            "            \"size\": 6,",
            "            \"analog\": true,",
            "            \"name\": \"Tachometer\",",
            "            \"max\": 9000",
            "        }",
            "    ],",
            "    \"manufacturer\": \"Porche\",",
            "    \"height\": 51.02,",
            "    \"upgrades\": [",
            "        \"Leather Dashboard\",",
            "        \"Sport Chrono\"",
            "    ],",
            "    \"pcodes\": [],",
            "    \"buildDate\": \"2014-09-19T02:22:00-05:00\"",
            "}")
        
        var car = Car()
        car.fromJsonString(json)
        swiftView.text = car.description
    }

    //---------------------------------------------
    // Use swift classes in API
    //
    var photos = SampleApi<Photo>()
    var users = SampleApi<User>()
    
    func apiTests() {
        
        users.get(1) { (result) in
            
            println(result.text)
            
            if result.success {
                dispatch_async(dispatch_get_main_queue(), {     // Run UI code on main thread
                    
                    var user = self.users[0]
                    self.swiftView.text = user.description
                })
            }
        }
/*
        photos.get() { (result) in
            
            dispatch_async(dispatch_get_main_queue(), {     // Run UI code on main thread
                for photo in self.photos {
                    println(photo.description)
                }
            })
        }

        println(car.toJsonString())
        println()
        var tests = SampleApi<TestEntity>()
        var test = TestEntity()
        var text = test.toJsonString()
        println(text)
*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

