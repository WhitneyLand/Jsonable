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
    
    var car = Car()
    var photos = SampleApi<Photo>()
    var users = SampleApi<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func getJson_TouchUp(sender: AnyObject) {
        
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
        
        //jsonView.text = car.description        
        jsonView.text = car.toJsonString()
    }

    @IBAction func getSwift_TouchUp(sender: AnyObject) {
        
        users.get(1) { (result) in
            
            println(result.text)
            
            if result.success {
                dispatch_async(dispatch_get_main_queue(), {     // Run UI code on main thread
                    
                    var user = self.users[0]
                    self.swiftView.text = user.description
                })
            }
        }
    }
    
    func test() {
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

