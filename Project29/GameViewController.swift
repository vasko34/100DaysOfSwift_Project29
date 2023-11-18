import UIKit
import SpriteKit

class GameViewController: UIViewController {
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var windStrengthLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    var currentGame: GameScene?
    var score1 = 0 {
        didSet {
            scoreLabel.text = "Player1: \(score1) | Player2: \(score2)"
        }
    }
    var score2 = 0 {
        didSet {
            scoreLabel.text = "Player1: \(score1) | Player2: \(score2)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        createWind()
        angleChanged(self)
        velocityChanged(self)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launchTapped(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        launchButton.isHidden = true
        windStrengthLabel.isHidden = true
        windDirectionLabel.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        launchButton.isHidden = false
        windStrengthLabel.isHidden = false
        windDirectionLabel.isHidden = false
    }
    
    func createWind() {
        let windStrength: Int
        
        if Bool.random() {
            windDirectionLabel.text = "Wind Direction: ->"
            windStrength = Int.random(in: 1...3)
        } else {
            windDirectionLabel.text = "Wind Direction: <-"
            windStrength = -Int.random(in: 1...3)
        }
        
        if abs(windStrength) == 1 {
            windStrengthLabel.text = "Wind Strength: Low"
        } else if abs(windStrength) == 2 {
            windStrengthLabel.text = "Wind Strength: Medium"
        } else {
            windStrengthLabel.text = "Wind Strength: High"
        }
        
        currentGame?.physicsWorld.gravity.dx += CGFloat(windStrength)
    }
}
