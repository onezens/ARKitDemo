//
//  SCNVector3 + Extension.swift
//  3.ARRuler
//
//  Created by wz on 2017/10/11.
//  Copyright © 2017年 cc.onezen. All rights reserved.
//

import UIKit
import SceneKit

extension SCNVector3 {
    
    /**get the camera vector*/
    static func positionTransform(transform: matrix_float4x4) -> SCNVector3{
        
        return SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    /**calculate the distance with two vector*/
    func distance(to vector: SCNVector3) -> Float{
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        return sqrt(distanceX*distanceX + distanceY*distanceY + distanceZ*distanceZ)
    }
    
    /**two vector draw a line*/
    func drawLine(to vector: SCNVector3, color: UIColor) -> SCNNode{
        
        let indices: [UInt32] = [0, 1]
        
        //create a geometry container
        let source = SCNGeometrySource(vertices: [self, vector])
        //create a geometry element
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = color
        
        let node = SCNNode(geometry: geometry)
        return node
    }
    
}


extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x==rhs.x && lhs.y==rhs.y && lhs.z==rhs.z
    }
    
    
    
}
