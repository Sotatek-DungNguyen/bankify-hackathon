//
//  GroupViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

class GroupViewController: AppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.tabBarController?.hidesBottomBarWhenPushed = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GroupDetailViewController
        
        if segue.identifier == "Eth" {
            vc.isEth = true
        }
    }
}
