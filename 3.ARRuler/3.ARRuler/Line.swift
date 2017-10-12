//
//  Line.swift
//  3.ARRuler
//
//  Created by wz on 2017/10/11.
//  Copyright © 2017年 cc.onezen. All rights reserved.
//

import ARKit

enum LengthUnit {
    case meter, centerMeter, inch
    
    /** 倍数 */
    var factor: Float {
        switch self {
        case .meter:
            return 1.0
        case .centerMeter:
            return 100.0
        case .inch:
            return 39.3700787

        }
    }
    
    /** unit name */
    var name: String{
        switch self {
        case .meter:
            return "m"
        case .centerMeter:
            return "cm"
        case .inch:
            return "inch"
        }
    }
}


class Line {
    
    var color = UIColor.orange
    var startNode:SCNNode
    var endNode: SCNNode
    var textNode: SCNNode
    var text: SCNText
    var lineNode: SCNNode?
    
    let sceneView: ARSCNView
    let startVector: SCNVector3
    let unit: LengthUnit
    
    
    init(startVector: SCNVector3, sceneView: ARSCNView, unit: LengthUnit) {
        
        self.sceneView = sceneView
        self.unit = unit
        self.startVector = startVector
        
        //startNode dot
        let dot = SCNSphere(radius: 0.5)
        dot.firstMaterial?.diffuse.contents = color
        dot.firstMaterial?.lightingModel = .constant //no shadow
        dot.firstMaterial?.isDoubleSided = true
        
        startNode = SCNNode(geometry: dot)
        startNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        startNode.position = startVector
        sceneView.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: dot)
        endNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 3)
        text.firstMaterial?.diffuse.contents = color
        text.firstMaterial?.lightingModel = .constant
        text.firstMaterial?.isDoubleSided = true
        text.alignmentMode = kCAAlignmentCenter
        text.truncationMode = kCATruncationMiddle
        
        let textWrapperNode = SCNNode(geometry: text)
        textWrapperNode.eulerAngles = SCNVector3Make(0, Float.pi, 0)
        textWrapperNode.scale = SCNVector3Make(1/500.0, 1/500.0, 1/500.0)
        
        textNode = SCNNode()
        textNode.addChildNode(textWrapperNode)
        
        let contraints = SCNLookAtConstraint(target: sceneView.pointOfView)
        contraints.isGimbalLockEnabled = true
        textNode.constraints = [contraints]
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
    }
    /** 开始画线 */
    func update(endVector: SCNVector3) {
        
        lineNode?.removeFromParentNode()
        //画线并且添加到sceneview
        lineNode = startVector.drawLine(to: endVector, color: color)
        sceneView.scene.rootNode.addChildNode(lineNode!)
        
        text.string = distanceString(to: endVector)
        //开始和结束点的中间
        textNode.position = SCNVector3((startVector.x + endVector.x) * 0.5, (startVector.y + endVector.y) * 0.5, (startVector.z + endVector.z) * 0.5)
        endNode.position = endVector
        if endNode.parent == nil {
            sceneView.scene.rootNode.addChildNode(endNode)
        }
    }
    
    /** 两个点之间的单位字符串 */
    func distanceString(to vector: SCNVector3) -> String {
        
        return String(format: "%.2f %@", arguments: [startVector.distance(to: vector) * unit.factor, unit.name])
    }

    //移除线
    func remove(){
        startNode.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
    }
    
    
    
    
}
