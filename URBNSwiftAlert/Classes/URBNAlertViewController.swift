//
//  URBNSwiftAlertViewController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 10/9/16.
//
//

import UIKit
import URBNConvenience

typealias URBNSwiftAlertViewControllerFinishedDismissing = (_ wasTouchedOutside: Bool) -> Void

open class URBNSwiftAlertViewController: UIViewController {
    //typedef void(^URBNAlertViewControllerFinishedDismissing)(BOOL wasTouchedOutside);
    //

    /**
     *  Initialize with a title and/or message, as well as a customView if desired
     *
     *  @param title   Optional. The title text displayed in the alert
     *  @param message Optional. The message text displayed in the alert
     *  @param view    The custom UIView you wish to display in the alert
     *
     *  @return A URBNAlertViewController ready to be configurated further or displayed
     */

    public init(title: String, message: String? = nil, view: UIView? = nil) {
        alertConfig.title = title
        if let message = message {
            alertConfig.message = message
        }
        customView = view

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     *  The actual alertView created & displayed within this view controller
     */
    open var alertView: URBNSwiftAlertView?

    /**
     *  The style object associated with this alert
     */
    var alertStyler: URBNSwiftAlertStyle = URBNSwiftAlertController.sharedInstance.alertStyler

    /**
     *  The configuration object associated with this alert
     */
    let alertConfig = URBNSwiftAlertConfig()

    /**
     *  The customView displayed in the alert, if passed
     */
    var customView: UIView?

    /**
     *  Used to detect when the alert has completed its dismissing animation
     */
    var finishedDismissingClosure: URBNSwiftAlertViewControllerFinishedDismissing? {
        get {
            return nil
        }
        set {
            ////- (void)setFinishedDismissingBlock:(URBNAlertViewControllerFinishedDismissing)finishedDismissingBlock;
        }
    }
    fileprivate var alertController = URBNSwiftAlertController.sharedInstance
    fileprivate var yPosConstraint: NSLayoutConstraint?
    fileprivate var blurImageView: UIImageView?
    fileprivate var isAlertVisible = true
    fileprivate var isViewControllerVisible = true
    fileprivate var indexOfLoadingTextField = 0
    fileprivate var viewForScreenShot: UIView {
        if let presentationView = alertConfig.presentationView {
            return presentationView
        }
        else if let window = alertController.presentingWindow {
            return window
        }
        else if let snapShot = self.view.snapshotView(afterScreenUpdates: true) {
            return snapShot
        }
        else {
            return UIView()
        }
    }
}

// Lifecycle
extension URBNSwiftAlertViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        if alertStyler.blurEnabled.boolValue == true {
            addBlurScreenShot()
            blurImageView?.alpha = 0.0
        }
        else if let backgroundViewTintColor = alertStyler.backgroundViewTintColor {
            view.backgroundColor = backgroundViewTintColor
        }

        if let alertView = alertView {
            view.addSubview(alertView)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if alertConfig.shouldTouchOutsideToDismiss && !isViewControllerVisible {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert(sender:)) )
            view.addGestureRecognizer(tapGesture)
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Added this check so if you presented a modal via a passive alert then
        //   dismissed that modal, another alert is not added to the view if the alert
        //   did not finish dismissing yet
        if !isViewControllerVisible {
            setVisible(visible: true, animated: true , completion: nil)
        }

        isViewControllerVisible = true

        if let firstResponder = alertStyler.firstResponder {
            firstResponder.becomeFirstResponder()
        }
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        isViewControllerVisible = false
    }

    func keyboardWillHide() {
        yPosConstraint?.constant = 0

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillShow(sender: Notification) {
        if let keyboardFrame = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let alertView = alertView {
            let keyboardHeight = keyboardFrame.height
            let alertViewBottomYPos = alertView.frame.height + alertView.frame.origin.y
            let yOffSet = -(alertViewBottomYPos - keyboardFrame.origin.y)

            if yOffSet > 0 {
                yPosConstraint?.constant = yOffSet - 30

                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    open func setVisible(visible: Bool, animated: Bool, completion: ((_ alertVC: URBNSwiftAlertViewController, _ isFinished: Bool) -> Void)? = nil) {
        isAlertVisible = visible

        let scaler: CGFloat = 0.3

        if visible {
            alertView?.alpha = 0.0
            alertView?.transform = CGAffineTransform.identity.scaledBy(x: scaler, y: scaler)

        }

        let alpha: CGFloat = visible ? 1.0 : 0.0

        let transform = visible ? CGAffineTransform.identity : CGAffineTransform.identity.scaledBy(x: scaler, y: scaler)

        var bounceAnimation: () -> () = {[unowned self] in
            self.alertView?.transform = transform
        }

        var fadeAnimation: () -> () = {[unowned self] in
            self.alertView?.alpha = alpha
            self.view.alpha = alpha

            if self.alertStyler.blurEnabled.boolValue == true {
                self.blurImageView?.alpha = alpha
            }
        }

        if animated {
            let duration = CGFloat(alertStyler.animationDuration)
            let damping = CGFloat(alertStyler.animationDamping)
            let initialVelocity: CGFloat = visible ? 0 : CGFloat(alertStyler.animationInitialVelocity)

            UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: [], animations: bounceAnimation, completion: { (animationFinished) in
                if animationFinished == true {
                    completion?(self, animationFinished)
                }
            })

            UIView.animate(withDuration: TimeInterval(duration/2.0), animations: fadeAnimation)
        }
        else {
            fadeAnimation()
            bounceAnimation()
            completion?(self, true)
        }
    }
}

// Internal UI Effects
extension URBNSwiftAlertViewController {
    func addBlurScreenShot() {
        addBlurScreenShot(size: CGSize.zero)
    }

    func addBlurScreenShot(size: CGSize) {
        var blurRect = viewForScreenShot.bounds

        if !size.equalTo(CGSize.zero) {
            blurRect.size = size
        }

        if let screenShot = UIImage.urbn_screenShot(of: viewForScreenShot, afterScreenUpdates: true) {
            let blurImage = screenShot.applyBlur(withRadius: CGFloat(alertStyler.blurRadius), tintColor: alertStyler.blurTintColor, saturationDeltaFactor: CGFloat(alertStyler.blurSaturationDelta), maskImage: nil)

            if blurImageView == nil {
                blurImageView = UIImageView(frame: blurRect)
                blurImageView?.autoresizingMask = UIViewAutoresizing.flexibleWidth
                blurImageView?.urbn_wrapInContainerView(with: view)
            }

            blurImageView?.image = blurImage
        }
    }
}

// Show and Dismiss Alerts
extension URBNSwiftAlertViewController {
    /**
     *  Use this method to show a created/configurated URBNAlertViewController.
     *  Alert will be presented in a new window on top of your app
     */
    func show() {
        alertView = URBNSwiftAlertView(alertConfig: alertConfig, alertStyler: alertStyler, customView: customView)
        alertView?.alpha = 0.0
        alertView?.translatesAutoresizingMaskIntoConstraints = false

        var screenWidth: CGFloat = 0.0

        if let presentationView = alertConfig.presentationView {
            screenWidth = presentationView.frame.width
        }
        else {
            screenWidth = UIScreen.main.bounds.width
        }

        let sideMargins = screenWidth * 0.05

        let metrics = ["sideMargins": sideMargins]

        if var minWidth = alertStyler.alertMinWidth, let maxWidth = alertStyler.alertMaxWidth {
            let maxWidthPossible = screenWidth - sideMargins * 2.0
            if minWidth > maxWidthPossible {
                minWidth = maxWidthPossible
            }

            NSLayoutConstraint(item: alertView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1.0, constant: minWidth).isActive = true
            NSLayoutConstraint(item: alertView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1.0, constant: maxWidth).isActive = true
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=sideMargins-[alertView]->=sideMargins-|", options: [], metrics: metrics, views: ["alertView": alertView]))
        }
        else {
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-sideMargins-[alertView]-sideMargins-|", options: [], metrics: metrics, views: ["alertView": alertView]))
        }

        yPosConstraint = NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
        yPosConstraint?.isActive = true
        NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        alertController.addAlertToQueueWithAlertViewController(avc: self)
    }

    /**
     *  Use this method if you wish to show the alert in a specific view and not in a new window
     *
     *  @param view The view in which the alert will appear
     */
    func showInView(view: UIView) {
        alertConfig.presentationView = view
        show()
    }

    /**
     *  Call anytime you want to dismiss the currently presented alert
     */
    func dismiss() {
        dismissAlert(sender: nil)
    }

    /**
     *  Dismiss the alert with a sender. Used to detect when the dismiss is called from a gesture
     *
     *  @param sender Who is causing the dismiss
     */
    func dismissAlert(sender: AnyObject?) {
        view.endEditing(true)

        alertController.dismissingAlert()
        setVisible(visible: false, animated: true) {[unowned self] (alertVC, finished) in
            self.dismiss(animated: false, completion: nil)

            let wasTouchedOutside = sender is UITapGestureRecognizer
            self.finishedDismissingClosure?(wasTouchedOutside)
        }
    }
}

// Control buttons and actions
extension URBNSwiftAlertViewController {
    /**
     *  Add a action to the alert. See URBNAlertAction.h for types & initializers
     *
     *  @param action The URBNAlertAction to be added to the alert
     */
    func addAction(action: URBNSwiftAlertAction) {
        var actions = alertConfig.actions ?? [URBNSwiftAlertAction]()
        actions.append(action)
        alertConfig.actions = actions
        alertConfig.isActiveAlert = action.actionType != .passive
    }

    /**
     *  Use this method to display an error message to the user.
     *  The error displays under above the buttons, and below a textField
     *
     *  @param errorText The error you want to display to the user
     */
    func showInputError(errorText: String) {
        alertView?.setErrorLabelText(errorText: errorText)
    }

    /**
     *  When called, any buttons are disabled and the textfield at the given index
     *     animates with a loading indicator
     *
     *  @param index Index of the textfield you wish to animate
     */
    func startLoadingTextFieldAtIndex(index: Int) {
        indexOfLoadingTextField = index
        alertView?.setLoadingState(newState: true, index: index)
    }

    /**
     *  When called, any buttons are disabled and the first textfield
     *      adnimates with a loading indicator. Kept for convenience & backwards compatability
     */
    func startLoading() {
        startLoadingTextFieldAtIndex(index: 0)
    }

    /**
     *  Enables all buttons and removes the textField loading spinner if present
     */
    func stopLoading() {
        alertView?.setLoadingState(newState: false, index: indexOfLoadingTextField)
    }
}

// Textfields
extension URBNSwiftAlertViewController {
    /**
     *  Add a textField to the alert. Configure the textField's properties in the handler.
     *  Note: only 1 text field is supported at the moment
     *
     *  @param configurationHandler If you wish to customize the textFields properties, provide this block
     */
    func addTextFieldWithConfigurationHandler(configHandler: ((UITextField) -> Void)? = nil ) {
        var inputs = alertConfig.inputs ?? [URBNTextField]()

        let textField = URBNTextField()

        configHandler?(textField)

        inputs.append(textField)
        alertConfig.inputs = inputs
    }

    /**
     *  Getter for the 1st textField added to the alert. Kept for convenience & backwards compatability
     */
    var textField: UITextField {
        get {
            return UITextField()
        }
        set {}
    }

    /**
     *  Helpers to get a textfield for a given index
     *
     *  @param index The index of the textfield you wish to get
     *
     *  @return
     */
    func textFieldAtIndex(index: Int) -> UITextField? {
        return nil
    }
}

extension URBNSwiftAlertViewController {
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if alertStyler.blurEnabled.boolValue == true {
            addBlurScreenShot(size: size)
            coordinator.animateAlongsideTransition(in: nil, animation: { (context) in
                self.addBlurScreenShot()
                }, completion: nil)
        }
    }

    override open func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willRotate(to: toInterfaceOrientation, duration: duration)

        if alertStyler.blurEnabled.boolValue == true {
            var size = viewForScreenShot.bounds.size
            size.height = size.width
            size.width = viewForScreenShot.height
            addBlurScreenShot(size: size)
        }
    }

    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        
        if alertStyler.blurEnabled.boolValue == true {
            addBlurScreenShot()
        }
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        guard let style = alertController.presentingWindow?.rootViewController?.preferredStatusBarStyle else { return preferredStatusBarStyle }
        return style
    }
    
}
