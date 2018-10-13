//
//  HomeFooter.swift
//  Exclusiv
//
//  Created by Thanh Tran on 11/1/16.
//  Copyright © 2016 SotaTek. All rights reserved.
//

import Foundation
import UIKit

@objc protocol HomeFooterDelegate: class {
    func onSelectTab(_ footer: HomeFooter, index: Int)
    func onShowMain()
}

@IBDesignable
class HomeFooter: XibView {
    
    @IBOutlet weak var delegate: HomeFooterDelegate?
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    private var buttons: [UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttons = [button1, button2, button3, button4]
    }
    
    @IBAction func onSelectTab(_ sender: UIButton) {
        sender.isSelected = true
        buttons.forEach {
            if $0 != sender {
                $0.isSelected = false
            }
        }
        delegate?.onSelectTab(self, index: sender.tag)
    }
    
    @IBAction func onSelectCenter(_ sender: UIButton) {
        delegate?.onShowMain()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutButtons()
    }
    
    private func layoutButtons() {
        button1.centerVertically()
        button2.centerVertically()
        button3.centerVertically()
        button4.centerVertically()
    }
}
