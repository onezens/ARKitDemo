//
//  ViewController.swift
//  3.ARRuler
//
//  Created by wz on 2017/10/11.
//  Copyright © 2017年 cc.onezen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var targetImage: UIImageView!
    
    var session = ARSession()
    var configuration = ARWorldTrackingConfiguration()
    var isMesure = false
    var lines = [Line]()
    var currentLine:Line?
    var zeroVector = SCNVector3()
    var startVector = SCNVector3()
    var endVector = SCNVector3()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //set up ar
    func setUp(){
        sceneView.delegate = self
        sceneView.session = session
        statusLbl.text = "AR Ruler is loading..."
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !isMesure {
            isMesure = true
            reset()
            targetImage.image = UIImage(named: "GreenTarget")
            
        }else{
            isMesure = false
            if let line = currentLine {
                lines.append(line)
            }
            currentLine = nil
            targetImage.image = UIImage(named: "WhiteTarget")
        }
    }
    
    func reset() {
        
        startVector = SCNVector3()
        endVector = SCNVector3()
    }
    
    
    func scanWorld(){
        
        //screen center
        guard let worldPosition = sceneView.worldVector(position: view.center) else{
            return
        }
        
        if lines.isEmpty {
            statusLbl.text = "try to click screen"
        }
        
        if isMesure {
            if startVector == zeroVector {
                startVector = worldPosition
                currentLine = Line(startVector: startVector, sceneView: sceneView, unit: .centerMeter)
            }
            endVector = worldPosition
            currentLine?.update(endVector: endVector)
            statusLbl.text = currentLine?.distanceString(to: endVector) ?? ""
        }
    }

    
 
    @IBAction func resetBtnClick(_ sender: Any) {

        for line in lines {
            line.remove()
        }
        lines.removeAll()
    }
    
    @IBAction func unitBtnClick(_ sender: Any) {
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.scanWorld()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        statusLbl.text = "failed"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        statusLbl.text = "interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        statusLbl.text = "ended"
    }
}
