//
//  GameScene.swift
//  top-down
//
//  Created by tyler sand on 4/10/20.
//  Copyright © 2020 tyler sand. All rights reserved.
//

import SpriteKit
import GameplayKit
import Carbon.HIToolbox

//animate sprite:DONE
//boomerang if moving left and f pressed throw in that direction
//add item pickup
//collision for boomeranf and player:DONE
//shoot boomerang more times instead of one

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var player = playerEntity()
    private var sword = itemEntity()
    private var NPC1 = NPCEntity()
    let cam = SKCameraNode()
    var xPos = 100
    var yPos = 100
    let frames = ["player1", "player2", "player3"]
    var moveUp = false
    var moveDown = false
    var moveLeft = false
    var moveRight = false
    var swordPressed = false
    var facingUp = false
    var facingDown = false
    var facingLeft = false
    var facingRight = false
    var move = SKAction()
    var boomerangFacingUP = false
    var boomerangFacingDown = false
    var boomerangSelected = false
    var lastUpdate: TimeInterval!
    private var updateTime: Double = 0
    var boomerangReturned = false
    var spacePressed = false
    
    enum CategoryMask: UInt32 {
      case player = 0b01 // 1
      case NPCCategory = 0b10 // 0b10
      case enemyCategory = 0b11 // 0b11
      case terrainCategory = 0b110
      case pistolCategory = 0b0111
      case interactableObjectCategory = 0b1111
    }

    
    
    override func didMove(to view: SKView) {
        
       physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        addPlayer()
       // player.isPaused = true
        facingUp = true
        self.camera = cam
        //addSword()
        addNPC()
    }
    func addPlayer(){
       // player = SKSpriteNode(imageNamed: "block.png")
      //  player?.position = CGPoint(x: 100, y: 100)
        
      //  self.addChild(player!)
        player.Setup(pos: CGPoint(x: 100, y: 100), name: "player", hitBox: CGSize(width: player.size.width, height: player.size.height))
        player.physicsBody?.isDynamic = false
        player.setCollisionMasks(categoryMask: ~(CategoryMask.player.rawValue), collisionMask: 0, contactMask: ~(CategoryMask.interactableObjectCategory.rawValue))
        player.physicsBody?.affectedByGravity = false
        self.addChild(player)
        
        
       // player.beginAnimation(animation: "moveUp")
    }
    func addNPC(){
         NPC1.Setup(pos: CGPoint(x: 100, y: 150), name: "NPC1", hitBox: CGSize(width: 30, height: 30))
              // NPC1.physicsBody?.isDynamic = false
               NPC1.setCollisionMasks(categoryMask: ~(CategoryMask.interactableObjectCategory.rawValue), collisionMask: 0, contactMask: ~(CategoryMask.player.rawValue))
               NPC1.physicsBody?.affectedByGravity = false
               self.addChild(NPC1)
               
    }
    func addSword(){
        
          sword.itemSetup( pos: player.position, name: "sword", hitBox: CGSize(width: 30, height: 30))
                     //sword.isHidden = false
                     sword.physicsBody?.affectedByGravity = false
              
              sword.setCollisionMasks(categoryMask: ~(CategoryMask.interactableObjectCategory.rawValue), collisionMask: 0, contactMask: ~(CategoryMask.player.rawValue))
                     self.addChild(sword)
        
       /* sword.itemSetup( pos: player.position, name: "sword", hitBox: CGSize(width: 30, height: 30))
        //sword.isHidden = false
        sword.physicsBody?.affectedByGravity = false
        sword.setCollisionMasks(categoryMask: 0, collisionMask: 0, contactMask: ~(CategoryMask.player.rawValue))
        self.addChild(sword)*/
        
    }
    func collisionBetween(item: SKNode, object: SKNode){
        if(object.name == "NPC1" ){
            print("it hit")
            //bring up dialogue box
          
        }
       
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
     
     
    //  print("The \(contact.bodyA.node!.name!) entered in contact with the \(contact.bodyB.node!.name!)")
     
        if(contact.bodyA.node?.name == "player"){
          collisionBetween(item: contact.bodyA.node!, object: contact.bodyB.node!)
      }else if contact.bodyB.node?.name == "NPC1" {
          collisionBetween(item: contact.bodyB.node!, object: contact.bodyA.node!)
      }
        
    }

    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    
    override func keyUp(with event: NSEvent) {
      
        switch event.keyCode{
        case 0x03:
            boomerangReturned = false
            swordPressed = true
            sword.isHidden = false
            sword.beginAnimation()
            //sword.isHidden = true
           print("hi")
        case 0x31:
            spacePressed = false
        case 0x7E:
            player.isPaused = true
            moveUp = false
            facingUp = true
            boomerangFacingUP = true
            boomerangFacingDown = false
            facingDown = false
            facingLeft = false
            let texture1 = SKTexture(imageNamed: "player1")
            player.texture = texture1
        case 0x7D:
            player.isPaused = true
            moveDown = false
            facingDown = true
            boomerangFacingDown = true
            boomerangFacingUP = false
            facingUp = false
            facingLeft = false
            let texture1 = SKTexture(imageNamed: "player4")
            player.texture = texture1
        case 0x7C:
            player.isPaused = true
            moveRight = false
            facingRight = true
            facingLeft = false
            facingUp = false
            facingDown = false
            let texture1 = SKTexture(imageNamed: "player7")
            player.texture = texture1
        case 0x7B:
            player.isPaused = true
            moveLeft = false
            facingLeft = true
            facingUp = false
            facingDown = false
            let texture1 = SKTexture(imageNamed: "player10")
            player.texture = texture1
        default:
            print("hi")
            
        }
        
    }
    
    override func keyDown(with event: NSEvent) {
       
        guard !event.isARepeat else { return }
        switch event.keyCode {
        case 0x03://f key
          //  swordPressed =  true
           // sword.isHidden = false
            //sword.beginAnimation()
          
            print("attack")
        case 0x31:
            spacePressed = true
        case 0x7E:
           // player.position.y += 10
            moveUp = true
            moveLeft = false
            moveDown = false
            moveRight = false
           // facingUp = true
           player.isPaused = false
            
             player.beginAnimation(animation: "moveUp")
        case 0x7D:
            //player.position.y -= 10
            moveDown = true
            moveRight = false
            moveUp = false
            moveLeft = false
            player.isPaused = false
          
            player.beginAnimation(animation: "moveDown")
            
        case 0x7C:
            //player.position.x += 10
            moveRight = true
            moveUp = false
            moveDown = false
            moveLeft = false
            player.isPaused = false
            player.beginAnimation(animation: "moveRight")
        case 0x7B:
            //player.position.x -= 10
            moveLeft = true
            moveRight = false
            moveUp = false
            moveDown = false
            player.isPaused = false
            player.beginAnimation(animation: "moveLeft")
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
     defer { lastUpdate = currentTime }
     guard lastUpdate != nil else {
         return
     }

     let dt = currentTime - lastUpdate
     guard dt < 1 else {
         return //so nothing "jumps" when the the game is unpaused
     }
     if updateTime == 0 {//0
      //  sword.position = player.position
        updateTime = currentTime
               }

               if currentTime - updateTime > 1 {//1
                   //playDeathSound()
               // sword.position = player.position
                //test
                   updateTime = currentTime
               
             }
        
         cam.position = player.position
      
        sword.position = CGPoint(x: player.position.x, y: player.position.y + 100)
        
       /* if(swordPressed == true){
            //sword.position = player.position
           
            if(sword.position == player.position){
                swordPressed = false
                //sword.isHidden = true
            }
            //if boomerang hits rightside of screen come back
           
           
            if(facingUp && boomerangFacingUP){//facingUp
                facingDown = false
                facingLeft = false
                facingRight = false
                
            //let moveLeft = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y + 150), duration: 0.5)
                move = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y + 150), duration: 0.5)
                let moveRight = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y), duration: 0.5)//0.5
             let seq:SKAction = SKAction.sequence( [ move, moveRight])//moveLeft
             
           // sword.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
            sword.run(seq)
            }
            
            if(facingDown && boomerangFacingDown){
                facingUp = false
                facingLeft = false
                facingRight = false
               // let moveLeft = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y - 150), duration: 0.5)
                 move = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y - 150), duration: 0.5)
                let moveRight = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y), duration: 0.5)
                  let seq:SKAction = SKAction.sequence( [ move, moveRight])//moveLeft
                  
                // sword.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
                 sword.run(seq)
            }
             if(facingLeft){
                           facingUp = false
                        facingDown = false
                        facingRight = false
                           let moveLeft = SKAction.move(to: CGPoint(x: player.position.x - 150, y:  player.position.y), duration: 0.5)
                            let moveRight = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y), duration: 0.5)
                             let seq:SKAction = SKAction.sequence( [ moveLeft, moveRight])
                             print("facing left")
                           // sword.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
                            sword.run(seq)
                       }
                   if(facingRight){
                       facingUp = false
                    facingDown = false
                    facingLeft = false
                       let moveLeft = SKAction.move(to: CGPoint(x: player.position.x + 150, y:  player.position.y), duration: 0.5)
                        let moveRight = SKAction.move(to: CGPoint(x: player.position.x, y:  player.position.y), duration: 0.5)
                         let seq:SKAction = SKAction.sequence( [ moveLeft, moveRight])
                         print("facing left")
                       // sword.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
                        sword.run(seq)
                   }
            
            
            
            
        }*/
        
        
        if(swordPressed){
            
         
            
          
            let moveBack = SKAction.moveBy(x: -player.position.x, y: -player.position.y, duration: 2)
            move = SKAction.moveBy(x: player.position.x, y: player.position.y/2 , duration: 2)
            
            let seq:SKAction = SKAction.sequence( [ move, moveBack])
            
             sword.run(seq)
        }
        
        
        if camera == cam {
            camera!.position = player.position
        }
        
        if(moveUp == true ){
            player.position.y += 10
           // sword.position.y += 10
            
        }
        if(moveDown == true){
            player.position.y -= 10
           // sword.position.y -= 10
        }
        if(moveRight == true){
            player.position.x += 10
           // sword.position.x += 10
        }
        if(moveLeft == true){
            player.position.x -= 10
           // sword.position.x -= 10
        }
        
    }
}

