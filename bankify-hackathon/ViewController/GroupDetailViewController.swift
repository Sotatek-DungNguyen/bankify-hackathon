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
        self.internalPageViewController.delegate = self
        self.internalPageViewController.dataSource = self
        self.segmentControl.shadowsEnabled = false
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let vc = previousViewControllers.first, let index = internalViewControllers.firstIndex(of: vc) {
            self.segmentControl.currentState = 1 - index
        }
    }
}

extension GroupDetailViewController: LUNSegmentedControlDelegate, LUNSegmentedControlDataSource {
    func numberOfStates(in segmentedControl: LUNSegmentedControl!) -> Int {
        return 2
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, attributedTitleForStateAt index: Int) -> NSAttributedString! {
        switch index {
        case 0:
            return NSMutableAttributedString(string: "Co-saving", attributes: [
                .font: UIFont(name: "Futura", size: 14)
            ])
        default:
            return NSMutableAttributedString(string: "Debt", attributes: [
                .font: UIFont(name: "Futura", size: 14)
            ])
        }
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, didChangeStateFromStateAt fromIndex: Int, toStateAt toIndex: Int) {
        self.internalPageViewController.setViewControllers([internalViewControllers[toIndex]], direction: (fromIndex < toIndex) ? .forward : .reverse, animated: true, completion: nil)
    }
}
