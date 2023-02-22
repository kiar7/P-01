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
        case item
        case winBox
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
//        sprite.physicsBody?.isDynamic = true
    }
    
    class Enemy: Trigger {
        
        var triggerType = TriggerType.enemy
        
        override init(sprite: SKSpriteNode, size: CGSize) {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "enemy"
            setup()
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
    
    class Item: Trigger
    {
        var triggerType = TriggerType.item
        
        override init(sprite: SKSpriteNode, size: CGSize)
        {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "item"
            setup()
        }
    }
    
    class winBox: Trigger
    {
        var triggerType = TriggerType.winBox
        override init(sprite: SKSpriteNode, size: CGSize)
        {
            super .init(sprite: sprite, size: size)
            self.sprite.name = "winBox"
            setup()
        }
    }
}
