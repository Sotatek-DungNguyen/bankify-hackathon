//
//  UIGradientView.swift
//  Exclusiv
//
//  Created by Thanh Tran on 11/15/16.
//  Copyright © 2016 SotaTek. All rights reserved.
//

import UIKit

@IBDesignable
class UIGradientView: UIView {
    
    @IBInspectable var startColor: UIColor!
    @IBInspectable var endColor: UIColor!
    @IBInspectable var isVerticalGradient: Bool = true {
        didSet {
            if isVerticalGradient {
                startPoint = CGPoint(x: 0.5, y: 0.0)
                endPoint = CGPoint(x: 0.5, y: 1.0)
            } else {
                startPoint = CGPoint(x: 0.0, y: 0.5)
                endPoint = CGPoint(x: 1.0, y: 0.5)
            }
        }
    }
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)
    var gradientBackground: CAGradientLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let gradientBackground = gradientBackground {
            gradientBackground.removeFromSuperlayer()
            self.gradientBackground = nil
        }
        
        if startColor != nil && endColor != nil {
            createGradientBackground()
        }
    }
    
    private func createGradientBackground() {
        gradientBackground = CAGradientLayer()
        gradientBackground.cornerRadius = layer.cornerRadius
        gradientBackground.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradientBackground.colors = [startColor.cgColor, endColor.cgColor]
        gradientBackground.startPoint = startPoint
        gradientBackground.endPoint = endPoint

        layer.insertSublayer(gradientBackground, at: 0)
    }
}
