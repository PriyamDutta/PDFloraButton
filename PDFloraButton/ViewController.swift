//
//  ViewController.swift
//  PDFloraButton
//
//  Created by Priyam Dutta on 27/08/16.
//  Copyright © 2016 Priyam Dutta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let floraButton = PDFloraButton(withPosition: .center, size: 50.0, numberOfPetals: 20, images:[])
    private let floraButton2 = PDFloraButton(withPosition: .topLeft, size: 50.0, numberOfPetals: 4, images:[])
    private let floraButton3 = PDFloraButton(withPosition: .topRight, size: 50.0, numberOfPetals: 4, images:[])
    private let floraButton4 = PDFloraButton(withPosition: .bottomLeft, size: 50.0, numberOfPetals: 4, images:[])
    private let floraButton5 = PDFloraButton(withPosition: .bottomRight, size: 50.0, numberOfPetals: 4, images:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

}

