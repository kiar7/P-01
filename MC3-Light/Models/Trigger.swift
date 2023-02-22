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
    enum TriggerType: String
    {
        case fallingZone
        case chargingBox
        case ladder
        case enemy
    }
    
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
        
        var triggerType = TriggerType.enemy
        var enemyView = SKSpriteNode(imageNamed: "Player")
        
        override init(sprite: SKSpriteNode, size: CGSize) {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "enemy"
            self.sprite.xScale = -1
            enemyView.size = CGSize(width: 300, height: 200)
            enemyView.physicsBody = SKPhysicsBody(rectangleOf: size)
            enemyView.name = "enemyView"
            enemyView.position.y = sprite.position.y + 50
            enemyView.position.x = sprite.position.x + 100
            enemyView.physicsBody?.isDynamic = false
            enemyView.zPosition = self.sprite.zPosition + 1
            enemyView.xScale = -1
            enemyView.physicsBody?.allowsRotation = false
            setup()
        }
        
        func checkPlayer() {
            
            
        }
    }
    
    class ChargingBox: Trigger {
        
        var triggerType = TriggerType.chargingBox
        
        override init(sprite: SKSpriteNode, size: CGSize) {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "chargingBox"
            setup()
        }
    }
}
