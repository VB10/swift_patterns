import UIKit


protocol Sharing {
    @discardableResult
    func post(message: String) -> Bool
}

struct FBSharer: Sharing {
    func post(message: String) -> Bool {
        print("Message \(message) shared to facebook")
        return true
    }
}

struct TwitterSharer: Sharing {
    func post(message: String) -> Bool {
        print("Message \(message) shared to twitter")
        return true
    }
}

enum Platfrom: CustomStringConvertible {
    var description: String {
        switch self {
        case .facebook:
            return "Facebook Sharer"
        case .twitter:
            return "Twitter Sharer"
        case .reddit:
            return "Reddit Sharer"
        }
    }
    
    case facebook
    case twitter
    case reddit
}


class Sharer {
    private let services: [Platfrom: Sharing] = [
        .facebook: FBSharer(),
        .twitter: TwitterSharer(),
        .reddit: RedditPoster()
    ]
    
    func share(message:String, platform: Platfrom) -> Bool {
        guard let service = services[platform] else { return false }
        
        let result = service.post(message: message)
        return result
    }
    
    func shareEveryWhere(message: String) {
        services.values.forEach { service in
            service.post(message: message)
        }
    }
}


struct RedditPoster {
    
    func share(message:String, onComplete: (()->Void)?) {
        print("shared reddit")
    }
}


extension RedditPoster: Sharing{
    func post(message: String) -> Bool {
        self.share(message: message, onComplete: nil)
        return true
    }
}
