//
//  GroupDoubtViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit
import Arrow
import PullToRefresh
import Alamofire

class GroupDoubtViewController: AppViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbConfim: UILabel!
    @IBOutlet weak var btnResolve: UIButton!

    fileprivate var isResolve = false
    fileprivate var isDataLoading = false
    
    fileprivate var confirmations: [ConfirmationDto] = []
    
    deinit {
        tableView?.removeAllPullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        updateConfirmLabel()
        let refresher = PullToRefresh()
        tableView.addPullToRefresh(refresher) {
            [weak self] in
            self?.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isResolve {
            loadData()
        }
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
        if isDataLoading {
            return
        }
        isDataLoading = true
        makeRequest(method: .get, endPoint: "getgroup", completion: {
            [weak self] json in
            guard let `self` = self else { return }
            var group: GroupDto = GroupDto()
            group <-- json
            let members = group.members
            self.confirmations = []
            self.isResolve = false
            for member in members {
                for dept in member.debts {
                    let confirmation = ConfirmationDto(ownerId: dept.id, debtUserId: member.id, amount: dept.amount, ownerUsername: members.first { $0.id == dept.id }?.name ?? "", deubtUsername: member.name, isConfirm: true)
                    self.confirmations.append(confirmation)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.endRefreshing(at: .top)
                self.isDataLoading = false
            }
        }) {
            [weak self] _ in
            self?.isDataLoading = false
            self?.tableView.endRefreshing(at: .top)
        }
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
        
        cell.confirmation = confirmation
        cell.textField.isHidden = true
        
        if isResolve {
            cell.lbTitle.text = "\(confirmation.debtUsername) must send \(Utils.shared.unit)\(confirmation.amount) to \(confirmation.ownerUsername)"
            cell.delegate = nil
            cell.btnEdit?.isHidden = true
        }
        else {
            cell.lbTitle.text = "\(confirmation.debtUsername) owed \(confirmation.ownerUsername) \(Utils.shared.unit)\(confirmation.amount)"
            cell.delegate = self
            cell.btnEdit?.isHidden = !confirmation.isMyOwe
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
    
    func onEdit(_ cell: GroupDoubtTableViewCell, text: String?) {
        if let text = text, let optionalAmount = try? Double(text), let amount = optionalAmount {
            confirmations[cell.index].amount = amount
            self.tableView.reloadData()
            
            var params: [String: Any] = [
                "id": Utils.shared.userId
            ]
            
            var debts: [[String: Any]] = []
            let owes = confirmations.filter { $0.isMyOwe }
            for owe in owes {
                let debt: [String : Any] = [
                    "id": owe.ownerId,
                    "amount": owe.amount
                    ]
                debts.append(debt)
            }
            
            params["debts"] = debts
            print(debts)
            
            makeRequest(method: .post, endPoint: "updategroup", params: params, encoding: JSONEncoding.default, completion: {
                json in
                print("Update OK")
            })
        }
    }
}
