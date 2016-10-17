//
//  URBNSwiftAlertAction.swift
//  Pods
//
//  Created by Kevin Taniguchi on 9/27/16.
//
//

import Foundation

public enum URBNSwiftAlertActionType {
    case normal
    case destructive
    case cancel
    case passive
}

public typealias URBNSwiftAlertCompletion = (URBNSwiftAlertAction) -> Void

open class URBNSwiftAlertAction {
    var title = ""
    var dismissOnCompletion = true
    var isSelected = false
    var isButton: Bool {
        return self.actionType != .passive
    }

    var isEnabled: Bool = false {
        didSet {
            if isButton, actionType != .cancel, let actionButton = actionButton {
                actionButton.isEnabled = isEnabled
                styleButton(actionButton: actionButton, isEnabled: isEnabled)
            }
        }
    }

    var actionType: URBNSwiftAlertActionType = .normal
    var actionButton: URBNSwiftAlertActionButton?
    var completionBlock: URBNSwiftAlertCompletion?

    static func actionWithTitle(title: String, actionType: URBNSwiftAlertActionType, completion: @escaping URBNSwiftAlertCompletion) -> URBNSwiftAlertAction {
        return URBNSwiftAlertAction(title: title, actionType: actionType, dismissOnCompletion: true, completion: completion)
    }

    static func actionWithTitle(title: String, actionType: URBNSwiftAlertActionType, dismissOnCompletion: Bool, completion: @escaping URBNSwiftAlertCompletion) -> URBNSwiftAlertAction {
        return URBNSwiftAlertAction(title: title, actionType: actionType, dismissOnCompletion: dismissOnCompletion, completion: completion)
    }

    public init(title: String, actionType: URBNSwiftAlertActionType, dismissOnCompletion: Bool, completion: URBNSwiftAlertCompletion?) {
        self.title = title
        self.actionType = actionType
        self.dismissOnCompletion = dismissOnCompletion
        self.completionBlock = completion
    }

    func styleButton(actionButton: URBNSwiftAlertActionButton, isEnabled: Bool) {
        let titleColor = actionButton.alertStyler.buttonTitleColorForActionType(actionType: actionButton.actionType, isEnabled: isEnabled)
        let bgColor = actionButton.alertStyler.buttonBackgroundColorForActionType(actionType: actionButton.actionType, isEnabled: isEnabled)

        actionButton.setTitleColor(titleColor, for: .normal)
        actionButton.backgroundColor = bgColor
        actionButton.alpha = isEnabled ? 1.0 : CGFloat(actionButton.alertStyler.disabledButtonAlpha)
    }
}

