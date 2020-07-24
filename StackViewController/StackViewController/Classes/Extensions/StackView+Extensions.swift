//
//  StackView+Extensions.swift
//  StackViewController
//
//  Created by Aniruddha Das on 23/07/20.
//  Copyright © 2020 Cred. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        //Deactivate all constraints
        //NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        //Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
