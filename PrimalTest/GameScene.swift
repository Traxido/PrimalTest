//
//  GameScene.swift
//  PrimalTest
//
//  Created by Andrew Sheron on 12/21/18.
//  Copyright © 2018 Andrew Sheron. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var randomTimer:Timer? = nil
    
    var man = SKSpriteNode(imageNamed: "man")
    var man2 = SKSpriteNode(imageNamed: "man")
    var man3 = SKSpriteNode(imageNamed: "man")
    var manRunning:[SKTexture] = []
    
    var men:[SKSpriteNode] = []

    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(red:0.86, green:0.80, blue:0.72, alpha:1.0)
        men = [man]
        for i in 0...men.count-1 {
        buildMan(sprite: men[i])
        }
        man2.position = CGPoint(x: self.frame.width / 3, y: self.frame.height / 3)
        man3.position = CGPoint(x: self.frame.width / 1.5, y: self.frame.height / 1.5)
        
        let randomTime = Int(arc4random_uniform(3))
        self.randomTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(doSomethingRandom), userInfo: nil, repeats: true)
    }
    
    @objc func doSomethingRandom() {
        let rand = Int(arc4random_uniform(UInt32(men.count)))
        for i in 0...rand {
            let randomGuyMoving = men[i]
            let chosenSprite = randomGuyMoving
            let randomXadd = Int(arc4random_uniform(50))
            let randomYadd = Int(arc4random_uniform(50))
            let addOrSubtractX = Int(arc4random_uniform(2))
            let addOrSubtractY = Int(arc4random_uniform(2))
            
            var movementX = CGFloat()
            var movementY = CGFloat()
            
            if addOrSubtractX == 1 {
                movementX = chosenSprite.position.x - CGFloat(randomXadd)
            } else {
                movementX = chosenSprite.position.x + CGFloat(randomXadd)
            }
            
            if addOrSubtractY == 1 {
                movementY = chosenSprite.position.y - CGFloat(randomYadd)
            } else {
                movementY = chosenSprite.position.y + CGFloat(randomYadd)
            }
            
            moveman(location: CGPoint(x: movementX, y: movementY), sprite: chosenSprite)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        //moveman(location: touchLocation)
        
        createPerson(sprite: SKSpriteNode.init(imageNamed: "man"))
        let manToAdd = men[men.count-1]
        manToAdd.size = CGSize(width: 18, height: 30)
        manToAdd.position = touchLocation
        self.addChild(manToAdd)
        
    }
    
    
    
    func buildMan(sprite: SKSpriteNode) {
        let manAnimatedAtlas = SKTextureAtlas(named: "man1")
        var walkFrames: [SKTexture] = []
        
        let numImages = manAnimatedAtlas.textureNames.count
        print(numImages)
        for i in 0...numImages-1 {
            let manTextureName = "run\(i)"
            walkFrames.append(manAnimatedAtlas.textureNamed(manTextureName))
        }
        manRunning = walkFrames
        sprite.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        sprite.size = CGSize(width: 18, height: 30)
        self.addChild(sprite)
    }
    
    func animateMan(sprite: SKSpriteNode) {
        sprite.run(SKAction.repeatForever(
            SKAction.animate(with: manRunning,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: true)),
                withKey: "manRunning")
    }
    
    func moveman(location: CGPoint, sprite: SKSpriteNode) {
        var multiplierForDirection: CGFloat
        let manSpeed = frame.size.width / 5.0
        let moveDifference = CGPoint(x: location.x - sprite.position.x, y: location.y - sprite.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        let moveDuration = distanceToMove / manSpeed
        if moveDifference.x < 0 {
            multiplierForDirection = -1.0
        } else {
            multiplierForDirection = 1.0
        }
        sprite.xScale = abs(sprite.xScale) * multiplierForDirection
        if sprite.action(forKey: "walkingInPlaceman") == nil {
            // if legs are not moving, start them
            animateMan(sprite: sprite)
        }
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        let doneAction = SKAction.run({ [weak self] in
            self!.stopAnimating(sprite: sprite)
        })
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        sprite.run(moveActionWithDone, withKey:"manMoving")
    }
    
    func createPerson(sprite: SKSpriteNode) {
        var newPerson = SKSpriteNode()
        newPerson = sprite
        men.append(newPerson)
    }
    
    func stopAnimating(sprite: SKSpriteNode) {
        sprite.removeAllActions()
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
