//
//  POI.swift
//  Spot
//
//  Created by Nilesh Mahale on 11/26/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//

import Foundation
import CoreData


class POI: NSManagedObject {

    var poiDescription: String {
        return "\(name) (\(phone))"
    }

}
