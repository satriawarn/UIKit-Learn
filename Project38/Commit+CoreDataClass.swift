//
//  Commit+CoreDataClass.swift
//  Project38
//
//  Created by MTMAC51 on 17/11/22.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init called!")
    }
}
