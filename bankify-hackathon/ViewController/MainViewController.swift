//
//  ViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/12/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    fileprivate var internalTabBarController: UITabBarController {
        return children.first { $0 is UITabBarController } as! UITabBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internalTabBarController.tabBar.isHidden = true
        internalTabBarController.tabBar.layer.zPosition = -1
    }
}

extension MainViewController: HomeFooterDelegate {
    func onSelectTab(_ footer: HomeFooter, index: Int) {
        internalTabBarController.selectedIndex = index
    }
    
    func onShowMain() {
        
    }
}
