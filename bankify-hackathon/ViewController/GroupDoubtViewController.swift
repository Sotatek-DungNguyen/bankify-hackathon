//
//  GroupDoubtViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

class GroupDoubtViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbConfim: UILabel!

    fileprivate var confirmations: [ConfirmationDto] = [
        ConfirmationDto(owerId: 1, deubtUserId: 2, amount: 1, ownerUsername: "Abc", deubtUsername: "Xyz", isConfirm: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateConfirmLabel()
    }
    
    func updateConfirmLabel() {
        let confirmAmount = confirmations.filter { $0.isConfirm }.count
        lbConfim.text = "\(confirmAmount) / \(confirmations.count)"
    }
}

extension GroupDoubtViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return confirmations.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupDoubtTableViewCell
        let confirmation = confirmations[indexPath.row]
        
        cell.lbTitle.text = "\(confirmation.ownerUsername) owed \(confirmation.deubtUsername) \(confirmation.amount)"
        cell.delegate = self
        cell.index = indexPath.row
        
        if confirmation.isMyTransaction {
            if confirmation.isConfirm {
                cell.btnConfirm.isHidden = true
                cell.lbConfirmStat.isHidden = false
                cell.lbConfirmStat.text = "Confirmed"
            }
            else {
                cell.btnConfirm.isHidden = false
                cell.lbConfirmStat.isHidden = true
            }
        }
        else {
            cell.btnConfirm.isHidden = true
            cell.lbConfirmStat.isHidden = false
            cell.lbConfirmStat.text = confirmation.isConfirm ? "Confirmed" : "Unconfirmed"
            cell.lbConfirmStat.isHighlighted = confirmation.isConfirm
        }
        
        return cell
    }
}

extension GroupDoubtViewController: GroupDoubtTableViewCellDelegate {
    func onConfirm(_ cell: GroupDoubtTableViewCell) {
        confirmations[cell.index].isConfirm = true
        
        updateConfirmLabel()
    }
}
