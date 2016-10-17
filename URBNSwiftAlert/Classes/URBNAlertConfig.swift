//
//  URBNSwiftAlertConfig.swift
//  Pods
//
//  Created by Kevin Taniguchi on 10/9/16.
//
//

import UIKit

open class URBNSwiftAlertConfig: NSObject {
    /**
     *  Title text for the alert
     */
    open var title = ""

    /**
     *  Message text for the alert
     */
    open var message = ""

    /**
     *  Array of actions added to the alert
     */
    open var actions = [URBNSwiftAlertAction]()

    /**
     *  Array of UITextFields added to the array
     */
    open var inputs = [URBNTextField]()

    /**
     *  The view to present from when using showInView:
     */
    weak open var presentationView: UIView?

    /**
     *  Flag if the alert is active. False = a passive alert
     */
    open var isActiveAlert = true

    /**
     *  Duration of a passive alert (no buttons added)
     */
    open var duration = 3

    /**
     *  When set to YES, you can touch outside of an alert to dismiss it
     */
    open var shouldTouchOutsideToDismiss = true
}
