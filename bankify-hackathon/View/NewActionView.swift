//
//  NewActionView.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

@objc protocol NewActionViewDelegate: class {
    func onNewGoal(_ footer: NewActionView)
    func onNewActivity(_ footer: NewActionView)
}

@IBDesignable
class NewActionView: XibView {
    
    @IBOutlet weak var delegate: NewActionViewDelegate?
    
    @IBAction func onNewGoal(_ sender: UIButton) {
        delegate?.onNewGoal(self)
    }
    
    @IBAction func onNewActivity(_ sender: UIButton) {
        delegate?.onNewActivity(self)
    }
}
