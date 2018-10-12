//
//  XibView.swift
//  Exclusiv
//
//  Created by Thanh Tran on 12/30/16.
//  Copyright © 2016 SotaTek. All rights reserved.
//

import UIKit

class XibView: UIView {
    @IBOutlet var contentView: UIView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        contentView.forceConstraintToSuperview()
    }
}
