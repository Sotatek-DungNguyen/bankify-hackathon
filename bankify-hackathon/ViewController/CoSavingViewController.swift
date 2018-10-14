//
//  CoSavingViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit
import Arrow
import RxSwift

class CoSavingViewController: UIViewController {
    @IBOutlet weak var lbCenterBalance: UILabel!
    @IBOutlet weak var waveView: YXWaveView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var group: GroupDto = GroupDto()
    private var isDataLoaded = false
    private var isDataLoading = false
    
    var isEth = false
    
    private let xOffset = [40, 200, 100, 290, 250]
    private let yOffset = [40, 20, 300, 190, 50]
    
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
        if !isDataLoading && !isDataLoaded {
            loadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        waveView.stop()
        isDataLoaded = false
    }
    
    func drawPaths() {
        containerView.removeAllSubviews()
        containerView.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        let total = self.group.members.map { isEth ? $0.ethAmount : $0.amount }.reduce(0, { $0 + $1 })
        lbCenterBalance.text = "\(total)\(isEth ? Utils.shared.cunit : Utils.shared.unit)"
        
        let center = centerView.center
        for (index, member) in group.members.enumerated() {
            addLine(fromPoint: CGPoint(x: xOffset[index] + 25, y: yOffset[index] + 55), toPoint: center)
            
            let view = MemberGroupView(frame: CGRect(x: xOffset[index], y: yOffset[index], width: 80, height: 80))
            view.backgroundColor = .clear
            view.clipsToBounds = true
            view.layer.masksToBounds = true
            view.set(amount: isEth ? member.ethAmount : member.amount, userId: member.id)
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
            if self.isEth {
                self.loadEth()
            }
            else {
                self.isDataLoading = false
                self.isDataLoaded = true
                DispatchQueue.main.async {
                    self.drawPaths()
                }
            }
        }) {
            [weak self] _ in
            self?.isDataLoading = false
            self?.isDataLoaded = true
        }
    }
    
    func loadEth() {
        var totalObservable: Observable<Double>!
        for i in 0..<5 {
            let observable: Observable<Double> = Observable.create {
                subscribe in
                makeRequest(method: .get, endPoint: "\(Utils.eth[i])/balance", completion: {
                    [weak self] json in
                    var amount: Double = 0
                    amount <-- json
                    subscribe.onNext(amount)
                    subscribe.onCompleted()
                    guard let `self` = self else { return }
                    self.group.members[i].ethAmount = amount
                }) {
                    error in
                    subscribe.onError(error)
                }
                
                return Disposables.create()
            }
            
            if totalObservable == nil {
                totalObservable = observable
            }
            else {
                totalObservable = Observable.zip(totalObservable, observable) {
                    x, y -> Double in
                    return x + y
                }
            }
        }
        
        _ = totalObservable.subscribe(
            onNext: {
                _ in
                
                self.isDataLoading = false
                self.isDataLoaded = true
                DispatchQueue.main.async {
                    self.drawPaths()
                }
            },
            onError: {
                [weak self] _ in
                self?.isDataLoading = false
                self?.isDataLoaded = true
            }
        )
    }
}
