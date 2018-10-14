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
    func onEdit(_ cell: GroupDoubtTableViewCell, text: String?)
}

class GroupDoubtTableViewCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lbConfirmStat: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var index: Int = -1
    var confirmation: ConfirmationDto? {
        didSet {
            guard let confirmation = self.confirmation else {
                return
            }
            
            textField.placeholder = "\(confirmation.debtUsername) owed \(confirmation.ownerUsername)"
        }
    }
    
    weak var delegate: GroupDoubtTableViewCellDelegate?
    
    @IBAction func onConfirm(_ sender: UIButton) {
        btnConfirm.isHidden = true
        lbConfirmStat.text = "Confirmed"
        lbConfirmStat.isHidden = false
        
        delegate?.onConfirm(self)
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textField.isHidden = false
            lbTitle.isHidden = true
            textField.text = "\(confirmation?.amount ?? 0)"
            textField.becomeFirstResponder()
        }
        else {
            textField.isHidden = true
            lbTitle.isHidden = false
            textField.resignFirstResponder()
            delegate?.onEdit(self, text: textField.text)
        }
    }
}
