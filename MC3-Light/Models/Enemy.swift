//
//  Enemy.swift
//  MC3-Light
//
//  Created by Kiar on 23/02/23.
//

import Foundation
import SpriteKit

class Enemy: Trigger {
    
    var speed: Float = 2
    
    override init(sprite: SKSpriteNode, size: CGSize) {
        super.init(sprite: sprite, size: size)
        self.sprite.name = "enemy"
        setup()
    }
    
    func enemyFollowThePlayer(player: SKSpriteNode)
    {
        if(self.sprite.position.x > player.position.x)
        {
            self.sprite.xScale = -1
        }
        else
        {
            self.sprite.xScale = 1
        }
        let moveAction = SKAction.move(to: player.position, duration: TimeInterval(self.speed))
        self.sprite.run(moveAction)
    }
}

class RangedEnemy: Enemy
{
   
    var weaponFireSocket: CGPoint = CGPoint(x: 0, y: 0)
   
    override init(sprite: SKSpriteNode, size: CGSize) {
        super.init(sprite: sprite, size: size)
        self.sprite.name = "enemy"
       
    }
    
    func updateSocket()
    {
        weaponFireSocket = CGPoint(x: sprite.position.x + 50, y: sprite.position.y + 50)
    }
    
    func shooting(bullet: Bullet, player: SKSpriteNode)
    {
        updateSocket()
        bullet.sprite.isHidden = false
        bullet.bulletFollowPlayer(player: player, enemyCauser: self.sprite)
    }
}
