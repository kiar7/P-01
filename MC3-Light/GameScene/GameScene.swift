//
//  GameScene.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 20/02/23.
//

import SpriteKit
import GameplayKit

struct CollisionBitMask {
    static let playerCategory:UInt32 = 1
    static let enemyCategory:UInt32 = 2
    static let groundCategory:UInt32 = 3
    static let chargingBoxCategory:UInt32 = 4
    static let itemCatecory:UInt32 = 5
    static let winBoxCategory:UInt32 = 6
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let light = SKLightNode()
    var playerStart : SKSpriteNode!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var player = Player(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 80, height: 80))
    var cameraNode = SKCameraNode()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // TRIGGER
    
    var enemy = Enemy(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 25, height: 25))
    var chargingBox = Trigger.ChargingBox(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 25, height: 25))
    var item = Trigger.Item(sprite: SKSpriteNode(imageNamed: "item"), size: CGSize(width: 50, height: 50))
    var winBox = Trigger.Item(sprite: SKSpriteNode(imageNamed: "WinBox"), size: CGSize(width: 50, height: 50))
    
    // GROUND
    
    var ground : SKSpriteNode!
    
    // LIGHT

    var _scale: CGFloat = 1.0
    var _screenH: CGFloat = 640.0
    var _screenW: CGFloat = 960.0

    var _backgroundSprite1: SKSpriteNode?
    var _backgroundSprite2: SKSpriteNode?
    var _foregroundSprite1: SKSpriteNode?
    var _foregroundSprite2: SKSpriteNode?
    var _ambientColor: UIColor?
    var _lightSprite: SKSpriteNode?
    
    // INPUT
    
    var touchUp: SKSpriteNode!
    var touchDown: SKSpriteNode!
    var touchLeft: SKSpriteNode!
    var touchRight: SKSpriteNode!
    var touchJump: SKSpriteNode!
    
    var isMovingLeft = false
    var isMovingRight = false
    var isJumping = false
    
    // controlla gerarchia sceneDidLoad and didMove
    override func sceneDidLoad()
    {
        self.lastUpdateTime = 0
        setupGround()
        setupPlayer()
        setupChargingBox()
        setupItem()
        setupWinBox()
        CreateInput()

    }
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        // CAMERA
        
        camera = cameraNode
        addChild(cameraNode)
        
        // GESTIONE LUCI
        
       _screenH = view.frame.height
       _screenW = view.frame.width
       _scale = _screenW / 3800
       _ambientColor = UIColor.darkGray
       initBackground()
       initLight()
        
        
        _lightSprite?.position.y = player.sprite.position.y

    }
    
    func setupGround()
    {
        ground = self.childNode(withName: "ground") as? SKSpriteNode
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.name = "ground"
        ground.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        ground.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        ground.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        ground.physicsBody?.isDynamic = false
    }
    
    func setupPlayer()
    {
        player.sprite.size = player.size
        playerStart = self.childNode(withName: "PlayerStart") as? SKSpriteNode
        playerStart.isHidden = true
        player.sprite.position = playerStart.position
        player.sprite.size = player.size
        player.sprite.physicsBody?.categoryBitMask = CollisionBitMask.playerCategory
        player.sprite.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        player.sprite.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        self.lastUpdateTime = 0
        addChild(player.sprite)
    }
    
    func setupChargingBox()
    {
        chargingBox.sprite.size = CGSize(width: 100, height: 100)
        chargingBox.sprite.zPosition = player.sprite.zPosition - 1
        chargingBox.sprite.physicsBody!.isDynamic = true
        chargingBox.sprite.position.y = player.sprite.position.y - 100
        chargingBox.sprite.position.x = player.sprite.position.x + 200
        chargingBox.sprite.physicsBody!.categoryBitMask = CollisionBitMask.chargingBoxCategory
        chargingBox.sprite.physicsBody!.collisionBitMask = CollisionBitMask.playerCategory
        chargingBox.sprite.physicsBody?.affectedByGravity = false
        chargingBox.sprite.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        addChild(chargingBox.sprite)

    }
    
    func setupItem()
    {
        item.sprite.size = CGSize(width: 200, height: 200)
        item.sprite.zPosition = player.sprite.zPosition + 6
        item.sprite.physicsBody!.isDynamic = true
        item.sprite.position.y = player.sprite.position.y
        item.sprite.position.x = player.sprite.position.x + 400
        item.sprite.physicsBody!.categoryBitMask = CollisionBitMask.itemCatecory
        item.sprite.physicsBody!.collisionBitMask = CollisionBitMask.playerCategory
        item.sprite.physicsBody?.affectedByGravity = false
        item.sprite.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        addChild(item.sprite)
    }
    
    func setupWinBox()
    {
        winBox.sprite.size = CGSize(width: 100, height: 100)
        winBox.sprite.zPosition = player.sprite.zPosition
        winBox.sprite.physicsBody!.isDynamic = false
        winBox.sprite.physicsBody?.affectedByGravity = false
        winBox.sprite.position.y = player.sprite.position.y - 100
        winBox.sprite.position.x = player.sprite.position.x + 600
        
        winBox.sprite.physicsBody?.categoryBitMask = CollisionBitMask.winBoxCategory
        winBox.sprite.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        winBox.sprite.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        addChild(winBox.sprite)
    }
    
    func CreateInput()
    {
//        touchUp = SKSpriteNode(imageNamed: "Arrow")
//        touchUp?.size = CGSize(width: 35, height: 35)
//        touchUp?.name = "up"
//        touchUp?.zPosition = 100
//        addChild(touchUp!)
        
//        touchDown = SKSpriteNode(imageNamed: "Arrow")
//        touchDown?.size = CGSize(width: 35, height: 35)
//        touchDown?.name = "down"
//        touchDown?.zRotation = -3.14159
//        touchDown?.zPosition = 100
//        addChild(touchDown!)

        touchLeft = SKSpriteNode(imageNamed: "freccia")
        touchLeft?.size = CGSize(width: 110, height: 110)
        touchLeft?.name = "left"
        touchLeft?.zRotation = 1.5708
        touchLeft?.zPosition = 100
        addChild(touchLeft!)

        touchRight = SKSpriteNode(imageNamed: "freccia")
        touchRight?.size = CGSize(width: 110, height: 110)
        touchRight?.name = "right"
        touchRight?.zRotation = -1.5708
        touchRight?.zPosition = 100
        addChild(touchRight!)
        
        touchJump = SKSpriteNode(imageNamed: "jump")
        touchJump?.size = CGSize(width: 110, height: 110)
        touchJump?.name = "jump"
        touchJump?.zPosition = 100
        addChild(touchJump!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        if (player.canMove)
        {
            if(atPoint(location).name == "left")
            {
                isMovingLeft = true
            }
            
            if(atPoint(location).name == "right")
            {
                isMovingRight = true
            }
            
            if(atPoint(location).name == "jump")
            {
                if(player.nearBoxCharge)
                {
                    player.canMove = false
                    print("nearBox")
                }
                else if (player.nearLadder)
                {
                    print("nearLadder")
                }
                else
                {
                    if(!player.isFalling)
                    {
                        isJumping = true
                        player.isFalling = true
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        isMovingLeft = false
        isMovingRight = false
        isJumping = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5)
        {
            self.player.canMove = true
        }
    }
    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
       
        self.lastUpdateTime = currentTime
        
        if(isMovingLeft == true)
        {
            player.sprite.position.x += -5
            player.sprite.xScale = -1
        }
        
        if(isMovingRight == true)
        {
            player.sprite.position.x += 5
            player.sprite.xScale = 1
        }
        
        if(isJumping == true)
        {
            player.sprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: player.maxJump))
            isJumping = false
        }
        
        cameraNode.position.x = player.sprite.position.x
        cameraNode.position.y = player.sprite.position.y
        
//        touchUp?.position.x = cameraNode.position.x + 0.1
//        touchUp?.position.y = cameraNode.position.y - 90
//
//        touchDown?.position.x = cameraNode.position.x + 0.1
//        touchDown?.position.y = cameraNode.position.y - 140

        touchJump?.position.x = cameraNode.position.x + 550
        touchJump?.position.y = cameraNode.position.y - 240
        
        touchLeft?.position.x = cameraNode.position.x - 550
        touchLeft?.position.y = cameraNode.position.y - 240

        touchRight?.position.x = cameraNode.position.x - 440
        touchRight?.position.y = cameraNode.position.y - 240
        
        _lightSprite?.position.x = player.sprite.position.x
    }
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.node?.name == "player")
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "chargingBox")
        {
            secondBody.collisionBitMask = 0
            firstBody.contactTestBitMask = CollisionBitMask.chargingBoxCategory
            touchJump.texture = SKTexture(imageNamed: "Player")
            player.nearBoxCharge = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5)
            {
                self._lightSprite?.position.y = self.player.sprite.position.y + 100000
            }
            print("contact")
        }
        else if(firstBody.node?.name == "player" && secondBody.node?.name == "ground")
        {
            print("ground")
            player.isFalling = false
        }
        else if(firstBody.node?.name == "player" && secondBody.node?.name == "item")
        {
            print("HO RACCOLTO L'ITEM")
            item.sprite.removeFromParent()
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "winBox")
        {
            print("HO FOTTUTAMENTE VINTO")
        }
        if(firstBody.node?.name == "winBox" && secondBody.node?.name == "player")
        {
            print("HO FOTTUTAMENTE VINTO")
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact)
    {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.node?.name == "player")
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "chargingBox")
        {
            secondBody.collisionBitMask = CollisionBitMask.chargingBoxCategory
            firstBody.collisionBitMask = CollisionBitMask.playerCategory
            firstBody.contactTestBitMask = CollisionBitMask.playerCategory
            touchJump.texture = SKTexture(imageNamed: "jump")
            player.nearBoxCharge = false
            print("contact")
        }
        else if(firstBody.node?.name == "player" && secondBody.node?.name == "ground")
        {
            print("ground")
        }
    }
}

// ------------------------------------------ E LUCE FU -------------------------------------------------------------

extension GameScene
{
    
    fileprivate func initBackground()
    {
        backgroundColor = SKColor.black
        _backgroundSprite1 = addBackgroundTile(spriteFile: "/Users/mischio/Documents/GitHub/MC3LC/MC3-Light/Sprites/ciccio.png");
        _foregroundSprite1 = addForegroundTile(spriteFile: "/Users/mischio/Documents/GitHub/MC3LC/MC3-Light/Sprites/background.png", normalsFile:"/Users/mischio/Documents/GitHub/MC3LC/MC3-Light/Sprites/normalTest.png")
    }
    
    fileprivate func addBackgroundTile(spriteFile: String) -> SKSpriteNode
    {
        
        var background:SKSpriteNode

        background = SKSpriteNode(imageNamed:spriteFile);
        background.color = _ambientColor!
        background.colorBlendFactor = 1
        background.zPosition = -1
        background.alpha = 1
        background.anchorPoint = CGPoint(x:0, y:0.5)
        background.setScale(_scale)
        addChild(background);
        
        return background;
    }
    
    fileprivate func addForegroundTile(spriteFile: String, normalsFile: String) -> SKSpriteNode {
        var foreground:SKSpriteNode
        
        foreground = SKSpriteNode(texture: SKTexture(imageNamed:spriteFile), normalMap: SKTexture(imageNamed:normalsFile));
        foreground.lightingBitMask = 1
        foreground.color = _ambientColor!
        foreground.colorBlendFactor = 1
//        foreground.alpha = 1
        foreground.zPosition = -1
        foreground.anchorPoint = CGPoint(x:0, y:0.5)
        foreground.setScale(_scale * 2)
        addChild(foreground)
        
        return foreground
    }
    
    fileprivate func initLight() {
        _lightSprite = SKSpriteNode(imageNamed: "/Users/mischio/Documents/GitHub/MC3LightY/MC3-Light/Sprites/lightbulb.png")
        _lightSprite?.setScale(_scale * 50)
        _lightSprite?.position = CGPoint(x: _screenW - 100, y: _screenH - 100)
        _lightSprite?.size = CGSize(width: 0.1, height: 0.1)
        addChild(_lightSprite!)
        
        
        light.position = .zero
        light.falloff = 1
        light.ambientColor = _ambientColor!
        light.lightColor = .white
        

        //light.shadowColor = .black
        
        _lightSprite?.addChild(light)
    }
}


