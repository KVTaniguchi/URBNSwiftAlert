//
//  URBNSwiftAlertController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 10/9/16.
//
//

import Foundation
import URBNConvenience

typealias AlertButtonTouched = (_ alertController: URBNSwiftAlertController, _ index: Int) -> Void

open class URBNSwiftAlertController: NSObject {
    open static let sharedInstance = URBNSwiftAlertController()

    /**
     *  Create & set this property if you wish to customize various properties of the alert view.
     *  If none is passed, default values are used. See URBNAlertStyle for properties you can configue & default values.
     */
    open var alertStyler: URBNSwiftAlertStyle {
        get {
            return alertStyler ?? URBNSwiftAlertStyle()
        }
        set {}
    }

    open func dismissAlertViewController(avc: URBNSwiftAlertViewController) {
        alertIsVisible = false
        avc.dismiss()
        showNextAlert()
    }

    open func dismissingAlert() {
        alertIsVisible = false
        popQueue()
        showNextAlert()
    }

    open func addAlertToQueueWithAlertViewController(avc: URBNSwiftAlertViewController) {
        queue.append(avc)
        showNextAlert()
    }

    fileprivate var alertIsVisible = false
    fileprivate var queue = [URBNSwiftAlertViewController]()
    fileprivate var peekQueue: URBNSwiftAlertViewController? {
        return queue.first
    }
    fileprivate var alertWindow: UIWindow?
    open var presentingWindow = UIApplication.shared.windows.first

    open func showNextAlert() {
        guard alertIsVisible == false, let alertViewController = queue.first else { return }
        alertIsVisible = true

        alertViewController.finishedDismissingClosure = {[unowned self] wasTouchedOutside in
            if wasTouchedOutside {
                self.dismissingAlert()
            }
            // If the queue is empty, remove the window. If not keep visible to present next alert(s)
            if self.queue.isEmpty {
                self.presentingWindow?.makeKeyAndVisible()
                self.alertWindow?.isHidden = true
                //                self.alertWindow = nil
            }
        }

        alertViewController.alertView?.buttonTouchedBlock = {[unowned self] action in
            action.completionBlock?(action)

            if action.dismissOnCompletion {
                self.dismissAlertViewController(avc: alertViewController)
            }
        }

        alertViewController.alertView?.alertViewTouchedClosure = {[unowned self] action in
            action.completionBlock?(action)

            self.dismissAlertViewController(avc: alertViewController)
        }

        // showInView: used
        if let presentationView = alertViewController.alertConfig.presentationView {
            var rect = alertViewController.view.frame
            rect.size.width = presentationView.width
            rect.size.height = presentationView.height
            alertViewController.view.frame = rect
            alertViewController.alertConfig.presentationView?.addSubview(alertViewController.view)
        }
        else {
            setUpAlertWindow()
            alertWindow?.rootViewController = alertViewController
            alertWindow?.makeKeyAndVisible()
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self)

        if !alertViewController.alertConfig.isActiveAlert {
            let duration = alertViewController.alertConfig.duration == 0 ? calculateDuration(config: alertViewController.alertConfig) : CGFloat(alertViewController.alertConfig.duration)
            perform(#selector(dismissAlertViewController(avc:)) , with: alertViewController, afterDelay: TimeInterval(duration))
        }
    }

    open func setUpAlertWindow(){
        guard alertWindow == nil else { return }
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.windowLevel = UIWindowLevelAlert
        alertWindow?.isHidden = false
        alertWindow?.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive(notif:)), name: Notification.Name.UIWindowDidBecomeKey, object: nil)
    }

    func calculateDuration(config: URBNSwiftAlertConfig) -> CGFloat {
        var wordCount = config.title.components(separatedBy: NSCharacterSet.whitespaces).count
        wordCount += config.message.components(separatedBy: NSCharacterSet.whitespaces).count
        let wordsPerSecond = 5
        let calculatedDuration = wordCount / wordsPerSecond < 2 ? 2 : wordCount / wordsPerSecond
        return CGFloat(calculatedDuration)
    }

    //#pragma mark - Notifications
    ///**
    // *  Called when a new window becomes active.
    // *  Specifically used to detect new alertViews or actionSheets so we can dismiss ourselves
    // **/

    open func resignActive(notif: Notification) {
        if let window = notif.object as? UIWindow, window == alertWindow || window == presentingWindow {
            return
        }

        dismissingAlert()
    }

    open func popQueue() -> URBNSwiftAlertViewController? {
        // TODO confirm
        guard let avc = queue.first, !queue.isEmpty else { return nil }
        queue.remove(at: 0)
        return avc
    }
    
}

