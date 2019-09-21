//
//  ViewController.swift
//  ARDicee
//
//  Created by Amerigo Mancino on 19/09/2019.
//  Copyright © 2019 Amerigo Mancino. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // Link to the AR Scene view
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // debug mode to show feature points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // create a sphere
        // let sphere = SCNSphere(radius: 0.2)
        
        // create a material
        // let material = SCNMaterial()
        
        // change it's diffuse color
        // material.diffuse.contents = UIImage(named: "art.scnassets/moon_texture.jpg")
        
        // add the material to the cube (you could add more to have metallic or specific effects)
        // sphere.materials = [material]
        
        // create a node, which is a position in the 3D space
        // let node = SCNNode()
        // node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        
        // set a position to the sphere
        // node.geometry = sphere
        
        // put the node in the sceneView
        // sceneView.scene.rootNode.addChildNode(node)
        
        // enable lights in the scene
        sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        // search for a node in a certain scene and include all its subnodes (there's any at the moment)
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
//
//            // Set the scene to the view
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // add horizontal planes detection
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - DELEGATE METHODS FOR ARSCNVIEW
    
    // a horizontal surface was detected and it's given to that surface (which is a
    // AR anchor) a width and a height
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // check if that anchor is a plane rather than some other 3D object in the scene
        if anchor is ARPlaneAnchor {
            // downcast the anchor to a plane anchor
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // create a plane object in SceneKit based on the planeAnchor detected
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // create a plane node for the plane object
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            // SCNPlanes are created vertically by default so we have to rotate our by 90 degrees
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            // grate a new texture material
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            // assign the matierial to the plane object
            plane.materials = [gridMaterial]
            
            // set the node geometry to the plane in order to make it appear in the scene
            planeNode.geometry = plane
            
            // add the child node into the root node: the parameter "node" of the render
            // function is a blank node that got created when a new surface was detected
            node.addChildNode(planeNode)
        } else {
            return
        }
    }
    
    // a touch is detected in the view or in the window
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if there was a touch indeed and this method wasn't called by error
        if let touch = touches.first {
            // where the touch was detected in our scene
            let touchLocation = touch.location(in: sceneView)
            
            // convert the 2D touch coordinates into the corresponding 3D coordinates for
            // manipulating the scene: searches for real-world objects or AR anchors
            // in the captured camera image corresponding to a point in the SceneKit view
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            // if we found a position on an existin plane...
            if !results.isEmpty {
                print("hit plane")
            } else {
                print("hit somewhere else")
            }
        }
    }

}
