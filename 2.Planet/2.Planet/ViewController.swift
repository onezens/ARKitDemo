//
//  ViewController.swift
//  2.Planet
//
//  Created by wz on 2017/10/10.
//  Copyright © 2017年 cc.onezen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let planets =  ["earth.jpg","jupiter.jpg","mars.jpg","venus.jpg"]
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        createPlanet()

    }
    
    func createPlanet(){
        
        let scene = SCNScene()
        let sphere = SCNSphere(radius: 0.1)
        //material
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: planets.first!)
        sphere.materials = [material]
        //position
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0, 0, -0.5)
        scene.rootNode.addChildNode(sphereNode)
        //assignment scene
        sceneView.scene = scene

        addTapGesture()
    }
    
    func addTapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGestureSel(sender:)))
        sceneView.addGestureRecognizer(tap)
    }
    @objc func tapGestureSel(sender: UITapGestureRecognizer) {
        
        let touchLocation = sender.location(in: sender.view)
        let touchResult = sceneView.hitTest(touchLocation, options: nil)
        
        if !touchResult.isEmpty {
            if index == planets.count {
                index = 0
            }
            
            guard let hitResult = touchResult.first else{
                return
            }
            let node = hitResult.node
            node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: planets[index])
            index+=1
            
        }
    }
    
    
    func createCubeBox(){
        //create new scene
        let scene = SCNScene()
        // create cube box  unit 0.1m = 10cm
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        // create render material
        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
        material.diffuse.contents = UIImage(named: "brick")
        box.materials = [material]
        // create box node
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, -0.2)
        scene.rootNode.addChildNode(boxNode)
        
        sceneView.scene = scene
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
    


    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
