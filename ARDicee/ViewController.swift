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
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // create a cube (10 cm each side)
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        // create a material
        let material = SCNMaterial()
        
        // change it's diffuse color
        material.diffuse.contents = UIColor.red
        
        // add the material to the cube (you could add more to have metallic or specific effects)
        cube.materials = [material]
        
        // create a node, which is a position in the 3D space
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        
        // set a position to the cube
        node.geometry = cube
        
        // put the node in the sceneView
        sceneView.scene.rootNode.addChildNode(node)
        
        // enable lights in the scene
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        // sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
