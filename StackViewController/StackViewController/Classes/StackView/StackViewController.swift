//
//  HomeVC.swift
//  CredAssignment
//
//  Created by Aniruddha Das on 22/07/20.
//  Copyright © 2020 Cred. All rights reserved.
//

import UIKit

public class StackViewController: UIViewController {
    @IBOutlet private weak var verticalStackView: UIStackView!
    
    private var animationRunning: Bool = false
    private var containerViews = [ContainerView]()
    private var heightConstraints: [NSLayoutConstraint] = []
    private let subViewControllers: [UIViewController]
    private let collapsedHeight: CGFloat = 60
    private var currentExpandedPosition: Int?
    
    public init(subViewControllers: [UIViewController]) {
        self.subViewControllers = subViewControllers
        super.init(nibName: "StackViewController", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainers()
    }
    
    private func removeContainers() {
        verticalStackView.removeAllArrangedSubviews()
        
        for container in containerViews {
            container.uninstall()
        }
        containerViews.removeAll()
    }
    
    private func setupContainers() {
        removeContainers()
        
        guard !subViewControllers.isEmpty else {
            return
        }
        
        for (index, vc) in subViewControllers.enumerated() {
            addVC(vc, position: index)
        }
        //verticalStackView.addArrangedSubview(UIView())
        defaultExpandFirst()
    }
    
    private func addVC(_ viewController: UIViewController, position: Int) {
        let containerView = ContainerView(parentController: self, position: position)
        
        containerView.delegate = self
        let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: collapsedHeight)
        heightConstraint.isActive = false
        heightConstraints.append(heightConstraint)
        containerView.isHidden = true
        
        containerView.install(viewController)
        verticalStackView.addArrangedSubview(containerView)
        containerViews.append(containerView)
    }
    
    private func defaultExpandFirst() {
        heightConstraints.first?.isActive = false
        containerViews.first?.isHidden = false
        currentExpandedPosition = 0
        
        if containerViews.count > 1 {
            heightConstraints[1].isActive = true
            containerViews[1].isHidden = false
        }
        
        verticalStackView.layoutIfNeeded()
    }
}

extension StackViewController: ContainerViewDelegate {
    private func adjustAllViews(currentPosition: Int) {
        guard containerViews[currentPosition].frame.height == collapsedHeight else {
            //Ignore if already expanded.
            return
        }
        
        for (index, _) in containerViews.enumerated() {
            if index < currentPosition {
                //previous all views to remain collapsed
                heightConstraints[index].isActive = true
                containerViews[index].isHidden = false
            } else if index == currentPosition {
                //Current view to be expanded
                heightConstraints[currentPosition].isActive = false
                containerViews[currentPosition].isHidden = false
                currentExpandedPosition = currentPosition
            } else if index == currentPosition + 1 {
                //Next view to expand
                heightConstraints[index].isActive = true
                containerViews[index].isHidden = false
            } else if index > currentPosition {
                //Remaining view to hide
                heightConstraints[index].isActive = false
                containerViews[index].isHidden = true
            }
        }
    }
    
    func viewTapped(containerView: UIView, position: Int) {
        guard !animationRunning else {
            return
        }
        
        adjustAllViews(currentPosition: position)
        
        animationRunning = true
        UIView.animate(withDuration: 1, animations: {
            self.verticalStackView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.animationRunning = false
        })
    }
    
    func viewPanned(containerView: UIView, position: Int, direction: PanDirection) {
        guard let currentExpansedPosition = currentExpandedPosition, containerViews[position].frame.height == collapsedHeight else {
            //Ignore if already expanded.
            return
        }
        
        guard (position < currentExpansedPosition && direction == .panDown) else {
            return
        }
        
        //Only for views above current expanded view, with pan down.
        viewTapped(containerView: containerView, position: position)
    }
}
