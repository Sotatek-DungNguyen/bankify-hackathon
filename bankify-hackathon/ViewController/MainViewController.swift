//
//  ViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/12/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var footerView: HomeFooter!
    @IBOutlet weak var newActionView: NewActionView!

    fileprivate var internalTabBarController: UITabBarController {
        return children.first { $0 is UITabBarController } as! UITabBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internalTabBarController.tabBar.isHidden = true
        internalTabBarController.tabBar.layer.zPosition = -1
        
        self.view.bringSubviewToFront(footerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap(_ gesture: UITapGestureRecognizer) {
        newActionView.isHidden = true
    }
}

extension MainViewController: HomeFooterDelegate {
    func onSelectTab(_ footer: HomeFooter, index: Int) {
        internalTabBarController.selectedIndex = index
    }
    
    func onShowMain() {
        if internalTabBarController.selectedIndex > 1 {
            newActionView.isHidden = !newActionView.isHidden
        }
    }
}

extension MainViewController: NewActionViewDelegate {
    func onNewGoal(_ footer: NewActionView) {
        
    }
    
    func onNewActivity(_ footer: NewActionView) {
        
    }
}
