//
//  SafeArea.swift
//  constrain
//
//  Created by Greg2 on 8/10/19.
//

import Foundation

// Safe areas
public extension UIView {
    var topAnchorSafe: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    var bottomAnchorSafe: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    var centerXAnchorSafe: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.centerXAnchor
        } else {
            return centerXAnchor
        }
    }
    
    var centerYAnchorSafe: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.centerYAnchor
        } else {
            return centerYAnchor
        }
    }
}

public extension Constraints {
    
    /// Constrain the view to the top safe area of the superview.
    @discardableResult
    func topSafe(_ constant: CGFloat = 0.0, by relationship: Relationship = .equal, priority: UILayoutPriority = .required) -> Constraints {
        guard let view = view,
              let anchor = view.superview?.topAnchorSafe
        else {
            print("Attempting to create top constraint without a reference anchor.")
            return self
        }
        return applyAnchorConstraint(anchor1: view.topAnchor, anchor2: anchor, identifier: .top, constant: constant, relationship: relationship, priority: priority)
    }
    
    /// Constrain the view to the bottom safe area of the superview.
    @discardableResult
    func bottomSafe(_ constant: CGFloat = 0.0, by relationship: Relationship = .equal, priority: UILayoutPriority = .required) -> Constraints {
        guard let view = view,
              let anchor = view.superview?.bottomAnchorSafe
        else {
            print("Attempting to create bottom constraint without a reference anchor.")
            return self
        }
        return applyAnchorConstraint(anchor1: view.bottomAnchor, anchor2: anchor, identifier: .bottom, constant: -constant, relationship: relationship, priority: priority)
    }
    
    @discardableResult @available(iOS 15.0, *)
    func pinToKeyboard(padding: CGFloat = 0.0, by relationship: Relationship = .equal, priority: UILayoutPriority = .required) -> Constraints {
        guard let view = view,
              let anchor = view.superview?.keyboardLayoutGuide.topAnchor
        else {
            print("Attempting to create keyboard constraint without a reference anchor.")
            return self
        }
        return applyAnchorConstraint(anchor1: view.bottomAnchor, anchor2: anchor, identifier: .bottom, constant: -padding, relationship: relationship, priority: priority)
    }
    
    /// iOS 11 introduced safe area layout constraints.
    /// When filling the native UIViewController view, consider a method that aligns to the safe area.
    @discardableResult
    func fillHeightSafely(of view: UIView? = nil, constant: CGFloat = 0.0) -> Constraints {
        guard let viewToFill = view ?? self.view?.superview else {
            print("Attempting to fill height without reference view or superview.")
            return self
        }
        return self
            .top(to: viewToFill.topAnchorSafe, constant: constant)
            .bottom(to: viewToFill.bottomAnchorSafe, constant: constant)
    }
    
    /// iOS 11 introduced safe area layout constraints.
    /// When filling the native UIViewController view, consider a method that aligns to the safe area.
    @discardableResult
    func fillSafely(_ view: UIView? = nil, constant: CGFloat = 0.0) -> Constraints {
        return self
            .fillWidth(of: view, constant: constant)
            .fillHeightSafely(of: view, constant: constant)
    }
    
    /// Constrain the view to the center of a view or to that of the superview when no view is provided.
    @discardableResult
    func centerSafely(in view: UIView? = nil, constant: CGFloat = 0.0) -> Constraints {
        guard let viewToFill = view ?? self.view?.superview else {
            print("Attempting to center view without reference view or superview.")
            return self
        }
        return self
            .centerX(equalTo: viewToFill.centerXAnchorSafe, constant: constant)
            .centerY(equalTo: viewToFill.centerYAnchorSafe, constant: constant)
    }
    
    /// Constrain the view to a layout anchor or to the horizontal center point of the superview when no anchor is provided.
    @discardableResult
    func centerXSafely(in view2: UIView? = nil, constant: CGFloat = 0.0, by relationship: Relationship = .equal, priority: UILayoutPriority = .required) -> Constraints {
        guard
            let view = view,
            let anchor = view2?.centerXAnchorSafe ?? view.superview?.centerXAnchor
        else {
            print("Attempting to create centerX constraint without a reference anchor.")
            return self
        }
        return applyAnchorConstraint(anchor1: view.centerXAnchor, anchor2: anchor, identifier: .centerX, constant: constant, relationship: relationship, priority: priority)
    }
    
    /// Constrain the view to a layout anchor or to the vertical center point of the superview when no anchor is provided.
    @discardableResult
    func centerYSafely(in view2: UIView? = nil, constant: CGFloat = 0.0, by relationship: Relationship = .equal, priority: UILayoutPriority = .required) -> Constraints {
        guard
            let view = view,
            let anchor = view2?.centerYAnchorSafe ?? view.superview?.centerYAnchorSafe
        else {
            print("Attempting to create centerY constraint without a reference anchor.")
            return self
        }
        return applyAnchorConstraint(anchor1: view.centerYAnchor, anchor2: anchor, identifier: .centerY, constant: constant, relationship: relationship, priority: priority)
    }
}
