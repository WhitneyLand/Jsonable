
Jsonable
==
Use Swift classes to read and write JSON.

Benefits
-
- No special syntax required.  Forget having to do ["property"]
- No manual configuration, just inherit from Jsonable
- Serialize/Deserialize to JSON text, dictionary, or console

Example
-
> class Photo : Jsonable {      
> &nbsp;&nbsp;var id: Int = 0  
> &nbsp;&nbsp;var title: String = ""  
> &nbsp;&nbsp;var url = NSURL()  
> &nbsp;&nbsp;override class func urlName() -> String { return "photos" }  
}  

> var photo = Photo()  
> photo.id = 1  
> photo.title = "A day at the beach..."  
> photo.url = NSURL(string: "https://whitneyland.com/photo.jpg")!  
> photo.toJsonString()  

Getting Started
-
Download the XCode project and run the demo.  
To use in your own project copy files from JsonableFiles folder.  

Requirements
-
XCode 6.1   
iOS 8.1  