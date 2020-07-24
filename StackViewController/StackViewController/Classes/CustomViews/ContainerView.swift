//
//  ContainerView.swift
//  StackViewController
//
//  Created by Aniruddha Das on 23/07/20.
//  Copyright © 2020 Cred. All rights reserved.
//

import Foundation
import UIKit

enum PanDirection {
    case panUp
    case panDown
}

protocol ContainerViewDelegate: class {
    func viewTapped(containerView: UIView, position: Int)
    func viewPanned(containerView: UIView, position: Int, direction: PanDirection)
}

class ContainerView<T:UIViewController>: UIView {
    private unowned var parentViewController: UIViewController
    private weak var currentController: T?
    weak var delegate: ContainerViewDelegate?
    private let position: Int
    
    init(parentController: UIViewController, position: Int) {
        self.parentViewController = parentController
        self.position = position
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func install(_ viewController: T) {
        pushViewController(viewController, animated: false)
    }
    
    func uninstall() {
        if let controller = currentController {
            removeViewController(controller)
            currentController = nil
        }
    }
    
    private func setUpViewController(_ targetViewController: T?, animated: Bool) {
        if let viewController = targetViewController {
            parentViewController.addChild(viewController)
            viewController.view.frame = self.bounds
            self.addSubview(viewController.view)
            viewController.didMove(toParent: parentViewController)
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTouched)))
            self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(viewDidPan)))
        }
    }
    
    @objc private func viewTouched() {
        delegate?.viewTapped(containerView: self, position: position)
    }
    
    @objc private func viewDidPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.state == .ended else {
            return
        }
        let velocity: CGPoint = gestureRecognizer.velocity(in: self)
        if velocity.y > 0 {
            //Moving Down
            delegate?.viewPanned(containerView: self, position: position, direction: .panDown)
        } else if velocity.y < 0 {
            //Moving Up
            delegate?.viewPanned(containerView: self, position: position, direction: .panUp)
        }
    }
    
    private func removeViewController(_ viewController: T?) {
        if let viewController = currentController {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    private func pushViewController(_ controller: T, animated: Bool) {
        removeViewController(currentController)
        currentController = controller
        setUpViewController(controller, animated: false)
    }
}
