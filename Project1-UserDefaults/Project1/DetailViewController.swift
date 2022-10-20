//
//  DetailViewController.swift
//  Project1
//
//  Created by MTMAC51 on 19/10/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    var selectedImageIndex: Int?
    var totalImageNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = selectedImageIndex, let total = totalImageNumber {
            title = "Picture \(index) of \(total)"
        } else {
            title = selectedImage
        }
        navigationItem.largeTitleDisplayMode = .never
        
        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
}
