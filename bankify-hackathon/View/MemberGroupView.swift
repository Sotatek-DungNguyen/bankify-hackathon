//
//  MemberGroupView.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class MemberGroupView: XibView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var lbBalance: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(amount: Double, userId: Int) {
        lbBalance.text = "\(amount)"
        avatarImageView.image = UIImage(named: "avaUser\(userId)")
    }
}
