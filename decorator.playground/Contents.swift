import UIKit

var greeting = "Hello, playground"

protocol Camera: CustomStringConvertible {
    var price: Float { get }
}


class MirrorlessCamera: Camera {
    var price: Float {
        return 500
    }
    var description: String {
        return "Mirrorless Camera"
    }
}

class CompactCamera: Camera {
    var price: Float = 300
    var description: String {
        return "Compact Camera"
    }
}


class DSLRCamera: Camera {
    var price: Float = 700
    var description: String {
        return "DSLR Camera"
    }
}

struct FeaturePrice {
    static let viewFinder: Float = 75
    static let lcd: Float = 50
    static let videoCapture: Float = 100
}


class MirrorlessWithViewFinder: MirrorlessCamera {
    override var price: Float {
        return super.price + FeaturePrice.viewFinder
    }
    override var description: String {
        return super.description + " with ViewFinder"
    }
}

class MirrorlessWithLCD: MirrorlessCamera {
    override var price: Float {
        return super.price + FeaturePrice.lcd
    }
    override var description: String {
        return super.description + " with LCD"
    }
}


class MirrorlessWithVideoCapture: MirrorlessCamera {
    override var price: Float {
        return super.price + FeaturePrice.videoCapture
    }
    override var description: String {
        return super.description + " with VideoCapture"
    }
}


let baseMirrorless = MirrorlessCamera()
print(baseMirrorless.description + " - \(baseMirrorless.price)")

let mirrorlessWithViewFinder = MirrorlessWithViewFinder()
print(mirrorlessWithViewFinder.description + " - \(mirrorlessWithViewFinder.price)")

let mirrorlessWithLCD = MirrorlessWithLCD()
print(mirrorlessWithLCD.description + " - \(mirrorlessWithLCD.price)")


/// after decorator pattern


protocol CameraDecorator: Camera {
    var wrapped: Camera { get }
    init(wrapped: Camera)
}

extension CameraDecorator {
    var price: Float {
        return wrapped.price
    }

    var description: String {
        return wrapped.description
    }
}


struct LCDDecorator: CameraDecorator {
    var wrapped: Camera
    init(wrapped: Camera) {
        self.wrapped = wrapped
    }
    var price: Float {
        return wrapped.price + FeaturePrice.lcd
    }
    var description: String {
        return wrapped.description + " with LCD"
    }
}

struct ViewFinderDecorator: CameraDecorator {
    var wrapped: Camera
    init(wrapped: Camera) {
        self.wrapped = wrapped
    }
    var price: Float {
        return wrapped.price + FeaturePrice.viewFinder
    }
    var description: String {
        return wrapped.description + " with ViewFinder"
    }
}

struct VideoCaptureDecorator: CameraDecorator {
    var wrapped: Camera
    init(wrapped: Camera) {
        self.wrapped = wrapped
    }
    var price: Float {
        return wrapped.price + FeaturePrice.videoCapture
    }
    var description: String {
        return wrapped.description + " with VideoCapture"
    }
}

print("---Decororeter---")
var camera: Camera = MirrorlessCamera()


print(camera.description + " - \(camera.price)")
camera = LCDDecorator(wrapped: camera)
print(camera.description + " - \(camera.price)")


camera = VideoCaptureDecorator(wrapped: camera)
print(camera.description + " - \(camera.price)")

camera = ViewFinderDecorator(wrapped: camera)
print(camera.description + " - \(camera.price)")


