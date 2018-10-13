//
//  GroupDoubtViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit
import Arrow

class GroupDoubtViewController: AppViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbConfim: UILabel!
    @IBOutlet weak var btnResolve: UIButton!

    fileprivate var isResolve = false
    
    fileprivate var confirmations: [ConfirmationDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        updateConfirmLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func updateConfirmLabel() {
        let confirmAmount = confirmations.filter { $0.isConfirm }.count
        lbConfim.text = "\(confirmAmount) / \(confirmations.count)"
    }
    
    @IBAction func onResolve(_ sender: UIButton) {
        makeRequest(method: .get, endPoint: "getgroupcashfolow", completion: {
            [weak self] json in
            guard let `self` = self else { return }
            self.confirmations <-- json
            self.isResolve = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func loadData() {
        confirmations = []
        makeRequest(method: .get, endPoint: "getgroup", completion: {
            [weak self] json in
            guard let `self` = self else { return }
            var group: GroupDto = GroupDto()
            group <-- json
            let members = group.members
            for member in members {
                for dept in member.debts {
                    let confirmation = ConfirmationDto(owerId: dept.id, debtUserId: member.id, amount: dept.amount, ownerUsername: members.first { $0.id == dept.id }?.name ?? "", deubtUsername: member.name, isConfirm: true)
                    self.confirmations.append(confirmation)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell0", for: indexPath) as! GroupDoubtTableViewCell
        let confirmation = confirmations[indexPath.row]
        
        if isResolve {
            cell.lbTitle.text = "\(confirmation.ownerUsername) must send \(Utils.shared.unit)\(confirmation.amount) to \(confirmation.deubtUsername)"
            cell.delegate = nil
        }
        else {
            cell.lbTitle.text = "\(confirmation.ownerUsername) owed \(confirmation.deubtUsername) \(Utils.shared.unit)\(confirmation.amount)"
            cell.delegate = self
        }
        
        cell.index = indexPath.row
        
//        if confirmation.isMyTransaction {
//            if confirmation.isConfirm {
//                cell.btnConfirm.isHidden = true
//                cell.lbConfirmStat.isHidden = false
//                cell.lbConfirmStat.text = "Confirmed"
//            }
//            else {
//                cell.btnConfirm.isHidden = false
//                cell.lbConfirmStat.isHidden = true
//            }
//        }
//        else {
//            cell.btnConfirm.isHidden = true
//            cell.lbConfirmStat.isHidden = false
//            cell.lbConfirmStat.text = confirmation.isConfirm ? "Confirmed" : "Unconfirmed"
//            cell.lbConfirmStat.isHighlighted = confirmation.isConfirm
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension GroupDoubtViewController: GroupDoubtTableViewCellDelegate {
    func onConfirm(_ cell: GroupDoubtTableViewCell) {
//        confirmations[cell.index].isConfirm = true
        
//        updateConfirmLabel()
    }
}
