//
//  ViewController.swift
//  Project18
//
//  Created by MTMAC51 on 03/11/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(1,2,3,4,5, separator: "-")
        print("Some message", terminator: "")
        
//        assert(1==1, "Math failure!")
//        assert(1==2, "Math failuer!")
        
//        assert(slowMethod() == true, "The slow method returned false, which is a bad thing.")
        
        for i in 1...100{
            print("Get Number \(i).")
        }
    }


}

