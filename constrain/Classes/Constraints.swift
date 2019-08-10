//  Created by Axel Ancona Esselmann on 5/5/18.
//  Copyright © 2018 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

public enum ConstraintIdentifier: String {
    case top =          ".top"
    case leading =      ".leading"
    case trailing =     ".trailing"
    case bottom =       ".bottom"
    case topSafe =      ".topSafe"
    case bottomSafe =   ".bottomSafe"
    case height =       ".height"
    case width =        ".width"
    case centerX =      ".centerX"
    case centerY =      ".centerY"
    case aspectRatio =  ".aspectRatio"
}

public enum YAxisIdentifier: RawRepresentable {
    public typealias RawValue = ConstraintIdentifier
    
    case top
    case centerY
    case bottom
    
    case topSafe
    case bottomSafe
    
    public init?(rawValue: ConstraintIdentifier) {
        switch rawValue {
        case .top:          self = .top
        case .bottom:       self = .bottom
        case .topSafe:      self = .topSafe
        case .bottomSafe:   self = .bottomSafe
        case .centerY:      self = .centerY
        default: return nil
        }
    }
    
    public var rawValue: ConstraintIdentifier {
        switch self {
        case .top: return .top
        case .centerY: return .centerY
        case .bottom: return .bottom
        case .topSafe: return .topSafe
        case .bottomSafe: return .bottomSafe
        }
    }
}

public enum XAxisIdentifier {
    case leading
    case centerX
    case trailing
}

public enum DimensionIdentifier {
    case width
    case height
    case aspectRatio
}

public typealias Relationship = NSLayoutConstraint.Relation

public typealias ConstraintSet = [NSLayoutConstraint]

/// Constraints is a container of layout constraints for a UIView. It has convenience methods for creating and retrieving constraints.
/// For improved readability constraint-creation methods can be chained.
/// Constraints are active on creation
/// Most methods allow the omission of an anchor or view to be passed in.
/// The superview is used when no view is passed in and the superview's respective anchor is used when the anchor is omitted.
public class Constraints {

    internal weak var view: UIView?
    internal var viewName: String
    private var constraints: [ConstraintIdentifier: NSLayoutConstraint] = [:]
    
    public var latestConstraint: NSLayoutConstraint?
    public var latestConstraints: ConstraintSet?

    internal init(view: UIView, name: String? = nil) {
        self.view = view
        self.viewName = name ?? String.init(describing: view.self)
    }

}

public extension UIView {
    /// Returns a Constraint instance which eases creation of NSLayoutConstraints.
    /// Save a reference to the Constraint instance for later access to the layout constraints.
    var constrain: Constraints {
        return Constraints(view: self)
    }
    
    func constrain(withName name: String) -> Constraints {
        return Constraints(view: self, name: name)
    }
}

extension Constraints {
    
    internal func applyAnchorConstraint<T>(anchor1: NSLayoutAnchor<T>,
                                           anchor2: NSLayoutAnchor<T>,
                                           identifier: ConstraintIdentifier,
                                           constant: CGFloat,
                                           relationship: Relationship = .equal,
                                           priority: UILayoutPriority) -> Constraints {
        let constraint: NSLayoutConstraint
        switch relationship {
        case .lessThanOrEqual: constraint = anchor1.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        case .greaterThanOrEqual: constraint = anchor1.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        default: constraint = anchor1.constraint(equalTo: anchor2, constant: constant)
        }
        constraint.priority = priority
        finalizeConstraint(constraint, identifier)
        return self
    }
    
    internal func applyAnchorConstraint(anchor2: NSLayoutYAxisAnchor?,
                                        identifier: YAxisIdentifier,
                                        constant: CGFloat,
                                        relationship: Relationship = .equal,
                                        priority: UILayoutPriority) -> Constraints {
        
        guard let view = view else {
            print("View fell out of memory.")
            return self
        }
        
        let superview = view.superview
        let anchor1: NSLayoutYAxisAnchor
        let defaultAnchor2: NSLayoutYAxisAnchor?
        
        switch  identifier {
        case .top:      anchor1 = view.topAnchor;       defaultAnchor2 = superview?.topAnchor
        case .bottom:   anchor1 = view.bottomAnchor;    defaultAnchor2 = superview?.bottomAnchor
        case .topSafe:  anchor1 = view.topAnchor;       defaultAnchor2 = superview?.topAnchorSafe
        case .bottomSafe: anchor1 = view.bottomAnchor;  defaultAnchor2 = superview?.bottomAnchorSafe
        case .centerY:  anchor1 = view.centerYAnchor;   defaultAnchor2 = superview?.centerYAnchor
        }
        guard let anchor2 = anchor2 ?? defaultAnchor2 else {
            print("No superview found.")
            return self
        }
        return applyAnchorConstraint(anchor1: anchor1, anchor2: anchor2, identifier: identifier.rawValue, constant: constant, relationship: relationship, priority: priority)
    }
    
    internal func applyDimensionConstraint(
        dimension: NSLayoutDimension,
        identifier: ConstraintIdentifier,
        constant: CGFloat,
        relationship: Relationship = .equal,
        priority: UILayoutPriority
    ) -> Constraints {
        let constraint: NSLayoutConstraint
        switch relationship {
        case .lessThanOrEqual: constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
        case .greaterThanOrEqual: constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
        default: constraint = dimension.constraint(equalToConstant: constant)
        }
        constraint.priority = priority
        finalizeConstraint(constraint, identifier)
        return self
    }
    
    internal func applyDimensionMultiplier(
        dimension1: NSLayoutDimension,
        dimension2: NSLayoutDimension,
        identifier: ConstraintIdentifier,
        constant: CGFloat,
        multiplier: CGFloat = 1,
        relationship: Relationship = .equal,
        priority: UILayoutPriority
    ) -> Constraints {
        let constraint: NSLayoutConstraint
        switch relationship {
        case .lessThanOrEqual: constraint = dimension1.constraint(lessThanOrEqualToConstant: constant)
        case .greaterThanOrEqual: constraint = dimension1.constraint(greaterThanOrEqualToConstant: constant)
        default: constraint = dimension1.constraint(equalToConstant: constant)
        }
        // for some reason anchor constraint initializers can either take multiplier or constant but not both
        // multiplier is immutable, so I'm just setting constant after initializing
        constraint.constant = constant
        constraint.priority = priority
        finalizeConstraint(constraint, identifier)
        return self
    }
    
    fileprivate func finalizeConstraint(_ constraint: NSLayoutConstraint, _ identifier: ConstraintIdentifier) {
        view?.translatesAutoresizingMaskIntoConstraints = false
        constraint.isActive = true
        let identifier = ConstraintIdentifier.aspectRatio
        constraint.identifier = viewName + identifier.rawValue
        constraints[identifier] = constraint // TODO: deactivate any existing before overwriting, or allow more than one of same identifier
        latestConstraint = constraint
    }
    
    /// When storing a reference to a Constraints instance this method allows to retrieve a respective constraint.
    public func layoutConstraintWithIdentifier(_ identifier: ConstraintIdentifier) -> NSLayoutConstraint? {
        return constraints[identifier]
    }
    
    /// When storing a reference to a Constraints instance this method allows to set the constant of a respective constraint.
    public func setConstant(_ constant: CGFloat, forIdentifier identifier: ConstraintIdentifier) {
        layoutConstraintWithIdentifier(identifier)?.constant = constant
    }

}
