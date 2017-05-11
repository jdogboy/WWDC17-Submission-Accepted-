/*: 
 ## WWDC 2017 Submission
 ### An Interactive Playground
 ### By Jonathon Derr */

/*:
 - important:
 Make Sure Markup is Rendered and Timeline is shown!
 */

/*:
 ## Instructions
 ### Avoid the white pellets with your mouse
 ### Survive for two minutes */



import Foundation
import PlaygroundSupport
import SpriteKit


var sceneLoader = loadIntroScene()
var view = sceneLoader.createView()

PlaygroundPage.current.liveView = view

/*:
 - experiment:
 Try changing the speed, zoom and vertices variables. What do they do?
 */
var speed = 10
var zoom = 100
var vertices = 3

/*:
 - experiment:
 Try changing the color, with the R, G and B variables!
 */
var R = 1.0
var G = 0.5
var B = 0.3



// Creates Scene
var scene = sceneLoader.createScene(speed: Float(speed), zoom: Float(zoom), vertices: Float(vertices), red: Float(R), green: Float(G), blue: 	Float(B))

view.presentScene(scene)
  

PlaygroundPage.current.needsIndefiniteExecution = true
