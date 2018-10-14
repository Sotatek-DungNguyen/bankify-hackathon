//
//  CollectViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit
import Arrow

class CollectViewController: AppViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbCenterBalance: UILabel!
    @IBOutlet weak var bottleView: UIView!
    @IBOutlet weak var waveView: YXWaveView!
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var group: GroupDto = GroupDto()
    private var isDataLoaded = false
    private var isDataLoading = false
    
    private let xOffset = [40, 200, 100, 290, 250]
    private let yOffset = [40, 20, 300, 190, 50]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView.realWaveColor = UIColor(red: 96 / 255.0, green: 195 / 255.0, blue: 1, alpha: 1)
        waveView.maskWaveColor = UIColor(red: 80 / 255.0, green: 189 / 255.0, blue: 1, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        waveView.start()
        
        if !isDataLoading && !isDataLoaded {
            loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        waveView.stop()
        isDataLoaded = false
    }

    @IBAction func onCollection(_ sender: UIButton) {
        
    }

    func drawPaths() {
        containerView.removeAllSubviews()
        containerView.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        let total = self.group.members.map { $0.amount }.reduce(0, { $0 + $1 })
        lbCenterBalance.text = "\(total)"
        
        let center = bottleView.center
        for (index, member) in group.members.enumerated() {
            addLine(fromPoint: CGPoint(x: xOffset[index] + 25, y: yOffset[index] + 55), toPoint: center)
            
            let view = MemberGroupView(frame: CGRect(x: xOffset[index], y: yOffset[index], width: 80, height: 80))
            view.backgroundColor = .clear
            view.clipsToBounds = true
            view.layer.masksToBounds = true
            view.set(amount: member.amount, userId: member.id)
            self.containerView.addSubview(view)
        }
    }
    
    func addLine(fromPoint start: CGPoint, toPoint end: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor(red: 96 / 255.0, green: 195 / 255.0, blue: 1, alpha: 1).cgColor
        line.lineWidth = 2
        line.lineJoin = .round
        self.containerView.layer.addSublayer(line)
    }
    
    func loadData() {
        isDataLoading = true
        makeRequest(method: .get, endPoint: "getgroup2", completion: {
            [weak self] json in
            guard let `self` = self else { return }
            self.group <-- json
            self.isDataLoading = false
            self.isDataLoaded = true
            DispatchQueue.main.async {
                self.drawPaths()
            }
        }) {
            [weak self] _ in
            self?.isDataLoading = false
            self?.isDataLoaded = true
        }
    }
}
