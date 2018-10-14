//
//  PayActivityViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/14/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit

class PayActivityViewController: AppViewController {
    @IBOutlet weak var textField: UITextField!
    
    fileprivate var isPaid = false
    var onDismiss: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        onDismiss?(self.isPaid)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPay(_ sender: UIButton) {
        makeRequest(method: .post, endPoint: "events", completion: {
            [weak self] json in
            guard let `self` = self else { return }
            self.isPaid = true
            
            print("Pay OK")
        })
    }
    
    @IBAction func onScan(_ sender: UIButton) {
        
    }
}
