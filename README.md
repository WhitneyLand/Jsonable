
Jsonable
==
Use Swift classes to read and write JSON.

Benefits
-
- No special syntax required.  Forget having to do this ["property"].
- No manual configuration, just inherit from Jsonable
- Serialize/Deserialize to JSON text, dictionary, or console

Example
-
class Photo : Jsonable {    
var id: Int = 0
var title: String = ""
var url = NSURL()
override class func urlName() -> String { return "photos" }
}

var photo = Photo()
photo.id = 1
photo.title = "A day at the beach..."
photo.url = NSURL(string: "")!
photo.toJsonString()

Getting Started
-
Download the XCode project and run the demo.
To use in your own project copy files from JsonableFiles folder.

Requirements
-
XCode 6.1 
iOS 8.1