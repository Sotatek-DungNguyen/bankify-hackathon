//
//  GroupDetailViewController.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import UIKit
import LUNSegmentedControl

class GroupDetailViewController: AppViewController {
    
    @IBOutlet weak var segmentControl: LUNSegmentedControl!
    
    fileprivate lazy var internalPageViewController: UIPageViewController = {
        return children.first { $0 is UIPageViewController } as! UIPageViewController
    }()
    
    fileprivate lazy var internalViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoSavingViewController"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GroupDoubtViewController")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.internalPageViewController.setViewControllers([internalViewControllers[0]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GroupDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = internalViewControllers.firstIndex(of: viewController), index == 0 {
            return internalViewControllers[1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = internalViewControllers.firstIndex(of: viewController), index == 1 {
            return internalViewControllers[0]
        }
        
        return nil
    }
}

extension GroupDetailViewController: LUNSegmentedControlDelegate, LUNSegmentedControlDataSource {
    func numberOfStates(in segmentedControl: LUNSegmentedControl!) -> Int {
        return 2
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, titleForStateAt index: Int) -> String! {
        switch index {
        case 0:
            return "Co-saving"
        default:
            return "Debt"
        }
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, didChangeStateFromStateAt fromIndex: Int, toStateAt toIndex: Int) {
        self.internalPageViewController.setViewControllers([internalViewControllers[toIndex]], direction: (fromIndex < toIndex) ? .forward : .reserved, animated: true, completion: nil)
    }
}
