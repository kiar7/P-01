//
//  Trigger.swift
//  MC3-Light
//
//  Created by Kiar on 22/02/23.
//

import Foundation
import SpriteKit

class Trigger
{
    
    var sprite: SKSpriteNode
    var size: CGSize
    
    init(sprite: SKSpriteNode, size: CGSize)
    {
        self.sprite = sprite
        self.size = size
        setup()
    }
    
    func setup()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = true
    }
    
    class Enemy: Trigger {
        
        var speed: CGFloat = CGFloat(100)
        
        override init(sprite: SKSpriteNode, size: CGSize) {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "enemy"
            self.sprite.xScale = -1
            setup()
        }
        
//        func moveEnemy(player: SKSpriteNode)
//        {
//            let moveEnemyAction = SKAction.move(to: CGPoint(x:player.position.x, y:player.position.y), duration: 1.0)
//            moveEnemyAction.speed = 0.1
////            let removeEnemyAction = SKAction.removeFromParent()
//            sprite.run(SKAction.sequence([moveEnemyAction]), withKey: "moveEnemyAction")
//        }

    }
    
    class ChargingBox: Trigger {
        
        override init(sprite: SKSpriteNode, size: CGSize) {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "chargingBox"
            setup()
        }
    }
    
    class Item: Trigger
    {
       
        override init(sprite: SKSpriteNode, size: CGSize)
        {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "item"
            setup()
        }
    }
    
    class winBox: Trigger
    {
        
        override init(sprite: SKSpriteNode, size: CGSize)
        {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "winBox"
            setup()
        }
    }
}
