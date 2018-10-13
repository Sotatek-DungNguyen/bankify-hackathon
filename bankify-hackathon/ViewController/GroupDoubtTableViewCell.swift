//
//  GroupDoubtTableViewCell.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

protocol GroupDoubtTableViewCellDelegate: class {
    func onConfirm(_ cell: GroupDoubtTableViewCell)
}

class GroupDoubtTableViewCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var lbConfirmStat: UILabel!
    
    var index: Int = -1
    
    weak var delegate: GroupDoubtTableViewCellDelegate?
    
    @IBAction func onConfirm(_ sender: UIButton) {
        btnConfirm.isHidden = true
        lbConfirmStat.text = "Confirmed"
        lbConfirmStat.isHidden = false
        
        delegate?.onConfirm(self)
    }
}
