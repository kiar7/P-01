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
    var maxJump = 100
    var canMove: Bool = true
    var isFalling = false
    
    var nearBoxCharge = false
    var nearLadder = false
    var isCharging = false
    var isOnLadder = false

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
