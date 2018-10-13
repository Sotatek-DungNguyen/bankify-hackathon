//
//  CollectViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

class CollectViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbCenterBalance: UILabel!
    @IBOutlet weak var bottleView: UIView!
    @IBOutlet weak var waveView: YXWaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView.realWaveColor = UIColor(red: 96 / 255.0, green: 195 / 255.0, blue: 1, alpha: 1)
        waveView.maskWaveColor = UIColor(red: 80 / 255.0, green: 189 / 255.0, blue: 1, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        waveView.start()
    }

    @IBAction func onCollection(_ sender: UIButton) {
        
    }

}
