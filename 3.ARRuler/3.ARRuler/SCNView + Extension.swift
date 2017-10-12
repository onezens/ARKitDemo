//
//  SCNView + Extension.swift
//  3.ARRuler
//
//  Created by wz on 2017/10/11.
//  Copyright © 2017年 cc.onezen. All rights reserved.
//

import UIKit
import ARKit

extension ARSCNView {
    
    /**world vector for a point*/
    func worldVector(position: CGPoint) -> SCNVector3?{
        
        let results = self.hitTest(position, types: .featurePoint)
        
        guard let result = results.first else{
            return nil
        }
        
        return SCNVector3.positionTransform(transform: result.worldTransform)
    }
}
