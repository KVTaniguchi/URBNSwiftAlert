//
//  URBNSwiftAlertStyle.swift
//  Pods
//
//  Created by Kevin Taniguchi on 10/8/16.
//
//

import Foundation

open class URBNSwiftAlertStyle: NSObject {

    fileprivate var buttonEdgeInsetsString = ""
    fileprivate var buttonContentInsetsString = ""

    /**
     * Background color of the buttons for active alerts
     */
    open var  buttonBackgroundColor: UIColor = .lightGray

    /**
     * Background color of the denial button for an active alert (at position 0)
     */
    open var destructionButtonBackgroundColor: UIColor = .red

    /**
     * Text color of destructive button colors
     */
    open var destructiveButtonTitleColor: UIColor = .white

    /**
     * Text color of destructive button title when highlighted
     */
    open var destructiveButtonHighlightTitleColor: UIColor {
        get {
            guard let internalDestructiveButtonHighlightTitleColor = internalDestructiveButtonHighlightTitleColor else {
                return destructiveButtonTitleColor
            }
            
            return internalDestructiveButtonHighlightTitleColor
        }
        set (newColor) {
            internalDestructiveButtonHighlightTitleColor = newColor
        }
    }
    
    fileprivate var internalDestructiveButtonHighlightTitleColor: UIColor?

    /**
     * Background color of the cancel button for an active alert
     */
    open var cancelButtonBackgroundColor: UIColor = .lightGray

    /**
     * Text color of cancel button colors
     */
    open var  cancelButtonTitleColor: UIColor = .white

    /**
     * Text color of cancel button title when highlighted
     */

    open var cancelButtonHighlightTitleColor: UIColor {
        get {
            guard let internalCancelButtonHighlightTitleColor = internalCancelButtonHighlightTitleColor else {
                return cancelButtonTitleColor
            }
            return internalCancelButtonHighlightTitleColor
        }
        set (newColor) {
            internalCancelButtonHighlightTitleColor = newColor
        }
    }
    
    fileprivate var internalCancelButtonHighlightTitleColor: UIColor?

    /**
     * Background color of a disabled button for an active alert
     */
    open var disabledButtonBackgroundColor: UIColor?

    /**
     * Background color of a selected button for an active alert
     */
    open var buttonSelectedBackgroundColor: UIColor? = .white
//        get {
//            return buttonSelectedBackgroundColor ?? buttonBackgroundColor
//        }
//        set {}
//    }

    /**
     * Button title color for a selected state
     */
    open var buttonSelectedTitleColor: UIColor? = .white
//        get {
//            return buttonSelectedTitleColor ?? buttonTitleColor
//        }
//        set {}
//    }
    
//    fileprivate var 

    /**
     * Background color of a highlighted button for an active alert
     */

    open var buttonHighlightBackgroundColor: UIColor? = .white
//        get {
//            return buttonHighlightBackgroundColor ?? buttonBackgroundColor
//        }
//        set {}
//    }

    /**
     * Background color of a highlighted button for a cancel action
     */

    open var cancelButtonHighlightBackgroundColor: UIColor? = .white
//        get {
//            return cancelButtonHighlightBackgroundColor ?? buttonBackgroundColor
//        }
//        set {}
//    }

    /**
     * Background color of a highlighted button for a destructive action
     */

    open var destructiveButtonHighlightBackgroundColor: UIColor? = .white
//        get {
//            return destructiveButtonHighlightBackgroundColor ?? buttonBackgroundColor
//        }
//        set {}
//    }

    /**
     * Button title color on highlight
     */
    open var buttonHighlightTitleColor: UIColor {
        get {
            guard let internalButtonHighlightTitleColor = internalButtonHighlightTitleColor else {
                return buttonTitleColor
            }
            return internalButtonHighlightTitleColor
        }
        set (newColor) {
            internalButtonHighlightTitleColor = newColor
        }
    }
    
    fileprivate var internalButtonHighlightTitleColor: UIColor?

    /**
     * Text color of a disabled button
     */
    open var disabledButtonTitleColor: UIColor?

    /**
     * Alpha value of a disabled button
     */
    open var disabledButtonAlpha: Double = 0.5

    /**
     * Text color of the button titles
     */
    open var buttonTitleColor: UIColor = .white

    /**
     * Background color of alert view
     */
    open var backgroundColor: UIColor = .white

    /**
     * Text color of the alert's title
     */
    open var titleColor: UIColor = .black

    /**
     * Text color of the alert's message
     */
    open var messageColor: UIColor = .black

    /**
     * Font of the alert's title
     */
    open var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 14)

    /**
     * Alignment of the titles's message
     */
    open var titleAlignment: NSTextAlignment = .center

    /**
     * Font of the alert's message
     */
    open var messageFont: UIFont = UIFont.systemFont(ofSize: 14)

    /**
     * Alignment of the alert's message
     */
    open var messageAlignment: NSTextAlignment = .left

    /**
     * Font of the button's titles
     */
    open var buttonFont: UIFont = UIFont.boldSystemFont(ofSize: 14)

    /**
     * Corner radius of the alert's buttons
     */
    open var buttonCornerRadius: Double = 8.0

    /**
     * Corner radius of the alert view itself
     */
    open var alertCornerRadius: Double = 8.0

    /**
     *  Minimum width the alert view can be. Note if using, alertMaxWidth must also be set
     */
    open var alertMinWidth: CGFloat?

    /**
     *  Maximum width the alert view can be. Note if using, alertMinWidth must also be set
     */
    open var alertMaxWidth: CGFloat?

    /**
     * Max input length for the text field when enabled
     */
    open var textFieldMaxLength: Double = 25.0

    /**
     *  Vertical margin between textfields
     */
    open var textFieldVerticalMargin: Double = 8

    /**
     *  Text Insets for input text fields on alerts
     */
    open var textFieldEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    /**
     *  Width of vertical separator between buttons that are laid out horiztonally
     */

    open var buttonVerticalSeparatorWidth: Double = 0

    /**
     *  Color of vertical separator between buttons that are laid out horiztonally
     */

    open var buttonVerticalSeparatorColor: UIColor {
        get {
            return buttonVerticalSeparatorColor ?? buttonBackgroundColor
        }
        set {}
    }

    /**
     *  Height of horizontal separator between buttons (as in native UIAlertController). Default is nil for compatibility
     */
    open var separatorHeight: Double = 0.0

    /**
     * Color of the horizontal separator between buttons. Default is buttonTitleColor
     */
    open var separatorColor: UIColor? {
        get {
            guard let internalSeparatorColor = internalSeparatorColor else {
                return buttonTitleColor
            }
            return internalSeparatorColor
        }
        set (newColor) {
            internalSeparatorColor = newColor
        }
    }
    
    fileprivate var internalSeparatorColor: UIColor?
    

    /**
     *  Boolean flag if to use vertical layout for 2 buttons (for 3+ always vertical being used). Default is nil for compatibility
     */
    open var useVerticalLayoutForTwoButtons: NSNumber = 0

    /**
     * Height of the alert's buttons
     */
    open var buttonHeight: NSNumber = 44

    /**
     * Margin between sections in the alert. ie margin between the title and the message message and the buttons, etc.
     */
    open var sectionVerticalMargin: NSNumber = 24

    /**
     * Left & Right margins of the title & message labels
     */
    open var labelHorizontalMargin: NSNumber = 16

    /**
     * UIEdgeInsets used at the external margins for the buttons of the alert's buttons
     */
    open var buttonMarginEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    /**
     * UIEdgeInsets used for internal content for the buttons of the alert's buttons
     */
    open var buttonContentInsets: UIEdgeInsets = UIEdgeInsets.zero

    /**
     * Width of the alert's button's border layer
     */
    open var buttonBorderWidth: NSNumber = 0

    /**
     * UIColor of the alert's button's border
     */

    open var buttonBorderColor: UIColor = .clear

    /**
     * Opacity of the alert's button's shadows
     */
    open var buttonShadowOpacity: NSNumber = 0

    /**
     * Radius of the alert's button's shadows
     */
    open var buttonShadowRadius: NSNumber = 0

    /**
     * Color of the alert's button's shadows
     */
    open var buttonShadowColor: UIColor = .clear

    /**
     * Offset of the alert's button's shadows
     */
    open var buttonShadowOffset: CGSize = CGSize.zero

    /**
     * Margin around the custom view if supplied
     */
    open var customViewMargin: NSNumber = 8

    /**
     * Color of the border around a custom view via layer
     */
    open var customViewBorderColor: UIColor = .clear

    /**
     * Width of the border around a custom view via layer
     */
    open var customViewBorderWidth: NSNumber = 0

    /**
     * Duration of the presenting and dismissing of the alert view
     */
    open var animationDuration: NSNumber = 0.6

    /**
     *  Spring damping for the presenting and dismissing of the alert view
     */
    open var animationDamping: NSNumber = 0.6

    /**
     *  Spring initial velocity for the presenting and dismissing of the alert view
     */
    open var animationInitialVelocity: NSNumber = -10

    /**
     * Opacity of the alert view's shadow
     */
    open var alertViewShadowOpacity: NSNumber = 0.3

    /**
     * Radius of the alert view's shadow
     */
    open var alertViewShadowRadius: NSNumber = 2

    /**
     * Color of the alert view's shadow
     */
    open var alertViewShadowColor: UIColor = .black

    /**
     * Offset of the alert view's shadow
     */
    open var alertShadowOffset: CGSize = CGSize(width: 1, height: 1)

    /**
     * Pass no to disable blurring in the background
     */
    open var blurEnabled: NSNumber = 1

    /**
     * Tint color of the blurred snapshot
     */
    open var blurTintColor: UIColor? = UIColor.white.withAlphaComponent(0.4)
//        get {
//            let tintColor = blurTintColor ?? UIColor.white.withAlphaComponent(0.4)
//            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha : CGFloat = 0
//            tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//            assert(alpha < 1.0, "URBNAlertStyle: blurTintColor alpha component must be less than 1.0f to see the blur effect. Please use colorWithAlphaComponent: when setting a custom blurTintColor, for example: [[UIColor whiteColor] colorWithAlphaComponent:0.4f]")
//            return tintColor
//        }
//        set {}

//    }

    /**
     * Tint color of the view behind the Alert. Blur must be disabled
     */
    open var backgroundViewTintColor: UIColor?

    /**
     * Radius of the blurred snapshot
     */
    open var blurRadius: NSNumber = 5

    /**
     * Saturation blur factor of the blurred snapshot. 1 is normal. < 1 removes color, > 1 adds color
     */
    open var blurSaturationDelta: NSNumber = 1

    /**
     * Text color of the error label text
     */
    open var errorTextColor: UIColor = .red

    /**
     * Font of the error label text
     */
    open var errorTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14)

    /**
     * Color for the top border of the button container
     * No default provided
     * Must be used with a non-nil BorderWidth
     */
    open var buttonContainerTopBorderColor: UIColor?

    /**
     * Width(thickness) for the top border of the button container
     * No default provided
     * Must be used with a non-nil BorderColor
     */
    open var buttonContainerTopBorderWidth: NSNumber = 0

    /**
     * Color for the Bottom border of the button container
     * No default provided
     * Must be used with a non-nil BorderWidth
     */
    open var buttonContainerBottomBorderColor: UIColor?

    /**
     * Width(thickness) for the Bottom border of the button container
     * No default provided
     * Must be used with a non-nil BorderColor
     */
    open var buttonContainerBottomBorderWidth: NSNumber = 0

    /**
     * Color for the Right border of the button container
     * No default provided
     * Must be used with a non-nil BorderWidth
     */
    open var buttonContainerRightBorderColor: UIColor?

    /**
     * Width(thickness) for the Right border of the button container
     * No default provided
     * Must be used with a non-nil BorderColor
     */
    open var buttonContainerRightBorderWidth: NSNumber = 0

    /**
     * Color for the Left border of the button container
     * No default provided
     * Must be used with a non-nil BorderWidth
     */
    open var buttonContainerLeftBorderColor: UIColor?

    /**
     * Width(thickness) for the Left border of the button container
     * No default provided
     * Must be used with a non-nil BorderColor
     */
    open var buttonContainerLeftBorderWidth: NSNumber = 0

    /**
     * The view you want to become the first responder when the alert view is finished presenting
     * The alert position will adjust for the keyboard when using this property
     */
    open var firstResponder: UIView?

    /**
     *  Returns the correct background color for given an actionType
     *
     *  @param actionType Action type associated with the button
     *
     *  @return
     */
    func buttonTitleColorForActionType(actionType: URBNSwiftAlertActionType, isEnabled: Bool) -> UIColor? {
        if !isEnabled, let disabledButtonTitleColor = disabledButtonTitleColor {
            return disabledButtonTitleColor
        }

        switch actionType {
        case .cancel:
            return cancelButtonTitleColor
        case .destructive:
            return destructiveButtonTitleColor
        default:
            return buttonTitleColor
        }
    }

    /**
     *  Returns the correct title color for given an actionType
     *
     *  @param actionType Action type associated with the button
     *
     *  @return
     */
    func buttonBackgroundColorForActionType(actionType: URBNSwiftAlertActionType, isEnabled: Bool) -> UIColor? {
        if !isEnabled, disabledButtonBackgroundColor != nil {
            return disabledButtonBackgroundColor
        }
        
        switch actionType {
        case .cancel:
            return cancelButtonBackgroundColor
        case.destructive:
            return destructionButtonBackgroundColor
        default:
            return buttonBackgroundColor
        }
    }
}
