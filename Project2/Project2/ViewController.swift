//
//  ViewController.swift
//  Project2
//
//  Created by MTMAC51 on 19/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland",
                      "italy", "monaco", "nigeria", "russia",
                      "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "What is the flag of \(countries[correctAnswer].uppercased()), Score \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            counter += 1
        } else {
            title = "Wrong"
            counter += 1
        }
        
        let ac = UIAlertController(title: title, message: "Your Score is \(score)", preferredStyle: .alert)
        if counter < 5 {
            if title.hasPrefix("Wrong"){
                ac.addAction(UIAlertAction(title: "Wrong that's flag is \(countries[sender.tag].uppercased())", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            }
        } else {
            let enoughAlert = UIAlertController(title: "You're already guess \(counter) of flags", message: "Correct Flags: \(score)", preferredStyle: .alert)
            enoughAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                self.score = 0
                self.counter = 0
                self.askQuestion()
              })
            )
            present(enoughAlert, animated: true)
        }
        
    }
}

