//
//  GameScene.swift
//  Project14
//
//  Created by MTMAC51 on 24/10/22.
//

import SpriteKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var popUpTime = 0.85
    var score = 0 {
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    var numRounds = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i*170), y: 410))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i*170), y: 320))}
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i*170), y: 230))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i*170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes{
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend"{
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy"{
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                whackSlot.hit()
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy(){
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            let scoreNode = SKLabelNode(fontNamed: "Marker Felt")
            scoreNode.text = "FINAL SCORE: \(score) POINTS!"
            scoreNode.position = CGPoint(x: 512, y: 300)
            scoreNode.zPosition = 1
            scoreNode.horizontalAlignmentMode = .center
            scoreNode.fontSize = 48
            addChild(scoreNode)
            
            run(SKAction.playSoundFileNamed("sudah.wav", waitForCompletion: false))
            
            return
        }
        
        popUpTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popUpTime)
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popUpTime)
        }
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popUpTime)
        }
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popUpTime)
        }
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popUpTime)
        }
        
        let minDelay = popUpTime / 2.0
        let maxDelay = popUpTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
}
