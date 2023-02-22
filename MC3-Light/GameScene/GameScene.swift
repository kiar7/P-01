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
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerStart : SKSpriteNode!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var player = Player(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 80, height: 80))
    var cameraNode = SKCameraNode()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    var enemy = Enemy(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 25, height: 25))
    
    var chargingBox = Trigger.ChargingBox(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 25, height: 25))
    
    // GROUND
    
    var ground : SKSpriteNode!
    
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
        sceneSetup()
        setupPlayer()
        setupChargingBox()
    }
    
    
    override func didMove(to view: SKView) {
        print("didMove")
        self.physicsWorld.contactDelegate = self
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
        CreateInput()

    }
    
    func setupChargingBox()
    {
        chargingBox.sprite.size = CGSize(width: 500, height: 100)
        chargingBox.sprite.zPosition = player.sprite.zPosition - 1
        chargingBox.sprite.physicsBody!.isDynamic = true
        chargingBox.sprite.position.y = player.sprite.position.y - 100
        chargingBox.sprite.position.x = player.sprite.position.x + 200
        chargingBox.sprite.physicsBody!.categoryBitMask = CollisionBitMask.chargingBoxCategory
        chargingBox.sprite.physicsBody!.collisionBitMask = CollisionBitMask.playerCategory
        chargingBox.sprite.physicsBody?.affectedByGravity = false
        chargingBox.sprite.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
    }
    
    func sceneSetup()
    {
        
        addChild(player.sprite)

        addChild(cameraNode)
        camera = cameraNode
        
        addChild(chargingBox.sprite)
       setupGround()
        
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
//
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
    
//    func touchDown(atPoint pos : CGPoint) {
//    }
    
//    func touchMoved(toPoint pos : CGPoint) {
//    }
    
//    func touchUp(atPoint pos : CGPoint) {
//    }
    
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
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    override func update(_ currentTime: TimeInterval) {
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
//
        touchJump?.position.x = cameraNode.position.x + 550
        touchJump?.position.y = cameraNode.position.y - 240
        
        touchLeft?.position.x = cameraNode.position.x - 550
        touchLeft?.position.y = cameraNode.position.y - 240

        touchRight?.position.x = cameraNode.position.x - 440
        touchRight?.position.y = cameraNode.position.y - 240
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.node?.name == "player")
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            print("A")
        } else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            print("B")
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "chargingBox")
        {
            secondBody.collisionBitMask = 0
            firstBody.contactTestBitMask = CollisionBitMask.chargingBoxCategory
            touchJump.texture = SKTexture(imageNamed: "Player")
            player.nearBoxCharge = true
            print("contact")
        }
        else if(firstBody.node?.name == "player" && secondBody.node?.name == "ground")
        {
            print("ground")
            player.isFalling = false
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.node?.name == "player")
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            print("A")
        } else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            print("B")
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