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
    
    @IBAction func onSelectTab(_ sender: UIButton) {
        delegate?.onSelectTab(self, index: sender.tag)
    }
    
    @IBAction func onSelectCenter(_ sender: UIButton) {
        delegate?.onShowMain()
    }
}
