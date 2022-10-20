//
//  Person.swift
//  Project1
//
//  Created by MTMAC51 on 18/10/22.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
