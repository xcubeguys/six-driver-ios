//
//  GMDCircularProgressView.swift
//  MaterialDesignCircularProgressView
//
//  Created by Narbeh Mirzaei on 5/22/16.
//  Copyright © 2016 Narbeh Mirzaei. All rights reserved.
//

import UIKit

class GMDCircularProgressView: UIView {
    
    let circularLayer = CAShapeLayer()
    let googleColors = [
        UIColor.white,
        UIColor.white,
        UIColor.white,
        UIColor.white
    ]
    
    let inAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

        return animation
    }()
    
    let outAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return animation
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        animation.duration = 2.0
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    var colorIndex : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circularLayer.lineWidth = 4.0
        circularLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(circularLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //125 -30 //5s
        //        //6s
        
        let center = CGPoint(x: 125, y: -30)
        let radius = min(bounds.width, bounds.height) / 2 - circularLayer.lineWidth / 2
   
        let arcPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI + (2 * M_PI)), clockwise: true)
        
        circularLayer.position = center
        circularLayer.path = arcPath.cgPath
        
        animateProgressView()
        circularLayer.add(rotationAnimation, forKey: "rotateAnimation")
    }
    
     func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(flag) {
            animateProgressView()
        }
    }
    
    func animateProgressView() {
        circularLayer.removeAnimation(forKey: "strokeAnimation")
        
        circularLayer.strokeColor = googleColors[colorIndex].cgColor
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.0 + outAnimation.beginTime
        strokeAnimationGroup.speed = 1.0
        strokeAnimationGroup.isRemovedOnCompletion = false
        strokeAnimationGroup.repeatCount = .infinity  //500
        strokeAnimationGroup.animations = [inAnimation, outAnimation]
       // strokeAnimationGroup.delegate = self
        
        circularLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")

        colorIndex += 1;
        colorIndex = colorIndex % googleColors.count;
    }
}
