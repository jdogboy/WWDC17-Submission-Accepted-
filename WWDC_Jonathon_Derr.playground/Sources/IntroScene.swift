import Foundation
import SpriteKit
//import Darwin
import Cocoa


public var storyLabel = SKLabelNode(fontNamed:"AvenirNext-Bold")
public var bottomTextShape = SKShapeNode(rectOf: CGSize(width: 600, height: 100))
public var location = NSPoint(x: 0, y: 0)
public var view = SKView()
public var scene = viewScene(size: CGSize(width: 500, height: 400))
public var canvasNode = SKShapeNode(rectOf: CGSize(width: 1000, height: 1000))

var cursorHealth = 20

//Health Text
var healthLabel = SKLabelNode(text: "Health: \(cursorHealth)")

//W & H
var WIDTH: CGFloat = 500.0
var HEIGHT: CGFloat = 400.0

//Berta
public var hollowBerta = SKShapeNode(circleOfRadius: 55)
public var bertaShape = SKShapeNode(circleOfRadius: 55)
public var eyeL = SKShapeNode(circleOfRadius: 15)
public var eyeR = SKShapeNode(circleOfRadius: 15)
public var innerEyeL = SKShapeNode(circleOfRadius: 5)
public var innerEyeR = SKShapeNode(circleOfRadius: 5)
var mouth = SKShapeNode()

// Text
var aboveText = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
var timerText = SKLabelNode(text: "Time Left: 120")

//Mouse
var cursor = SKSpriteNode(imageNamed: "cursor")
var ground = SKShapeNode()
var physicsCursor = SKSpriteNode(imageNamed: "cursor")


//Shaders
let fragmentShader = SKShader(fileNamed: "fragmentShader.fsh")
let partyFragment = SKShader(fileNamed: "partyFragment.fsh")
let bertaFrag = SKShader(fileNamed: "bertaFrag.fsh")
let defaultBackground = SKShader(fileNamed: "defaultBackground.fsh")
let mouseHover = SKShader(fileNamed: "mouseHover.fsh")

//Flags
var isOnStartScreen = true
var startWasClicked = false
var isOnMainScreen = false
var isReadyForCircle = false
var mouseWasOnCircle = false
var finishedMouseMove = false
var finishedDestroyMouse = false
var startedTimer = false
var pelletStartTut = 0
var missilesStart = 0
var sidesStart = 0
var sizeMouseStart = 0
var pelletsReadyToUpdate = false
var gameStart = false
var playedMove = false
var ifTookHealth = false
var warningNodeReady = false
var runnerMode = false
var isOnGround = true
var runHide = false
var dyingOrWon = false


var worldMouseMoved = false
var sceneMouseMoved = false
var cursorHoveredFirst = false

//This variable was truly just a result of my laziness...]
var resetTimer = false

//Death Anim
var particleEmitterCoreSpark = SKEmitterNode(fileNamed: "coreLaserSpark.sks")

//Pellets
var pellet = SKShapeNode()
var pelletTut = [SKShapeNode]()
var pelletEasy = [SKShapeNode]()

var pelletTopLine = [SKShapeNode]()
var pelletBottomLine = [SKShapeNode]()
var pelletRightLine = [SKShapeNode]()
var pelletLeftLine = [SKShapeNode]()
var pelletCircle1 = [SKShapeNode]()
var pelletCircle2 = [SKShapeNode]()
var pelletCircle3 = [SKShapeNode]()


var masterPellets = [pelletTopLine, pelletBottomLine, pelletRightLine, pelletLeftLine, pelletEasy, pelletTut]

var lineHoleWidth: Int = 20

//Warning Nodes
var warningNodeSide = SKShapeNode(rectOf: CGSize(width: 200, height: 400 - 1))
var trafficEmmitter = SKEmitterNode(fileNamed: "warningNodeFall.sks")
var warningNodeLabel = SKLabelNode(text: "WARNING!")
//Physics Categories
let pelletCat = 1
let mouseCat = 2
let groundCat = 3

//Fade Out Technique for Shaders
var curtain = SKShapeNode(rectOf: CGSize(width: 1000, height: 1000))



//Timer
var counter: Int = 120 {
didSet{
    timerText.text = "Time Left: \(counter)"
}
}

//Track
var trackingArea = NSTrackingArea()

var locationWorld = NSPoint(x: 0,y: 0)
var locationScreen = CGPoint(x: 0, y: 0)

//Paused Scene
var pausedSceneBackground = SKSpriteNode(imageNamed: "gradientPause")
var pausedLabelHEAD = SKLabelNode(text: "Please Put Cursor on Screen")

var runSequence = SKAction()


public class viewScene: SKScene, SKPhysicsContactDelegate{
    
    override public func keyDown(with event: NSEvent) {
        if runnerMode == true{
            if isOnGround == true{
        if event.keyCode == 49{
            physicsCursor.physicsBody?.applyForce(CGVector(dx: 0, dy: 325))
            isOnGround = false
        }
    }
    }
    }
    

     public func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        
       
        
        if(firstBody.categoryBitMask == UInt32(mouseCat) || secondBody.categoryBitMask == UInt32(mouseCat))
        {
            if(firstBody.categoryBitMask == UInt32(pelletCat) || secondBody.categoryBitMask == UInt32(pelletCat))
            {
          takeHealth(scene: self.scene!)
            }
        }
        
        if(firstBody.categoryBitMask == UInt32(mouseCat) || secondBody.categoryBitMask == UInt32(mouseCat))
        {
            if(firstBody.categoryBitMask == UInt32(groundCat) || secondBody.categoryBitMask == UInt32(groundCat))
            {
                isOnGround = true
            }
        }

    }
    
    override public func mouseDown(with event: NSEvent) {
        if storyLabel.contains(location) {
           startClicked()
        }
    }
    
    override public func didMove(to view: SKView) {
         trackingArea = NSTrackingArea(rect: self.frame, options: [NSTrackingAreaOptions.activeInKeyWindow, NSTrackingAreaOptions.mouseMoved, NSTrackingAreaOptions.activeAlways], owner: self)
        view.addTrackingArea(trackingArea)
        self.physicsWorld.contactDelegate = self
         }
    
    
    override public func update(_ currentTime: TimeInterval) {
        
        
        if cursorHealth == 0{
            dyingOrWon = true
            self.removeAllActions()
            self.removeAction(forKey: "countdown")
            counter = 120
            cursorHealth = 20
             startWasClicked = false
             isOnMainScreen = false
             isReadyForCircle = false
             mouseWasOnCircle = false
             finishedMouseMove = false
             finishedDestroyMouse = false
             startedTimer = false
             pelletStartTut = 0
             missilesStart = 0
             sidesStart = 0
             sizeMouseStart = 0
             pelletsReadyToUpdate = false
             gameStart = false
             playedMove = false
             ifTookHealth = false
             warningNodeReady = false
             runnerMode = false
             isOnGround = true
            runHide = false
            isOnStartScreen = true
            //cutai
            cursor.physicsBody?.affectedByGravity = false
            
            stopPelletsGameOver()

            
            pausedSceneBackground.run(SKAction.fadeIn(withDuration:1)){
                
                gameStart = false

                for pellet in pelletTut{
                    pellet.alpha = 0
                    for i in -5...5 {
                   pellet.position = CGPoint(x: WIDTH/2 + CGFloat(20 * i), y: HEIGHT/2 + 150)
                    }
                }
                hollowBerta.position = CGPoint(x: WIDTH/2, y: HEIGHT + 100)
                hollowBerta.alpha = 1
                curtain.fillColor = .black
                curtain.strokeColor = .black
                gameStart = false
                bertaShape.position = CGPoint(x: WIDTH/2, y: HEIGHT + 100)
                healthLabel.run(SKAction.fadeOut(withDuration: 1)){
                timerText.run(SKAction.fadeOut(withDuration: 1))
                    
                }
                
                
            }
            pausedLabelHEAD.text = "Game Over"
            pausedLabelHEAD.run(SKAction.fadeIn(withDuration:1)){
                bottomTextShape.run(SKAction.fadeIn(withDuration: 0))
                storyLabel.run(SKAction.fadeIn(withDuration: 0))
                curtain.removeAllActions()
                stopPelletsGameOver()
        

            }
            pausedSceneBackground.run(SKAction.wait(forDuration: 6)){
                timerText.alpha = 0
                aboveText.run(SKAction.fadeOut(withDuration: 1))
                pausedLabelHEAD.run(SKAction.fadeOut(withDuration: 1)){
                    pausedLabelHEAD.text = "Please Put the Mouse on the Screen"
                }

                trafficEmmitter?.alpha = 0
                canvasNode.fillShader = fragmentShader
                canvasNode.strokeShader = fragmentShader
                 pausedSceneBackground.run(SKAction.fadeOut(withDuration: 1))
                dyingOrWon = false


            }
        }
        
        
        if counter == 0{
            self.removeAllActions()
            counter = 120
            cursorHealth = 20
            startWasClicked = false
            isOnMainScreen = false
            isReadyForCircle = false
            mouseWasOnCircle = false
            finishedMouseMove = false
            finishedDestroyMouse = false
            startedTimer = false
            pelletStartTut = 0
            missilesStart = 0
            sidesStart = 0
            sizeMouseStart = 0
            pelletsReadyToUpdate = false
            gameStart = false
            playedMove = false
            ifTookHealth = false
            warningNodeReady = false
            runnerMode = false
            isOnGround = true
            runHide = false
            isOnStartScreen = true
            //cutai
            cursor.physicsBody?.affectedByGravity = false
            
            stopPelletsGameOver()
            
            
            pausedSceneBackground.run(SKAction.fadeIn(withDuration:1)){
                
                gameStart = false
                
                for pellet in pelletTut{
                    pellet.alpha = 0
                    for i in -5...5 {
                        pellet.position = CGPoint(x: WIDTH/2 + CGFloat(20 * i), y: HEIGHT/2 + 150)
                    }
                }
                hollowBerta.position = CGPoint(x: WIDTH/2, y: HEIGHT + 100)
                hollowBerta.alpha = 1
                curtain.fillColor = .black
                curtain.strokeColor = .black
                gameStart = false
                bertaShape.position = CGPoint(x: WIDTH/2, y: HEIGHT + 100)
                healthLabel.run(SKAction.fadeOut(withDuration: 1)){
                    timerText.run(SKAction.fadeOut(withDuration: 1))
                    
                }
                
                
            }
            pausedLabelHEAD.text = "Good Job!"
            pausedLabelHEAD.run(SKAction.fadeIn(withDuration:1)){
                bottomTextShape.run(SKAction.fadeIn(withDuration: 0))
                storyLabel.run(SKAction.fadeIn(withDuration: 0))
                curtain.removeAllActions()
                stopPelletsGameOver()
                
                
            }
            pausedSceneBackground.run(SKAction.wait(forDuration: 6)){
                timerText.alpha = 0
                aboveText.run(SKAction.fadeOut(withDuration: 1))
                pausedLabelHEAD.run(SKAction.fadeOut(withDuration: 1)){
                    pausedLabelHEAD.text = "Please Put the Mouse on the Screen"
                }
                
                trafficEmmitter?.alpha = 0
                canvasNode.fillShader = fragmentShader
                canvasNode.strokeShader = fragmentShader
                pausedSceneBackground.run(SKAction.fadeOut(withDuration: 1))
                dyingOrWon = false
                
            }
        }

        
        if isOnMainScreen == true && runHide == false && dyingOrWon == false{
            NSCursor.unhide()
        }
        particleEmitterCoreSpark?.particlePosition = location
        if runnerMode == false{
            physicsCursor.physicsBody?.velocity = CGVector.zero
        }
        healthLabel.text = "Health: \(cursorHealth)"
        
        if ifTookHealth == true {
            curtain.run(SKAction.wait(forDuration: 1)){
                ifTookHealth = false
            }
        }
        
        if locationWorld == NSEvent.mouseLocation(){
            worldMouseMoved = false
        }else{
            worldMouseMoved = true
        }
        locationWorld = NSEvent.mouseLocation()
        
        if locationScreen == location{
            sceneMouseMoved = false
        }else{
            sceneMouseMoved = true
        }
        locationScreen = location
        
        
        if gameStart == true {
            if worldMouseMoved == true && sceneMouseMoved == false && dyingOrWon == false{
                //Mouse off-screen
                pausedSceneBackground.run(SKAction.fadeIn(withDuration: 0.1))
                pausedLabelHEAD.run(SKAction.fadeIn(withDuration: 0.1))
                NSCursor.unhide()
                runHide = false
                if let action = self.action(forKey: "countdown") {
                    
                    action.speed = 0
                }
                
               stopPellets()
                            }else if sceneMouseMoved == true{
                //Mouse on-screen
                if let action = self.action(forKey: "countdown") {
                    
                    action.speed = 1
                }
                if runnerMode == true{
                    NSCursor.hide()
                }
                startPellets()
                pausedSceneBackground.run(SKAction.fadeOut(withDuration: 0.25))
                    pausedLabelHEAD.run(SKAction.fadeOut(withDuration: 0.1))
                
            }
        }
        
        
        
        
        
        
        if finishedDestroyMouse == true && startedTimer == false && dyingOrWon == false{
            let  wait = SKAction.wait(forDuration: 1)
            let tick = SKAction.run({
                [unowned self] in
                
                if counter  > 0{
                    counter -= 1
                }else{
                    self.removeAction(forKey: "countdown")
                }
                
                if counter == 118 {
                    pelletStartTut = 1
                    
                }
                if counter == 112 {
                    playedMove = false
                    
                }
            })
            
            let timerSequence = SKAction.sequence([wait,tick])
            
            self.run(SKAction.repeatForever(timerSequence), withKey: "countdown")
            curtain.run(SKAction.wait(forDuration: 3)){
            startedTimer = true
                
            }
            
        }
        
        if startedTimer == true && pelletStartTut == 1 && dyingOrWon == false {
            let fadeIn = SKAction.fadeIn(withDuration: 1)
            let moveText = SKAction.move(to: CGPoint(x: WIDTH/2 ,y:(self.scene?.frame.height)! - 100), duration: 1)
            
            
            //Pellet Code
            aboveText.position = CGPoint(x: (self.scene?.frame.width)!/2 ,y: (self.scene?.frame.height)!/2)
            aboveText.text = "Avoid the White Pellets"
            aboveText.run(fadeIn)
            aboveText.run(moveText){
                 pelletsReadyToUpdate = true
                for pellet in pelletTut{
                    pellet.physicsBody?.categoryBitMask = UInt32(pelletCat)
                    pellet.run(fadeIn){
                         let vector = CGVector(dx:-pellet.position.x + location.x ,dy:-pellet.position.y + location.y)
                        pellet.run(SKAction.move(by: vector, duration:TimeInterval(Double(arc4random_uniform(2) + 1)))){
                            pellet.run(SKAction.move(by: vector, duration:TimeInterval(Double(arc4random_uniform(2)+1)))){
                                pellet.run(SKAction.fadeOut(withDuration: 0.5)){
                                    pellet.physicsBody?.categoryBitMask = 120
                                        pelletsReadyToUpdate = false
                                    
                                }
                                aboveText.run(SKAction.fadeOut(withDuration: 1)){
                                    //aboveText.alpha = 0
                                    aboveText.text = " "
                                    //aboveText.removeFromParent()
                                    gameStart = true
                            }
                        }
                    }
                    }
            }
        }
    pelletStartTut = 2    
    }
        
        if gameStart == true && dyingOrWon == false{
            let moveText = SKAction.move(to: CGPoint(x: (self.scene?.frame.width)!/2 ,y:(self.scene?.frame.height)! - 100), duration: 1)
            let moveTimer = SKAction.move(to: CGPoint(x: (self.scene?.frame.width)!/2 + WIDTH/4 ,y:10), duration: 1)
            let moveDownTextHealth = SKAction.move(to: CGPoint(x: healthLabel.position.x, y: 10), duration: 1.0)
            moveDownTextHealth.timingMode = .easeOut
            
            //aboveText.position = CGPoint(x: (self.scene?.frame.width)!/2 ,y: (self.scene?.frame.height)!/2)
            timerText.run(SKAction.fadeIn(withDuration: 0.5))
            timerText.run(moveTimer)
            healthLabel.run(SKAction.fadeIn(withDuration: 0.5))
            healthLabel.run(moveDownTextHealth)
            
            if resetTimer == false{
            counter = 120
                resetTimer = true
            }
            curtain.run(SKAction.wait(forDuration: 0.5)){
                
                if playedMove == false{
                    play(width: (self.scene?.frame.width)!, height: (self.scene?.frame.height)!, scene: self.scene!)
                    playedMove = true
                }
            }
        
    }
        
        if warningNodeReady == true && dyingOrWon == false{
            if warningNodeSide.contains(location){
                takeHealth(scene: self.scene!)
            }
            
        }
        
}
    
    
    
    override public func mouseMoved(with event: NSEvent) {
         location = event.location(in: self)
        
         if runnerMode == false && dyingOrWon == false{
        physicsCursor.position = CGPoint(x: location.x + 5, y: location.y - 6)
        }
        
        // Eye Movement
        if(isOnMainScreen){
            let bLoc = event.location(in: bertaShape)
            let angleL = atan2(eyeL.position.y - bLoc.y, eyeL.position.x - bLoc.x)
            eyeL.run(SKAction.rotate(toAngle: CGFloat(angleL) + CGFloat(CGFloat.pi * 0.5), duration: 0.25))
            let angleR = atan2(eyeR.position.y - bLoc.y, eyeR.position.x - bLoc.x)
            eyeR.run(SKAction.rotate(toAngle: CGFloat(angleR) + CGFloat(CGFloat.pi * 0.5), duration: 0.25))
        }
        
        // Start Button
        if storyLabel.contains(location) && startWasClicked == false && dyingOrWon == false{
            storyLabel.fontSize = storyLabel.fontSize + 3
            startWasClicked = true
        }
        
        if !storyLabel.contains(location) && startWasClicked == true && dyingOrWon == false{
            storyLabel.fontSize = storyLabel.fontSize - 3
            startWasClicked = false
        }
        
        //Mouse on circle
        if isReadyForCircle == true && hollowBerta.contains(location) && mouseWasOnCircle == false && dyingOrWon == false{
            
            NSCursor.hide()
            cursor.position = CGPoint(x: location.x + 5, y: location.y - 6)
            
            mouseWasOnCircle = true
            
            
        }
        
        if mouseWasOnCircle == true && finishedMouseMove == false && dyingOrWon == false{
           destroyMouseFirst()
        
        }
        

    }
    
    
    
}


public class loadIntroScene{
    
    //Class Requires Init
    public init() {
        
    }
    
    
    //Creates and returnes view
    public func createView() -> SKView {
        view.frame.size = CGSize(width: 500, height: 400)
        view.becomeFirstResponder()
        return view
    }
    
    //Function that returns scene
    public func createScene(speed: Float, zoom: Float, vertices:
        Float, red: Float, green: Float, blue: Float) -> SKScene{
        
        
        
        let center = CGPoint(x: scene.frame.width/2, y: scene.frame.height/2)
        let fadeOut = SKAction.fadeOut(withDuration: 0)

        var width = WIDTH
        var height = HEIGHT

        
        //Create Shader and Uniform Variables
        loadUniforms(speed: speed, zoom: zoom, vert: vertices, width: Float(width), height: Float(height), red: red, green: green, blue: blue, shader: fragmentShader)
        
        loadUniforms(speed: speed, zoom: zoom, vert: vertices, width: Float(width), height: Float(height), red: red, green: green, blue: blue, shader: defaultBackground)
        loadUniforms(speed: speed, zoom: zoom, vert: vertices, width: Float(width), height: Float(height), red: red, green: green, blue: blue, shader: bertaFrag)
        loadUniforms(speed: speed, zoom: zoom, vert: vertices, width: Float(width), height: Float(height), red: red, green: green, blue: blue, shader: partyFragment)
        loadUniforms(speed: speed, zoom: zoom, vert: vertices, width: Float(width), height: Float(height), red: red, green: green, blue: blue, shader: mouseHover)

        
        //PausedBackground
        pausedSceneBackground.position = center
        pausedSceneBackground.run(fadeOut)
        
        
        //If shader can't compile, canvas is red (it's cheaty, but it works)
        canvasNode.fillColor = SKColor.red
    
        //Load shader onto canvas
        canvasNode.fillShader = fragmentShader
        canvasNode.strokeShader = fragmentShader
        
        //Background Text Shape
        bottomTextShape.position = CGPoint(x: scene.frame.width/2, y: scene.frame.height/25)
        bottomTextShape.fillColor = SKColor.black
        bottomTextShape.strokeColor = SKColor.black
        
        //Health Text
        healthLabel.position = CGPoint(x: center.x/2, y: center.y)
        healthLabel.fontSize = 30
        healthLabel.fontColor = .black
        healthLabel.run(fadeOut)
        
        //Story Text Properties
        storyLabel.text = "Start"
        storyLabel.fontSize = 45
        storyLabel.position = CGPoint(x: scene.frame.width/2, y: scene.frame.height/25)
        
        //Guide Text
        aboveText.position = CGPoint(x: center.x, y: center.y + 100)
        aboveText.text = "Place Mouse in Circle"
        aboveText.fontSize = 30
        aboveText.run(fadeOut)
        
        timerText.position = CGPoint(x: center.x/2 + center.x, y: center.y)
        timerText.fontSize = 30
        timerText.fontColor = .black
        timerText.run(fadeOut)
        
        //Paused Text 
        pausedLabelHEAD.position = center
        pausedLabelHEAD.run(fadeOut)
        
        //Mouse
        cursor.size = CGSize(width: 17, height: 25)
        cursor.position = CGPoint(x: 1000, y: 1000)
        
        //Physics Bodies
        let groundPath = CGMutablePath()
        groundPath.move(to: CGPoint(x: 0, y: 0))
        groundPath.addLine(to: CGPoint(x: scene.frame.width, y: 0))
        ground.path = groundPath
        ground.strokeColor = .black
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.categoryBitMask = UInt32(groundCat)
        ground.physicsBody?.contactTestBitMask = UInt32(mouseCat)
        ground.physicsBody?.collisionBitMask = UInt32(mouseCat)

        physicsCursor.size = CGSize(width: 17, height: 25)
        physicsCursor.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "cursor.png"), size: physicsCursor.size)
        physicsCursor.physicsBody?.allowsRotation = false
        physicsCursor.physicsBody?.affectedByGravity = false
        physicsCursor.physicsBody?.isDynamic = true
        physicsCursor.physicsBody?.categoryBitMask = UInt32(mouseCat)
        physicsCursor.physicsBody?.contactTestBitMask = UInt32(pelletCat)
        physicsCursor.physicsBody?.collisionBitMask = UInt32(pelletCat)
        physicsCursor.alpha = 0
        
     
        
        //Pellets
        for i in -5...5 {
            pelletTut.append(spawnPellet(position: CGPoint(x: center.x + CGFloat(20 * i), y: center.y + 150)))
        }
        
        for pellet in pelletTut{
            pellet.run(fadeOut)
        }

        
        for pellet in pelletEasy{
            pellet.run(fadeOut)
        }
        
        particleEmitterCoreSpark?.alpha = 0
        
        //WarningNodes
        warningNodeSide.fillColor =  SKColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.5)
        

        warningNodeSide.strokeColor = .red
        warningNodeSide.position = CGPoint(x: -(warningNodeSide.frame.size.width), y: center.y)
        
        warningNodeSide.run(fadeOut)
        
        trafficEmmitter?.position = CGPoint(x: 10, y: center.y)
        trafficEmmitter?.run(fadeOut)
        
        warningNodeLabel.position = CGPoint.zero
        warningNodeLabel.run(fadeOut)
        
        
        
        //BertaShape Properties
        hollowBerta.position = CGPoint(x: center.x, y: center.y + 400)
        hollowBerta.strokeColor = SKColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0)
        hollowBerta.fillColor = .black
        bertaShape.position = CGPoint(x: scene.frame.width/2, y: scene.frame.height/2 + 400)
        bertaShape.fillShader = bertaFrag
        eyeL.position = CGPoint(x: -22, y: 15)
        eyeL.fillColor = .white
        eyeL.strokeColor = .black
        innerEyeL.strokeColor = .black
        innerEyeL.fillColor = .black
        innerEyeL.position.y = 7
        eyeR.position = CGPoint(x: 22, y: 15)
        eyeR.fillColor = .white
        eyeR.strokeColor = .black
        innerEyeR.strokeColor = .black
        innerEyeR.fillColor = .black
        innerEyeR.position.y = 7
        eyeR.run(fadeOut)
        eyeL.run(fadeOut)

        //Smile
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -30, y: -20))
        path.addCurve(to: CGPoint(x: 30, y: -20), control1: CGPoint(x: -15,y: -35), control2: CGPoint(x: 15, y: -35))
        mouth = SKShapeNode(path: path)
         //mouth.fillColor = .blue
        mouth.strokeColor = .black
        //mouth.fillColor = NSColor.white
        mouth.lineWidth = 5
        mouth.run(fadeOut)

        
        
        //Enable SuperFade
        curtain.run(fadeOut)
        curtain.fillColor = .black
        curtain.strokeColor = .black
        
    //Load objects onto scene
    scene.addChild(canvasNode)
    scene.addChild(bottomTextShape)
    scene.addChild(curtain)
    scene.addChild(storyLabel)
    scene.addChild(bertaShape)
    scene.addChild(aboveText)
    scene.addChild(hollowBerta)
    scene.addChild(cursor)
    scene.addChild(ground)
    scene.addChild(physicsCursor)
    scene.addChild(timerText)
    scene.addChild(healthLabel)

    scene.addChild(particleEmitterCoreSpark!)
    scene.addChild(warningNodeSide)
    warningNodeSide.addChild(warningNodeLabel)
        for pellet in pelletTut{
            scene.addChild(pellet)
        }
        warningNodeSide.addChild(trafficEmmitter!)
    scene.addChild(pausedSceneBackground)
    scene.addChild(pausedLabelHEAD)

        
        
    bertaShape.addChild(eyeL)
    bertaShape.addChild(eyeR)
    bertaShape.addChild(mouth)
    eyeL.addChild(innerEyeL)
    eyeR.addChild(innerEyeR)


        return scene
    }
    

}

func startClicked(){
    let fadeOut = SKAction.fadeOut(withDuration: 2)
    let fadeIn = SKAction.fadeIn(withDuration: 0.5)
    //let wait = SKAction.wait(forDuration: 10.0)
    let moveToCenter = SKAction.move(to: CGPoint(x: scene.frame.width/2, y: scene.frame.height/2), duration: 5)
    moveToCenter.timingMode = .easeInEaseOut
    
    let moveText = SKAction.move(to: CGPoint(x: aboveText.position.x, y: aboveText.position.y + 50), duration: 1.0)
    moveText.timingMode = .easeOut

    
    curtain.run(fadeIn){
        canvasNode.strokeShader = mouseHover
        canvasNode.fillShader = mouseHover
    }
    storyLabel.run(fadeOut)
    bottomTextShape.run(fadeOut){
        hollowBerta.run(moveToCenter){
            curtain.run(fadeOut){
                isReadyForCircle = true
                aboveText.run(fadeIn)
                aboveText.run(moveText)
            }
        }
    }
    
}

func loadUniforms(speed: Float, zoom: Float, vert:
    Float, width: Float, height: Float, red: Float, green: Float, blue: Float, shader: SKShader){
    let u_speed = SKUniform(name: "u_speed", float: speed)
    let u_zoom = SKUniform(name: "u_zoom", float: zoom)
    let u_vert = SKUniform(name: "u_vert", float: vert)
    let u_width = SKUniform(name: "u_width", float: width)
    let u_height = SKUniform(name: "u_height", float: height)
    let u_r = SKUniform(name: "red", float: red)
    let u_g = SKUniform(name: "green", float: green)
    let u_b = SKUniform(name: "blue", float: blue)
    
    
    //Load Uniform Variables
    shader.addUniform(u_speed)
    shader.addUniform(u_zoom)
    shader.addUniform(u_vert)
    shader.addUniform(u_width)
    shader.addUniform(u_height)
    shader.addUniform(u_r)
    shader.addUniform(u_g)
    shader.addUniform(u_b)
}

func destroyMouseFirst() {
    let flickerOut = SKAction.fadeOut(withDuration: 0.1)
    let flickerIn = SKAction.fadeIn(withDuration: 0.1)
    let moveToCenter = SKAction.move(to: CGPoint(x: scene.frame.width/2, y: scene.frame.height/2), duration: 5)
    moveToCenter.timingMode = .easeInEaseOut
    
    let fadeOut = SKAction.fadeOut(withDuration: 2)
    let fadeIn = SKAction.fadeIn(withDuration: 0.5)
    let center = CGPoint(x: scene.frame.width/2, y: scene.frame.height/2)
    let moveText = SKAction.move(to: CGPoint(x: aboveText.position.x, y: 300), duration: 1.0)
    moveText.timingMode = .easeOut
    
    let moveDownText = SKAction.move(to: CGPoint(x: timerText.position.x, y: 10), duration: 1.0)
    moveDownText.timingMode = .easeOut
    


    
    cursor.run(SKAction.move(to: CGPoint(x: (scene.frame.width)/2, y: (scene.frame.height)/2), duration: 1)){
        aboveText.run(fadeOut){
            aboveText.position = CGPoint(x: center.x ,y: center.y)
            aboveText.text = "Goal: Protect your Cursor"
        }
        hollowBerta.run(SKAction.wait(forDuration: 0.5)){
            hollowBerta.run(SKAction.scale(by: 0.01, duration: 0.25)){
                hollowBerta.run(SKAction.scale(by: 100, duration: 0.25)){
                cursor.run(flickerOut){
                    cursor.run(flickerIn){
                        cursor.run(flickerOut){
                            cursor.run(flickerIn){
                                cursor.run(flickerOut){
                                    cursor.run(flickerIn){
                                        hollowBerta.run(SKAction.wait(forDuration: 0.25)){
                                            cursor.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "cursor.png"), size: cursor.size)
                                            cursor.zRotation = 0
                                            hollowBerta.run(SKAction.fadeOut(withDuration: 2))
                                            curtain.run(SKAction.fadeIn(withDuration: 1)){
                                                canvasNode.fillShader = defaultBackground
                                                canvasNode.strokeShader = defaultBackground
                                                bertaShape.run(moveToCenter){
                                                    eyeL.run(fadeIn)
                                                    eyeR.run(fadeIn){
                                                        isOnMainScreen = true
                                                        mouth.run(fadeIn){
                                                            mouth.run(SKAction.wait(forDuration: 1)){
                                                                curtain.run(fadeOut){
                                                                    NSCursor.unhide()
                                                                    finishedDestroyMouse = true
                                                                    aboveText.run(fadeIn)
                                                                    aboveText.run(moveText){
                                                                        aboveText.run(SKAction.wait(forDuration: 3)){
                                                                            aboveText.run(SKAction.fadeOut(withDuration: 1))
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                }

                            }
                        }
                    }
                }
            }
            }
        }
    }
    cursor.position = CGPoint(x: location.x + 5, y: location.y - 6)
    finishedMouseMove = true
    
}

func spawnPellet(position: CGPoint) -> SKShapeNode{
    pellet = SKShapeNode(circleOfRadius: 4)
    pellet.strokeColor = .black
    pellet.lineWidth = 1
    pellet.strokeShader = fragmentShader
    pellet.fillColor = .white
    pellet.position = position
    pellet.physicsBody = SKPhysicsBody(circleOfRadius: 4)
    pellet.physicsBody?.affectedByGravity = false
    pellet.physicsBody?.categoryBitMask = UInt32(pelletCat)
    pellet.physicsBody?.contactTestBitMask = UInt32(mouseCat)
    pellet.physicsBody?.collisionBitMask = UInt32(mouseCat)

    return pellet
}

func chooseMoveEasy(moveNumber: Int){
    var randomNum = arc4random_uniform(UInt32(moveNumber-1))+1
}

func startPelletsEasy(){
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    
    for index in 1...30 {
        let randomPosX = arc4random_uniform(500)
        let randomPosY = arc4random_uniform(400)
        pelletEasy.append(spawnPellet(position: CGPoint(x: Int(randomPosX), y: Int(randomPosY))))
        
    }
    
    pelletsReadyToUpdate = true
    for pellet in pelletEasy{
        pellet.physicsBody?.categoryBitMask = UInt32(pelletCat)
        var randomNUM = arc4random_uniform(3) + 1
        scene.addChild(pellet)
        pellet.run(fadeIn){
            let vector = CGVector(dx:-pellet.position.x + location.x ,dy:-pellet.position.y + location.y)
            pellet.run(SKAction.move(by: vector, duration:TimeInterval(randomNUM)), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 1)){
                pellet.run(SKAction.move(by: vector, duration:TimeInterval(randomNUM))){
                    pellet.run(SKAction.fadeOut(withDuration: 0.5)){

                            
                            pellet.removeAllActions()
                            pellet.removeFromParent()
                            pelletsReadyToUpdate = false

                    }
                }
            }
        }
    }
    pelletEasy.removeAll()

}

func startPelletsLineEasy(width: CGFloat, height: CGFloat, scene: SKScene, side: Int, hole: CGPoint){
    let center = CGPoint(x: width/2, y: height/2)
    if side == 1{
        for i in -25...25{
            
            if center.x + CGFloat(10 * i) <= CGFloat(hole.x - 30) || center.x + CGFloat(10 * i) >= CGFloat(hole.x + 30){
                pelletTopLine.append(spawnPellet(position: CGPoint(x: center.x + CGFloat(10 * i), y: center.y + 250)))
            }
        }

    for pellet in pelletTopLine{
        scene.addChild(pellet)
        pellet.run(SKAction.move(to: CGPoint(x: pellet.position.x, y:-10), duration: 5), withKey: "pausePellets")
        curtain.run(SKAction.wait(forDuration: 5)){
            pellet.removeFromParent()
            pelletTopLine.removeAll()
            pellet.removeAllActions()

        }

    }
    } else if side == 2{


        for i in -25...25{
            
            if center.x + CGFloat(10 * i) <= CGFloat(hole.x - 30) || center.x + CGFloat(10 * i) >= CGFloat(hole.x + 30){
                pelletBottomLine.append(spawnPellet(position: CGPoint(x: center.x + CGFloat(10 * i), y: 0)))
            }
        }
        
        for pellet in pelletBottomLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: pellet.position.x, y: height + 10), duration: 5), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 5)){
                pellet.removeFromParent()
                pelletBottomLine.removeAll()
                pellet.removeAllActions()

            }

        }

        
    } else if side == 3{
 

        for i in -20...20{
            
            if center.y + CGFloat(10 * i) <= CGFloat(hole.y - 30) || center.y + CGFloat(10 * i) >= CGFloat(hole.y + 30){
                pelletLeftLine.append(spawnPellet(position: CGPoint(x: 0, y: center.y + CGFloat(10 * i))))
            }
        }
        
        for pellet in pelletLeftLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: width + 10, y: pellet.position.y), duration: 5), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 5)){

                pellet.removeFromParent()
                pelletLeftLine.removeAll()
                pellet.removeAllActions()

            }

        }
        

        
    }else {


        for i in -20...20{
            
            if center.y + CGFloat(10 * i) <= CGFloat(hole.y - 30) || center.y + CGFloat(10 * i) >= CGFloat(hole.y + 30){
                pelletRightLine.append(spawnPellet(position: CGPoint(x: width, y: center.y + CGFloat(10 * i))))
            }
        }
        
        for pellet in pelletRightLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: -10, y: pellet.position.y), duration: 5), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 5)){
                physicsCursor.position = center
                pellet.removeFromParent()
                pelletRightLine.removeAll()
                pellet.removeAllActions()

            }

        }
        

    }
}

func startPelletsHard(width: CGFloat, height: CGFloat, scene: SKScene, side: Int, hole1: CGPoint, hole2: CGPoint
    ){
    let center = CGPoint(x: width/2, y: height/2)

   
    if side == 1{
        for i in -25...25{
            
            if center.x + CGFloat(10 * i) <= CGFloat(hole1.x - 30) || center.x + CGFloat(10 * i) >= CGFloat(hole1.x + 30){
                pelletTopLine.append(spawnPellet(position: CGPoint(x: center.x + CGFloat(10 * i), y: center.y + 250)))
                
            }
        }
        
        for i in -25...25{
            
            if center.x + CGFloat(10 * i) <= CGFloat(hole2.x - 30) || center.x + CGFloat(10 * i) >= CGFloat(hole2.x + 30){
                pelletBottomLine.append(spawnPellet(position: CGPoint(x: center.x + CGFloat(10 * i), y: 0)))
            }
        }

        
        for pellet in pelletTopLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: pellet.position.x, y:-10), duration: 5), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 5)){
                pellet.removeFromParent()
                pelletTopLine.removeAll()
                pellet.removeAllActions()

            }
        }
        
        for pellet in pelletBottomLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: pellet.position.x, y: height + 10), duration: 7), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 7)){
                pellet.removeFromParent()
                pelletBottomLine.removeAll()
                pellet.removeAllActions()


            }
            
        }
    } else if side == 2{
        for i in -25...25{
            
            if center.x + CGFloat(10 * i) <= CGFloat(hole1.x - 30) || center.x + CGFloat(10 * i) >= CGFloat(hole1.x + 30){
                pelletBottomLine.append(spawnPellet(position: CGPoint(x: center.x + CGFloat(10 * i), y: 0)))
            }
        }

        
        for i in -25...25{
            
            if center.x + CGFloat(10 * i) <= CGFloat(hole2.x - 30) || center.x + CGFloat(10 * i) >= CGFloat(hole2.x + 30){
                pelletTopLine.append(spawnPellet(position: CGPoint(x: center.x + CGFloat(10 * i), y: center.y + 250)))
                
            }
        }

        
            for pellet in pelletBottomLine{
            scene.addChild(pellet)
                pellet.run(SKAction.move(to: CGPoint(x: pellet.position.x, y: height + 10), duration: 5), withKey: "pausePellets")
                curtain.run(SKAction.wait(forDuration: 5)){

                    pellet.removeFromParent()
                    pelletBottomLine.removeAll()
                    pellet.removeAllActions()


                }
                
        }
        for pellet in pelletTopLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: pellet.position.x, y:-10), duration: 5), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 5)){
                pellet.removeFromParent()
                pellet.removeAllActions()
                pelletTopLine.removeAll()
            }
        }

        
        
        
    } else if side == 3{
        
        for i in -20...20{
            
            if center.y + CGFloat(10 * i) <= CGFloat(hole2.y - 30) || center.y + CGFloat(10 * i) >= CGFloat(hole2.y + 30){
                pelletLeftLine.append(spawnPellet(position: CGPoint(x: 0, y: center.y + CGFloat(10 * i))))
                
            }
        }
        
        
        for i in -20...20{
            
            if center.y + CGFloat(10 * i) <= CGFloat(hole1.y - 30) || center.y + CGFloat(10 * i) >= CGFloat(hole1.y + 30){
                pelletRightLine.append(spawnPellet(position: CGPoint(x: width, y: center.y + CGFloat(10 * i))))
            }
        }

        
        for pellet in pelletLeftLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: width + 10, y: pellet.position.y), duration: 5), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 5)){

                pellet.removeFromParent()
                pelletLeftLine.removeAll()
                pellet.removeAllActions()

            }
        }
        
        
        for pellet in pelletRightLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: -10, y: pellet.position.y), duration: 7), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 7)){

                pellet.removeFromParent()
                pelletRightLine.removeAll()
                pellet.removeAllActions()

            }
        }
        
        
    }else {
        
        for i in -20...20{
            
            if center.y + CGFloat(10 * i) <= CGFloat(hole1.y - 30) || center.y + CGFloat(10 * i) >= CGFloat(hole1.y + 30){
                pelletLeftLine.append(spawnPellet(position: CGPoint(x: 0, y: center.y + CGFloat(10 * i))))
                
            }
        }
        
        
        for i in -20...20{
            
            if center.y + CGFloat(10 * i) <= CGFloat(hole2.y - 30) || center.y + CGFloat(10 * i) >= CGFloat(hole2.y + 30){
                pelletRightLine.append(spawnPellet(position: CGPoint(x: width, y: center.y + CGFloat(10 * i))))
            }
        }

        
        for pellet in pelletRightLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: -10, y: pellet.position.y), duration: 5), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 5)){
                pellet.removeFromParent()
                pelletRightLine.removeAll()
                pellet.removeAllActions()

            }
        }
        for pellet in pelletLeftLine{
            scene.addChild(pellet)
            pellet.run(SKAction.move(to: CGPoint(x: width + 10, y: pellet.position.y), duration: 7), withKey: "pausePellets")
            curtain.run(SKAction.wait(forDuration: 7)){
            pellet.removeFromParent()
                pelletLeftLine.removeAll()
                pellet.removeAllActions()
            }

            
        }

        
        
    }
}


func healthDrop(){
    cursorHealth -= 1
    curtain.strokeColor = .red
    curtain.fillColor = .red
    curtain.run(SKAction.fadeIn(withDuration: 0.25)){
    curtain.run(SKAction.fadeOut(withDuration: 0.25))
    }
}

func removePelletActions(){
    for pellet in pelletEasy{
        pellet.removeAllActions()
    }
    for pellet in pelletTopLine{
        pellet.removeAllActions()
    }
    for pellet in pelletBottomLine{
        pellet.removeAllActions()
    }
    for pellet in pelletTut{
        pellet.removeAllActions()
    }
    for pellet in pelletLeftLine{
        pellet.removeAllActions()
    }
    for pellet in pelletRightLine{
        pellet.removeAllActions()
    }
}

func warningNode(side: Int){
    warningNodeSide.position = CGPoint(x: -(warningNodeSide.frame.size.width), y: HEIGHT/2)
    if side == 1{
        warningNodeSide.run(SKAction.fadeIn(withDuration: 0.75))
        warningNodeSide.position = CGPoint(x: -(warningNodeSide.frame.size.width), y: HEIGHT/2)
        warningNodeLabel.run(SKAction.fadeIn(withDuration: 0.75))
        warningNodeSide.run(SKAction.move(to: CGPoint(x: (warningNodeSide.frame.size.width/2), y: HEIGHT/2), duration: 1)){
           curtain.run(SKAction.wait(forDuration: 2)){
            warningNodeLabel.run(SKAction.fadeOut(withDuration: 0.5))
                trafficEmmitter?.run(SKAction.fadeIn(withDuration: 0.5))
            curtain.run(SKAction.wait(forDuration: 3)){
                warningNodeSide.run(SKAction.fadeOut(withDuration: 0.75))
                trafficEmmitter?.run(SKAction.fadeOut(withDuration: 0.5))
                warningNodeSide.run(SKAction.move(to: CGPoint(x: -200, y: HEIGHT/2), duration: 1))
            
            }}
        }
    }else if side == 2{
        warningNodeSide.run(SKAction.fadeIn(withDuration: 0.75))
        warningNodeSide.position = CGPoint(x: WIDTH, y: HEIGHT/2)
        warningNodeLabel.run(SKAction.fadeIn(withDuration: 0.75))
        warningNodeSide.run(SKAction.move(to: CGPoint(x:WIDTH/2, y: HEIGHT/2), duration: 1)){
            curtain.run(SKAction.wait(forDuration: 2)){
                warningNodeLabel.run(SKAction.fadeOut(withDuration: 0.5))
                trafficEmmitter?.run(SKAction.fadeIn(withDuration: 0.5)){
                    warningNodeReady = true
                }
                curtain.run(SKAction.wait(forDuration: 3)){
                    warningNodeSide.run(SKAction.fadeOut(withDuration: 0.75))
                    trafficEmmitter?.run(SKAction.fadeOut(withDuration: 0.5)){
                        warningNodeReady = false
                    }
                    warningNodeSide.run(SKAction.move(to: CGPoint(x:WIDTH, y: HEIGHT/2), duration: 1))
                    
                }}
        }
    }else{
        warningNodeSide.run(SKAction.fadeIn(withDuration: 0.75))
        warningNodeSide.position = CGPoint(x: WIDTH, y: HEIGHT/2)
        warningNodeLabel.run(SKAction.fadeIn(withDuration: 0.75))
        warningNodeSide.run(SKAction.move(to: CGPoint(x:WIDTH - (warningNodeSide.frame.size.width)/2, y: HEIGHT/2), duration: 1)){
            curtain.run(SKAction.wait(forDuration: 2)){
                warningNodeLabel.run(SKAction.fadeOut(withDuration: 0.5))
                trafficEmmitter?.run(SKAction.fadeIn(withDuration: 0.5)){
                    warningNodeReady = true
                }
                curtain.run(SKAction.wait(forDuration: 3)){
                    warningNodeSide.run(SKAction.fadeOut(withDuration: 0.75))
                    trafficEmmitter?.run(SKAction.fadeOut(withDuration: 0.5)){
                        warningNodeReady = false
                    }
                    warningNodeSide.run(SKAction.move(to: CGPoint(x: WIDTH, y: HEIGHT/2), duration: 1))
                    
                }}
        }

    }
}

func runnerStop(){
        runnerMode = false
        physicsCursor.run(SKAction.move(to: location, duration: 0.5)){
            physicsCursor.alpha = 0
        runHide = false
    }
        physicsCursor.physicsBody?.affectedByGravity = false

}

func runner(scene: SKScene){
    aboveText.position = CGPoint(x: WIDTH/2, y: HEIGHT/2)
    aboveText.text = "Press Spacebar"
    aboveText.run(SKAction.fadeOut(withDuration: 0))
    //scene.addChild(aboveText)
        runnerMode = true
    physicsCursor.alpha = 1
    runHide = true
    physicsCursor.physicsBody?.affectedByGravity = true
    aboveText.run(SKAction.move(to: CGPoint(x: WIDTH/2, y: HEIGHT/2 + 100), duration: 1))
    aboveText.run(SKAction.fadeIn(withDuration: 1)){
        curtain.run(SKAction.wait(forDuration: 3)){
            aboveText.run(SKAction.fadeOut(withDuration: 1))
        }
    }
    }

func play(width: CGFloat, height: CGFloat, scene: SKScene){
    let center = CGPoint(x: width/2, y: height/2)
    let wait = SKAction.wait(forDuration: 6)
    let move1 = SKAction.run({
        startPelletsEasy()
    })
    let move2 = SKAction.run({
        startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 3, hole: center)
    })
    var move3 = SKAction.run({
        startPelletsHard(width: WIDTH, height: HEIGHT, scene: scene, side: 2, hole1: CGPoint(x: center.x/2, y: center.y/5), hole2: CGPoint(x: center.x/5, y: center.y/2))
    })
    
    let move4 = SKAction.run({
        startPelletsEasy()
        startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 4, hole: CGPoint(x: center.x/2, y: center.y/5))
    })
    let move5 = SKAction.run({
        startPelletsEasy()
        startPelletsHard(width: WIDTH, height: HEIGHT, scene: scene, side: 2, hole1: CGPoint(x: center.x/3, y: center.y/5), hole2: CGPoint(x: center.x/2, y: center.y/3))
    })
    let move6 = SKAction.run({
        warningNode(side: 3)
    })
    let move7 = SKAction.run({
        startPelletsEasy()
        //warningNode(side: 2)
    })
    let move8 = SKAction.run({
        //warningNode(side: 1)
    })
    let move9 = SKAction.run({
        startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 4, hole: CGPoint(x: center.x/2, y: center.y/5))
        startPelletsHard(width: WIDTH, height: HEIGHT, scene: scene, side: 1, hole1: CGPoint(x: center.x - 50, y: center.y - 50), hole2: CGPoint(x: center.x + 50, y: center.y + 50))
        //warningNode(side: 3)
    })
    let move10 = SKAction.run({
            startPelletsEasy()
    })
    let move11 = SKAction.run({
         startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 4, hole: CGPoint(x: center.x/2, y: center.y/5))
        //warningNode(side: 1)
    })
    let move12 = SKAction.run({
        startPelletsHard(width: WIDTH, height: HEIGHT, scene: scene, side: 2, hole1: CGPoint(x: center.x - 100, y: center.y - 100), hole2: CGPoint(x: center.x/2, y: center.y/3))
        warningNode(side: 3)
        startPelletsEasy()
    })
    let move13 = SKAction.run({
        runner(scene: scene)
    })
    let move14 = SKAction.run({
        startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 4, hole: CGPoint(x: center.x, y: center.y))
    })

    let move15 = SKAction.run({
        startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 4, hole: CGPoint(x: center.x, y: center.y))
    })
    let move16 = SKAction.run({
        startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 4, hole: CGPoint(x: center.x, y: center.y))
    })
    let move17 = SKAction.run({
        runnerStop()
        startPelletsEasy()
    })
    let move18 = SKAction.run({
        startPelletsHard(width: WIDTH, height: HEIGHT, scene: scene, side: 2, hole1: CGPoint(x: center.x/2, y: center.y/5), hole2: CGPoint(x: center.x/5, y: center.y/2))
        warningNode(side: 3)

        
    })
    let move19 = SKAction.run({
        startPelletsHard(width: WIDTH, height: HEIGHT, scene: scene, side: 2, hole1: CGPoint(x: center.x/2, y: center.y/5), hole2: CGPoint(x: center.x/5, y: center.y/2))
        warningNode(side: 3)
        startPelletsEasy()
    })
    
    let move20 = SKAction.run({
        startPelletsLineEasy(width: WIDTH, height: HEIGHT, scene: scene, side: 4, hole: CGPoint(x: center.x, y: center.y))
        startPelletsEasy()

    })
    let move21 = SKAction.run({
        startPelletsHard(width: WIDTH, height: HEIGHT, scene: scene, side: 2, hole1: CGPoint(x: center.x/2, y: center.y/5), hole2: CGPoint(x: center.x/5, y: center.y/2))
        warningNode(side: 3)
        startPelletsEasy()
    })
    
    
    curtain.run(SKAction.sequence([move1,wait,move2,wait,move3,wait,move4,wait,move5,wait,move6,wait,move7,wait,move8,wait,move9,wait,move10,wait,move11,wait,move12,wait,move13,wait,move14,wait,move15,wait,move16,wait,move17,wait,move18,wait,move19,wait,move20,wait,move21]), withKey: "pausePellets")
    

}

func stopPellets(){
    if let action = curtain.action(forKey: "pausePellets") {
        
        action.speed = 0
    }
    for pellet in pelletLeftLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 0
        }
    }
    for pellet in pelletEasy{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 0
        }
    }
    for pellet in pelletRightLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 0
        }
    }
    for pellet in pelletTopLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 0
        }
    }
    for pellet in pelletBottomLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 0
        }
    }
}


func startPellets(){
    if let action = curtain.action(forKey: "pausePellets") {
        
        action.speed = 1
    }
    for pellet in pelletLeftLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 1
        }
    }
    for pellet in pelletEasy{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 1
        }
    }
    for pellet in pelletRightLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 1
        }
    }
    for pellet in pelletTopLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 1
        }
    }
    for pellet in pelletBottomLine{
        if let action = pellet.action(forKey: "pausePellets") {
            
            action.speed = 1
        }
    }
}

func takeHealth(scene: SKScene){
    if isOnMainScreen{
        if ifTookHealth == false{
            if cursorHealth == 0{
                physicsCursor.alpha = 0
                physicsCursor.physicsBody?.velocity = CGVector.zero
                physicsCursor.physicsBody?.affectedByGravity = false
            dyingOrWon = true
            }
            curtain.fillColor = .red
            curtain.strokeColor = .red
            spawnCursor(scene: scene)
            spark()
            curtain.run(SKAction.fadeIn(withDuration: 0.25)){
                curtain.run(SKAction.fadeOut(withDuration: 0.25))
            }
            cursorHealth -= 1
            ifTookHealth = true
        }
    }

}

func spawnCursor(scene: SKScene){
    var cursor = SKSpriteNode(imageNamed: "cursor")
    cursor.size = CGSize(width: 17, height: 25)
    cursor.position = location
    cursor.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "cursor.png"), size: physicsCursor.size)
    scene.addChild(cursor)
    curtain.run(SKAction.wait(forDuration: 2)){
        cursor.run(SKAction.fadeOut(withDuration: 1)){
            cursor.removeFromParent()
        }
    }
}

func spark(){
    particleEmitterCoreSpark?.alpha = 1
    curtain.run(SKAction.wait(forDuration: 0.25)){
        particleEmitterCoreSpark?.alpha = 0

    }
}

func stopPelletsGameOver(){
    
    for pellet in pelletLeftLine{
        pellet.run(SKAction.fadeOut(withDuration:1)){
            pellet.removeFromParent()
            pellet.removeAllActions()
            pellet.alpha = 0
            
        }
    }
    for pellet in pelletEasy{
        pellet.run(SKAction.fadeOut(withDuration:1))
        pellet.removeAllActions()
        pellet.alpha = 0

    }
    for pellet in pelletRightLine{
        pellet.run(SKAction.fadeOut(withDuration:1))
        pellet.removeAllActions()
        pellet.alpha = 0

    }
    for pellet in pelletTopLine{
        pellet.run(SKAction.fadeOut(withDuration:1))
        pellet.removeAllActions()
        pellet.alpha = 0

    }
    for pellet in pelletBottomLine{
        pellet.run(SKAction.fadeOut(withDuration:1))
        pellet.removeAllActions()
        pellet.alpha = 0

    }
    

}



