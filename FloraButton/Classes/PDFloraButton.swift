//
//  PDFloraButton.swift
//  PDFloraButton
//
//  Created by Priyam Dutta on 27/08/16.
//  Copyright © 2016 Priyam Dutta. All rights reserved.
// 

import UIKit

public enum ButtonPosition {
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

private func getRadian(degree: CGFloat) -> CGFloat {
        return CGFloat(degree * .pi/180)
}

final public class PDFloraButton: UIButton {
    
    private let radius: CGFloat = 100.0
    private let childButtonSize: CGFloat = 30.0
    private let circumference: CGFloat = 360.0
    private let delayInterval = 0.0
    private let duration = 0.25
    private let damping: CGFloat = 0.9
    private let initialVelocity: CGFloat = 0.9
    private var anchorPoint: CGPoint!
    
    private var xPadding: CGFloat = 10.0
    private var yPadding: CGFloat = 10.0
    private var buttonSize: CGFloat = 0.0
    private var childButtons = 0
    private var buttonPosition: ButtonPosition = .center
    private var childButtonsArray = [UIButton]()
    private var degree: CGFloat = 0.0
    private var imageArray = [String]()
    
    public var isOpen = false
    public var buttonActionDidSelected: ((_ indexSelected: Int)->())!
    
    public convenience init(withPosition position: ButtonPosition, size: CGFloat, numberOfPetals: Int, images: [String]) {
       
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
    private func createButtons(numbers: Int) {
        for index in 0..<numbers {
            let petal = UIButton(frame: CGRect(x: 0, y: 0, width: childButtonSize, height: childButtonSize))
            petal.center = self.center
            petal.layer.cornerRadius = childButtonSize/2.0
            petal.backgroundColor = .cyan
            petal.setTitleColor(.black, for: UIControl.State())
            petal.tag = index
            if index < imageArray.count {
                petal.setImage(UIImage(named: imageArray[index]), for: UIControl.State())
            }
            petal.setTitle(String(index), for: UIControl.State())
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
        } else {
            closeButtons()
        }
    }
    
    //Simple Scale
    private func scaleAnimate(_ sender: UIView) {
        UIView.animate(withDuration: self.duration, animations: { 
            sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (completion) in
                UIView.animate(withDuration: self.duration, animations: { 
                    sender.transform = CGAffineTransform.identity
                })
        }) 
    }
    
    // Center
    private func presentationForCenter() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: (circumference/CGFloat(childButtons))*CGFloat(index))
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForTopLeft() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: (90.0/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 0.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 90.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForTopRight() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 90+((90.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 90.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 180.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForBottomLeft() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 270+((90.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 270.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 360.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForBottomRight() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 180+((90.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 180.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 270.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForMidTop() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: ((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 0.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 180.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForMidBottom() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 180+((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 180.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 360.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForMidLeft() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 270+((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 270.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 90.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func presentationForMidRight() {
        for (index, item) in self.childButtonsArray.enumerated() {
            self.degree = getRadian(degree: 90+((180.0)/CGFloat(childButtons-1))*CGFloat(index))
            if item == self.childButtonsArray.first {
                self.degree = getRadian(degree: 90.0)
            }
            if item == self.childButtonsArray.last {
                self.degree = getRadian(degree: 270.0)
            }
            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIView.AnimationOptions(), animations: {
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
    private func closeButtons() {
        UIView.animate(withDuration: self.duration, animations: { 
            for (_,item) in self.childButtonsArray.enumerated() {
                item.center = self.center
            }
            }, completion: { (completion) in
                self.isOpen = false
                self.isUserInteractionEnabled = true
        }) 
    }
    
    // Remove Buttons
    func removeButtons() {
        for item in childButtonsArray {
            item.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        scaleAnimate(sender)
        if buttonActionDidSelected != nil {
            buttonActionDidSelected(sender.tag)
        }
    }
    
}
