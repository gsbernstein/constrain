//
//  Extensions.swift
//  constrain
//
//  Created by Greg on 8/10/19.
//

import UIKit

public extension UIViewController {
    @discardableResult
    func constrainSubview(_ viewController: UIViewController) -> Constraints {
        view.addSubviewSafely(viewController.view)
        return viewController.view.constrain
    }
    
    @discardableResult
    func constrainSubview(_ subview: UIView) -> Constraints {
        view.addSubviewSafely(subview)
        return subview.constrain
    }
    
    // MARK - VC child/parent management
    @discardableResult
    func constrainChild(_ viewController: UIViewController, to view2: UIView? = nil) -> Constraints {
        let superview: UIView = view2 ?? view
        self.addChild(viewController)
        superview.addSubviewSafely(viewController.view)
        viewController.didMove(toParent: self)
        return viewController.view.constrain
    }
    
    @discardableResult
    func remove() -> Constraints {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        return self.view.constrain
    }
    
}

public extension UIView {
    @discardableResult
    func constrainSubview(_ viewController: UIViewController) -> Constraints {
        addSubviewSafely(viewController.view)
        return viewController.view.constrain
    }
    
    @discardableResult
    func constrainSubview(_ subview: UIView) -> Constraints {
        addSubviewSafely(subview)
        return subview.constrain
    }
    
    @discardableResult
    func constrainIn(_ superview: UIView) -> Constraints {
        superview.addSubviewSafely(self)
        return self.constrain
    }
    
    @discardableResult
    func constrainSibling(_ sibling: UIView) -> Constraints {
        if let superview = superview {
            superview.addSubviewSafely(sibling)
        } else {
            print("Attempting to constrain sibling without a superview.")
        }
        return sibling.constrain
    }
    
    @discardableResult
    func constrainSiblingToTrailing(_ sibling: UIView,
                                    constant: CGFloat = 0,
                                    by relationship: Relationship = .equal,
                                    priority: UILayoutPriority = .required) -> Constraints {
        return constrainSibling(sibling).leading(to: self.trailingAnchor, constant: constant, by: relationship, priority: priority)
    }
    
    @discardableResult
    func constrainSiblingToBottom(_ sibling: UIView,
                                  constant: CGFloat = 0,
                                  by relationship: Relationship = .equal,
                                  priority: UILayoutPriority = .required) -> Constraints {
        return constrainSibling(sibling).top(to: self.bottomAnchor, constant: constant, by: relationship, priority: priority)
    }
    
}

extension UIView {
    public func refresh() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension Constraints {
    @discardableResult
    public func refresh() -> Self {
        view?.refresh()
        return self
    }
}

extension UIView {
    func addSubviewSafely(_ subview: UIView) {
        guard subview != self else {
            assertionFailure("can't add view as subview of itself")
            return
        }
        addSubview(subview)
    }
}
