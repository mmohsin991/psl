//
//  Model.swift
//  psl
//
//  Created by Muhammad Mohsin on 1/7/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit
import CoreData

@objc(Model)
class Model: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var url: String
    @NSManaged var thumbImg: String
    

    
}