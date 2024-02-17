import UIKit



class Point: CustomStringConvertible {
    var description: String {
        return "x:\(x) y:\(y)"
    }

    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

/// adapt to prottoype pattern
extension Point: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Point(x: self.x, y: self.y)
    }
}


var p1 = Point(x: 10, y: 15)
var p2 = p1.copy() as! Point

p2.x = 12
p2.y = 22





/// Shallow copy sample
class Point2: CustomStringConvertible, NSCopying {
    var description: String {
        return "x:\(x) y:\(y) shape: \(shape)"
    }

    var x: Int
    var y: Int
    var shape: Shape2

    init(x: Int, y: Int, shape: Shape2) {
        self.x = x
        self.y = y
        self.shape = shape
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Point2(x: self.x, y: self.y, shape: self.shape)
    }
}


class Shape2: CustomStringConvertible {
    var description: String {
        return "type: \(type) size: \(size)"
    }
    
    var type: String
    var size: Int

    init(type: String, size: Int) {
        self.type = type
        self.size = size
    }
    
    
}

var pp1 = Point2(x: 10, y: 15, shape: Shape2(type: "Circle", size: 15))
var pp2 = pp1.copy() as! Point2


pp2.x = 100
pp2.shape.size = 100
pp2.shape.type = "Rectangle"


print("p1: \(pp1)")
print("p2: \(pp2)")


class Point3: CustomStringConvertible, NSCopying {
    var description: String {
        return "x:\(x) y:\(y) shape: \(shape)"
    }

    var x: Int
    var y: Int
    var shape: Shape3

    init(x: Int, y: Int, shape: Shape3) {
        self.x = x
        self.y = y
        self.shape = shape
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Point3(x: self.x, y: self.y, shape: self.shape)
    }
}


class Shape3: CustomStringConvertible, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Shape3(type: self.type, size: self.size)
    }
    
    var description: String {
        return "type: \(type) size: \(size)"
    }
    
    var type: String
    var size: Int

    init(type: String, size: Int) {
        self.type = type
        self.size = size
    }
}

var ppp1 = Point2(x: 10, y: 15, shape: Shape2(type: "Circle", size: 15))
var ppp2 = pp1.copy() as! Point2


ppp2.x = 100
ppp2.shape.size = 100
ppp2.shape.type = "Rectangle"


print("p1: \(ppp1)")
print("p2: \(ppp2)")

