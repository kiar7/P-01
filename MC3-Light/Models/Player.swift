//
//  Player.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 21/02/23.
//

import SpriteKit
class Player {
    
    var sprite: SKSpriteNode
    var size: CGSize
    var maxJump: Float = 100
    var canMove: Bool = true
    var isFalling:Bool = false
    var lightIsOn: Bool = false
    
    var nearBoxCharge:Bool = false
    var nearLadder:Bool = false
    var isCharging:Bool = false
    var isOnLadder:Bool = false

    init(sprite: SKSpriteNode, size: CGSize)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.name = "player"
        self.sprite.zPosition = 100
        setup()
    }
    
    func setup()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.allowsRotation = false
    }
}
