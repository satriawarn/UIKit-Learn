//
//  Whistle.swift
//  Project33
//
//  Created by MTMAC51 on 16/11/22.
//

import CloudKit
import UIKit

class Whistle: NSObject {
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
