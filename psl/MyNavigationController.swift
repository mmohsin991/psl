//
//  MyNavigationController.swift
//  psl
//
//  Created by Muhammad Mohsin on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {
   
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        //return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        return UIInterfaceOrientationMask.Portrait
    }
    
}
