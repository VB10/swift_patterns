import UIKit
import PlaygroundSupport


final class GameScene {
    private var score: UInt
    private var progress: Float
    private var sessionTime: TimeInterval

    init() {
        self.score = 0
        self.progress = 0
        self.sessionTime = 0
    }

    lazy var sessionTimer = Timer.init(timeInterval: 1, repeats: true) { [weak self] timer in
        self?.sessionTime += timer.timeInterval
    }

    func start() {
        RunLoop.current.add(sessionTimer, forMode: .default)
        sessionTimer.fire()
    }

    public var levelScore: UInt {
        get {
            return score
        }
        set {
            score = newValue
        }
    }

    public var levelProgress: Float {
        get {
            return progress
        }
        set {
            progress = newValue <= 100 ? newValue : 100
        }
    }
}

extension GameScene: CustomStringConvertible {
    var description: String {
        return "Score: \(score), Progress: \(progress), Session Time: \(sessionTime)"
    }
}



protocol Momento {
    associatedtype State
    var state: State { get set }
}


protocol Orginator {
    associatedtype M: Momento
    func createMomento() -> M
    func apply(from momento: M)
}


protocol Caretaker {

    associatedtype O: Orginator
    func saveState(orginator: O, identifier: AnyHashable)
    func restoreState(orginator: O, identifier: AnyHashable)
}


struct GameMomento: Momento {
    var state: ExternalGameState
}

struct ExternalGameState {
    var playerScore: UInt
    var levelProgress: Float
}

extension GameScene: Orginator {
    func createMomento() -> GameMomento {
        let currentState = ExternalGameState(playerScore: score, levelProgress: progress)
        return GameMomento(state: currentState)
    }

    func apply(from momento: GameMomento) {
        let restoreState = momento.state

        self.levelScore = restoreState.playerScore
        self.progress = restoreState.levelProgress
    }
}


final class GameSceneManager: Caretaker {



    private lazy var snapshots = [AnyHashable: GameMomento] ()

    func saveState(orginator: GameScene, identifier: AnyHashable) {
        let snapshot = orginator.createMomento()
        snapshots[identifier] = snapshot
    }
    
    func restoreState(orginator: GameScene, identifier: AnyHashable) {
        guard let snapshot = snapshots[identifier] else { return }
        orginator.apply(from: snapshot)
    }
    
    public init() {
        
    }
}


let gameScene = GameScene()

gameScene.start()


let sceneManager = GameSceneManager()
sceneManager.saveState(orginator: gameScene, identifier: "initial")
print("Game state: \(gameScene)")


DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    gameScene.levelScore = 100
    gameScene.levelProgress = 50
    sceneManager.saveState(orginator: gameScene, identifier: "snapshot1")
    print("Game state: \(gameScene)")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        gameScene.levelScore = 200
        gameScene.levelProgress = 100
        sceneManager.saveState(orginator: gameScene, identifier: "snapshot2")

        print("Game state: \(gameScene)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sceneManager.restoreState(orginator: gameScene, identifier: "initial")
            print("Game state to restoring initial: \(gameScene)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                sceneManager.restoreState(orginator: gameScene, identifier: "snapshot1")
                print("Game state to restoring snapshot1: \(gameScene)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    sceneManager.restoreState(orginator: gameScene, identifier: "snapshot2")
                    print("Game state to restoring snapshot2: \(gameScene)")
                    
                    PlaygroundPage.current.finishExecution()
                }
            }
        }
    }
}


PlaygroundPage.current.needsIndefiniteExecution = true
