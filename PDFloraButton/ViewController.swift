//
//  ViewController.swift
//  PDFloraButton
//
//  Created by Priyam Dutta on 27/08/16.
//  Copyright © 2016 Priyam Dutta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let floraButton = PDFloraButton(withPosition: .center, size: 50.0, numberOfPetals: 20, images:[])
    let floraButton2 = PDFloraButton(withPosition: .topLeft, size: 50.0, numberOfPetals: 4, images:[])
    let floraButton3 = PDFloraButton(withPosition: .topRight, size: 50.0, numberOfPetals: 4, images:[])
    let floraButton4 = PDFloraButton(withPosition: .bottomLeft, size: 50.0, numberOfPetals: 4, images:[])
    let floraButton5 = PDFloraButton(withPosition: .bottomRight, size: 50.0, numberOfPetals: 4, images:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(floraButton)
        self.view.addSubview(floraButton2)
        self.view.addSubview(floraButton3)
        self.view.addSubview(floraButton4)
        self.view.addSubview(floraButton5)
        
        floraButton.buttonActionDidSelected = { (indexSelected) in
            debugPrint("Selected Index: \(indexSelected)")
        }
    }

}

