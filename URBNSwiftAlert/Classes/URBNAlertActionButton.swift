//
//  URBNSwiftAlertActionButton.swift
//  Pods
//
//  Created by Kevin Taniguchi on 9/27/16.
//
//

import UIKit

open class URBNSwiftAlertActionButton: UIButton {
    var actionType: URBNSwiftAlertActionType = .normal
    var alertStyler = URBNSwiftAlertStyle()

    override open var isHighlighted: Bool {
        set {
            switch actionType {
            case .destructive:
                backgroundColor = isHighlighted ? alertStyler.destructiveButtonHighlightBackgroundColor: alertStyler.destructionButtonBackgroundColor
            case .cancel:
                backgroundColor = isHighlighted ? alertStyler.cancelButtonHighlightBackgroundColor: alertStyler.cancelButtonBackgroundColor
            default:
                backgroundColor = isHighlighted ? alertStyler.buttonHighlightBackgroundColor : alertStyler.buttonBackgroundColor
            }
        }
        get {
            return super.isHighlighted
        }
    }

    override open var isSelected: Bool {
        set {
            backgroundColor = isSelected ? alertStyler.buttonSelectedBackgroundColor : alertStyler.buttonBackgroundColorForActionType(actionType: actionType, isEnabled: isEnabled)
        }
        get {
            return super.isSelected
        }
    }
    
}
