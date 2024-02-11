import UIKit
/// Making sample from pluralisght course

public protocol Message {
    var name: String { get }
}

public struct ResponseMessage : Message {
    public var name: String
}

public protocol MessageProcessing {
    init(next: MessageProcessing?)
    func process(message: Message)
    
    var messageIds: [String]? {get}
    
}


public struct XMLProccessor: MessageProcessing, CustomStringConvertible {
    fileprivate var nextProccesor: MessageProcessing?
    
    public init(next: MessageProcessing?) {
        nextProccesor =  next
    }
    
    public func process(message: Message) {
        print(message.name)
        print(messageIds)
        guard let shouldProccess = messageIds?.contains(where: {$0 == message.name}), shouldProccess == true else {
            if let next = nextProccesor {
                print("forwarding next procces \(next)")
                next.process(message: message)
                return
            }
            
            print("next response not found and reched end of responder chain")
            
            return }
        
        print("Proccesed by xml")
    }
    
    public var messageIds: [String]? {
        return ["XML"]
    }
    
    public var description: String {
        return "XML PROCESS"
    }
}



public struct JSONProccessor: MessageProcessing, CustomStringConvertible {
    fileprivate var nextProccesor: MessageProcessing?
    
    public init(next: MessageProcessing?) {
        nextProccesor =  next
    }
    
    public func process(message: Message) {
       
        guard let shouldProccess = messageIds?.contains(where: { $0 == message.name }), shouldProccess == true else {
            if let next = nextProccesor {
                print("forwarding next procces \(next)")
                next.process(message: message)
                return
            }
            
            print("next response not found and reched end of responder chain")
            
            return }
        
        print("Proccesed by xml")
    }
    
    public var messageIds: [String]? {
        return ["JSON"]
    }
    
    public var description: String {
        return "JSONProccessor PROCESS"
    }
}



public struct ENDProccessor: MessageProcessing {
    fileprivate var nextProccesor: MessageProcessing?
    
    public init(next: MessageProcessing?) {
       
    }
    
    public func process(message: Message) {
        print("next response not found and reched end of responder chain")
    }
    
    public var messageIds: [String]?
}


let responseMessage = ResponseMessage(name: "XML")


let responseEndChaing = ENDProccessor(next: nil)
let jsonResponser = JSONProccessor(next: responseEndChaing)
let xmlResponse = XMLProccessor(next: jsonResponser)
xmlResponse.process(message: responseMessage)
