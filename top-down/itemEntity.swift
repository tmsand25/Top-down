//
//  itemEntity.swift
//  mega
//
//  Created by tyler sand on 12/3/19.
//  Copyright © 2019 tyler sand. All rights reserved.
//

import SpriteKit


class itemEntity: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "bonearang1")
        super.init(texture: texture, color: .clear, size: texture.size())
    }
     func beginAnimation() {
           let textureAtlas = SKTextureAtlas(named: "item")
           let frames = ["bonearang1", "bonearang2", "bonearang3", "bonearang4","bonearang5"].map { textureAtlas.textureNamed($0) }
          
           let animate = SKAction.animate(with: frames, timePerFrame: 0.1)
           let forever = SKAction.repeatForever(animate)
           self.run(forever)
       }
    
    func itemSetup(pos:CGPoint,name:String,hitBox:CGSize){//add textue:SKTexture
        //self.texture = texture
        self.position = pos
        self.name = name
        self.physicsBody = SKPhysicsBody(rectangleOf: hitBox)
        
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
