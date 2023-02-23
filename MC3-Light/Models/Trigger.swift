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
}


class ChargingBox: Trigger {
    
    override init(sprite: SKSpriteNode, size: CGSize) {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "chargingBox"
        setup()
    }
}



class WinBox: Trigger
{
    
    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "winBox"
        setup()
    }
}

class Bullet: Trigger
{
    var speed: Float = 1
    
    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "winBox"
        self.sprite.isHidden = true
        setup()
    }
    func bulletFollowPlayer(player: SKSpriteNode, enemyCauser: SKSpriteNode)
    {
        
        let moveAction = SKAction.move(to: player.position, duration: TimeInterval(self.speed))
        self.sprite.run(moveAction)
    }

}

