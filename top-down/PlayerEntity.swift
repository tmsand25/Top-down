//
//  playerEntity.swift
//  mega
//
//  Created by tyler sand on 12/2/19.
//  Copyright © 2019 tyler sand. All rights reserved.
//

import SpriteKit

class playerEntity: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "block")
        super.init(texture: texture, color: .clear, size: texture.size())
    }


    func beginAnimation(animation: String) {
        let textureAtlas = SKTextureAtlas(named: "Assets")
        let frames = ["player1", "player2", "player3"].map { textureAtlas.textureNamed($0) }
       
        let animate = SKAction.animate(with: frames, timePerFrame: 0.1)
        let forever = SKAction.repeatForever(animate)
        //test
        let frames1 = ["player4", "player5", "player6"].map { textureAtlas.textureNamed($0) }
        let moveDown = SKAction.animate(with: frames1, timePerFrame: 0.1)
        let infinite = SKAction.repeatForever(moveDown)
        //frame set 3
        let frames2 = ["player7", "player8", "player9"].map { textureAtlas.textureNamed($0) }
        let moveRight = SKAction.animate(with: frames2, timePerFrame: 0.1)
        let fr3 = SKAction.repeatForever(moveRight)
        //frame set 4
        let frames3 = ["player10", "player11", "player12"].map { textureAtlas.textureNamed($0) }
        let moveLeft = SKAction.animate(with: frames3, timePerFrame: 0.1)
        let fr4 = SKAction.repeatForever(moveLeft)
        
        if(animation == "moveUp"){
        self.run(forever,withKey: "moveUp")//forever
        }
        if(animation == "moveDown"){
            self.run(infinite,withKey: "moveDown")
        }
        if(animation == "moveRight"){
            self.run(fr3,withKey: "moveRight")
        }
        if(animation == "moveLeft"){
            self.run(fr4,withKey: "moveLeft")
        }
        
        
        
    }
   func Setup(pos:CGPoint,name:String,hitBox:CGSize){//add texture
       self.position = pos
       self.name = name
       self.physicsBody = SKPhysicsBody(rectangleOf: hitBox)
    self.physicsBody?.allowsRotation = false
   }
    
    func setCollisionMasks(categoryMask:UInt32,collisionMask:UInt32,contactMask:UInt32){
        self.physicsBody!.categoryBitMask = categoryMask
        self.physicsBody!.collisionBitMask = collisionMask
        self.physicsBody!.contactTestBitMask = contactMask
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
