//
//  CoSavingViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit
import Arrow

class CoSavingViewController: UIViewController {
    @IBOutlet weak var lbCenterBalance: UILabel!
    @IBOutlet weak var waveView: YXWaveView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var group: GroupDto = GroupDto()
    var isDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView.realWaveColor = UIColor(red: 96 / 255.0, green: 195 / 255.0, blue: 1, alpha: 1)
        waveView.maskWaveColor = UIColor(red: 80 / 255.0, green: 189 / 255.0, blue: 1, alpha: 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        waveView.start()
        if !isDataLoading {
            loadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        waveView.stop()
    }
    
    func drawPaths() {
        containerView.removeAllSubviews()
        let total = self.group.members.map { $0.amount }.reduce(0, { $0 + $1 })
        lbCenterBalance.text = "\(total)"
        
        let center = centerView.center
        
    }
    
    func loadData() {
        isDataLoading = true
        makeRequest(method: .get, endPoint: "getgroup2", completion: {
            [weak self] json in
            guard let `self` = self else { return }
            self.group <-- json
            self.isDataLoading = false
            DispatchQueue.main.async {
                self.drawPaths()
            }
        }) {
            [weak self] _ in
            self?.isDataLoading = false
        }
    }
}
