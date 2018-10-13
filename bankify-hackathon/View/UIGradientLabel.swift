//
//  UIGradientLabel.swift
//  Exclusiv
//
//  Created by Thanh Tran on 12/19/16.
//  Copyright © 2016 SotaTek. All rights reserved.
//

import UIKit

enum GradientDirection {
    case down, upLeft, right, upRight
}

@IBDesignable
class UIGradientLabel: UILabel {
    @IBInspectable var startColor: UIColor!
    @IBInspectable var endColor: UIColor!

    override var text: String? {
        didSet {
            updateGradientImage()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientImage()
    }

    func updateGradientImage() {
        if startColor != nil && endColor != nil  && frame.size.width > 0 && frame.size.height > 0 {
            if let gradientImage = gradientImage(size: frame.size, startColor: CIColor(color: startColor), endColor: CIColor(color: endColor), direction: .right) {
                textColor = UIColor(patternImage: gradientImage)
            }
        }
    }

    func gradientImage(size: CGSize, startColor color1: CIColor, endColor color2: CIColor, direction: GradientDirection = .down) -> UIImage? {

        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector

        filter!.setDefaults()

        switch direction {
        case .down:
            startVector = CIVector(x: size.width * 0.5, y: size.height)
            endVector = CIVector(x: size.width * 0.5, y: 0)
        case .right:
            startVector = CIVector(x: 0, y: size.height * 0.5)
            endVector = CIVector(x: size.width, y: size.height * 0.5)
        case .upLeft:
            startVector = CIVector(x: size.width, y: 0)
            endVector = CIVector(x: 0, y: size.height)
        case .upRight:
            startVector = CIVector(x: 0, y: 0)
            endVector = CIVector(x: size.width, y: size.height)
        }

        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")

        if let outputImage = filter!.outputImage {
            return UIImage(cgImage: context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))!)
        } else {
            return nil
        }
    }
}
