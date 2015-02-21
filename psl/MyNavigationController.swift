//
//  MyNavigationController.swift
//  psl
//
//  Created by Raza Master on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {
   
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        //return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
    
}
