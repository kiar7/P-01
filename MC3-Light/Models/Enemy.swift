//
//  Enemy.swift
//  MC3-Light
//
//  Created by Kiar on 21/02/23.
//

import SpriteKit

class Enemy {
    var sprite: SKSpriteNode
    var size: CGSize
    
    init(sprite: SKSpriteNode, size: CGSize)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.name = "enemy"
        setup()
    }
    
    func setup()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
//        sprite.physicsBody?.isDynamic = true
    }
    
    
}

