//
//  PDFloraButton.swift
//  PDFloraButton
//
//  Created by Priyam Dutta on 27/08/16.
//  Copyright © 2016 Priyam Dutta. All rights reserved.
//

import UIKit

enum ButtonPosition {
    case center
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case midTop
    case midBottom
    case midLeft
    case midRight
}

func getRadian(degree: CGFloat) -> CGFloat {
        return CGFloat(degree * CGFloat(M_PI)/180)
}

class PDFloraButton: UIButton {
    
    fileprivate let radius: CGFloat = 100.0
    fileprivate let childButtonSize: CGFloat = 30.0
    fileprivate let circumference: CGFloat = 360.0
    fileprivate let delayInterval = 0.0
    fileprivate let duration = 0.25
    fileprivate let damping: CGFloat = 0.9
    fileprivate let initialVelocity: CGFloat = 0.9
    fileprivate var anchorPoint: CGPoint!
    
    fileprivate var xPadding: CGFloat = 10.0
    fileprivate var yPadding: CGFloat = 10.0
    fileprivate var buttonSize: CGFloat = 0.0
    fileprivate var childButtons = 0
    fileprivate var buttonPosition: ButtonPosition = .center
    fileprivate var childButtonsArray = [UIButton]()
    fileprivate var degree: CGFloat = 0.0
    fileprivate var imageArray = [String]()
    
    var isOpen = false
    var buttonActionDidSelected: ((_ indexSelected: Int)->())!
    
    convenience init(withPosition position: ButtonPosition, size: CGFloat, numberOfPetals: Int, images: [String]) {
       
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.layer.cornerRadius = size/2.0
       
        childButtons = numberOfPetals
        buttonPosition = position
        imageArray = images
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            switch position {
            case .topLeft:
                self.center = CGPoint(x: (self.superview?.frame)!.minX+(size/2.0)+self.xPadding, y: (self.superview?.frame)!.minY+(size/2.0)+self.yPadding)
            case .topRight:
                self.center = CGPoint(x: (self.superview?.frame)!.maxX-(size/2.0)-self.xPadding, y: (self.superview?.frame)!.minY+(size/2.0)+self.yPadding)
            case .bottomLeft:
                self.center = CGPoint(x: (self.superview?.frame)!.minX+(size/2.0)+self.xPadding, y: (self.superview?.frame)!.maxY-(size/2.0)-self.yPadding)
            case .bottomRight:
                self.center = CGPoint(x: (self.superview?.frame)!.maxX-(size/2.0)-self.xPadding, y: (self.superview?.frame)!.maxY-(size/2.0)-self.yPadding)
            case .midTop:
                self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.minY+(size/2.0)+self.yPadding)
            case .midBottom:
                self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.maxY-(size/2.0)-self.yPadding)
            case .midLeft:
                self.center = CGPoint(x: (self.superview?.frame)!.minX+(size/2.0)+self.xPadding, y: (self.superview?.frame)!.midY)
            case .midRight:
                self.center = CGPoint(x: (self.superview?.frame)!.maxX-(size/2.0)-(self.xPadding), y: (self.superview?.frame)!.midY)
            default:
                self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.midY)
            }
            self.anchorPoint = self.center
            self.createButtons(numbers: numberOfPetals)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        self.addTarget(self, action: #selector(self.animateChildButtons(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create Buttons
    fileprivate func createButtons(numbers: Int) {
        for index in 0..<numbers {
            let petal = UIButton(frame: CGRect(x: 0, y: 0, width: childButtonSize, height: childButtonSize))
            petal.center = self.center
            petal.layer.cornerRadius = childButtonSize/2.0
            petal.backgroundColor = UIColor.cyan
            petal.setTitleColor(UIColor.black, for: UIControlState())
            petal.tag = index
            if index < imageArray.count {
             petal.setImage(UIImage(named: imageArray[index]), for: UIControlState())
            }
            petal.setTitle(String(index), for: UIControlState())
            petal.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
            self.superview?.addSubview(petal)
            self.superview?.bringSubview(toFront: self)
            childButtonsArray.append(petal)
        }
    }
    
    // Present Buttons
    @IBAction func animateChildButtons(_ sender: UIButton) {
        scaleAnimate(sender)
        self.isUserInteractionEnabled = false
        if !isOpen {
            switch buttonPosition {
            case .topLeft:
                self.presentationForTopLeft()
            case .topRight:
                self.presentationForTopRight()
            case .bottomLeft:
                self.presentationForBottomLeft()
            case .bottomRight:
                self.presentationForBottomRight()
            case .midTop:
                self.presentationForMidTop()
            case .midBottom:
                self.presentationForMidBottom()
            case .midLeft:
                self.presentationForMidLeft()
            case .midRight:
                self.presentationForMidRight()
            default:
                self.presentationForCenter()
            }
        }else{
            closeButtons()
        }
    }
    
    //Simple Scale
    fileprivate func scaleAnimate(_ sender: UIView) {
        UIView.animate(withDuration: self.duration, animations: { 
            sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (completion) in
                UIView.animate(withDuration: self.duration, animations: { 
                    sender.transform = CGAffineTransform.identity
                })
        }) 
    }
    
    // Center
    fileprivate func presentationForCenter() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: (circumference/CGFloat(childButtons))*CGFloat(index))
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                 item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    // Top Left
    fileprivate func presentationForTopLeft() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: (90.0/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 0.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 90.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    // Top Right
    fileprivate func presentationForTopRight() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 90+((90.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 90.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 180.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    // Bottom Left
    fileprivate func presentationForBottomLeft() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 270+((90.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 270.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 360.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    // Bottom Right
    fileprivate func presentationForBottomRight() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 180+((90.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 180.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 270.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    //Mid Top
    fileprivate func presentationForMidTop() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: ((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 0.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 180.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    //Mid Bottom
    fileprivate func presentationForMidBottom() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 180+((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 180.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 360.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    //Mid Left
    fileprivate func presentationForMidLeft() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 270+((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 270.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 90.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    //Mid Right
    fileprivate func presentationForMidRight() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 90+((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 90.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 270.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
                item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
                }, completion: { (completion) in
                    self.isOpen = true
                    if index == self.childButtonsArray.count-1 {
                        self.isUserInteractionEnabled = true
                    }
            })
        }
    }
    
    // Close Button
    fileprivate func closeButtons() {
        UIView.animate(withDuration: self.duration, animations: { 
            for (_,item) in self.childButtonsArray.enumerated() {
                item.center = self.center
            }
            }, completion: { (completion) in
                self.isOpen = false
                self.isUserInteractionEnabled = true
        }) 
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        scaleAnimate(sender)
        if buttonActionDidSelected != nil {
            buttonActionDidSelected(sender.tag)
        }
    }
    
}
