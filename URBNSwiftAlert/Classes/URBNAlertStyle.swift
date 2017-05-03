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

    override init() {}

    /**
     * Background color of the buttons for active alerts
     */
    open var buttonBackgroundColor = UIColor.white

    /**
     * Background color of the denial button for an active alert (at position 0)
     */
    open var destructionButtonBackgroundColor = UIColor.red

    /**
     * Text color of destructive button colors
     */
    open var destructiveButtonTitleColor = UIColor.white

    /**
     * Text color of destructive button title when highlighted
     */
    open var destructiveButtonHighlightTitleColor: UIColor {
        get {
            return destructiveButtonHighlightTitleColor ?? destructiveButtonTitleColor
        }
        
    }

    /**
     * Background color of the cancel button for an active alert
     */
    open var cancelButtonBackgroundColor = UIColor.lightGray

    /**
     * Text color of cancel button colors
     */
    open var  cancelButtonTitleColor: UIColor {
        get {
            return cancelButtonTitleColor ?? .white
        }
        
    }

    /**
     * Text color of cancel button title when highlighted
     */

    open var cancelButtonHighlightTitleColor: UIColor {
        get {
            return cancelButtonHighlightTitleColor ?? cancelButtonTitleColor
        }
        
    }

    /**
     * Background color of a disabled button for an active alert
     */
    open var disabledButtonBackgroundColor: UIColor?

    /**
     * Background color of a selected button for an active alert
     */
    open var buttonSelectedBackgroundColor = UIColor.black

    /**
     * Button title color for a selected state
     */
    open var buttonSelectedTitleColor: UIColor {
        get {
            return buttonSelectedTitleColor ?? buttonTitleColor
        }
        
    }

    /**
     * Background color of a highlighted button for an active alert
     */

    open var buttonHighlightBackgroundColor: UIColor {
        get {
            return buttonHighlightBackgroundColor ?? buttonBackgroundColor
        }
        
    }

    /**
     * Background color of a highlighted button for a cancel action
     */

    open var cancelButtonHighlightBackgroundColor: UIColor {
        get {
            return cancelButtonHighlightBackgroundColor ?? buttonBackgroundColor
        }
        
    }

    /**
     * Background color of a highlighted button for a destructive action
     */

    open var destructiveButtonHighlightBackgroundColor: UIColor {
        get {
            return destructiveButtonHighlightBackgroundColor ?? buttonBackgroundColor
        }
        
    }

    /**
     * Button title color on highlight
     */
    open var buttonHighlightTitleColor: UIColor {
        get {
            return buttonHighlightTitleColor ?? buttonTitleColor
        }
        
    }

    /**
     * Text color of a disabled button
     */
    open var disabledButtonTitleColor: UIColor?

    /**
     * Alpha value of a disabled button
     */
    open var disabledButtonAlpha: Double {
        get {
            return disabledButtonAlpha ?? 0.5
        }
        
    }

    /**
     * Text color of the button titles
     */
    open var buttonTitleColor =  UIColor.white

    /**
     * Background color of alert view
     */
    open var backgroundColor = UIColor.white

    /**
     * Text color of the alert's title
     */
    open var titleColor = UIColor.black

    /**
     * Text color of the alert's message
     */
    open var messageColor = UIColor.black

    /**
     * Font of the alert's title
     */
    open var titleFont = UIFont.boldSystemFont(ofSize: 14)

    /**
     * Alignment of the titles's message
     */
    open var titleAlignment: NSTextAlignment = .center

    /**
     * Font of the alert's message
     */
    open var messageFont = UIFont.systemFont(ofSize: 14)


    /**
     * Alignment of the alert's message
     */
    open var messageAlignment: NSTextAlignment = .left

    /**
     * Font of the button's titles
     */
    open var buttonFont = UIFont.boldSystemFont(ofSize: 14)

    /**
     * Corner radius of the alert's buttons
     */
    open var buttonCornerRadius: Double {
        get {
            return buttonCornerRadius ?? 8
        }
        
    }

    /**
     * Corner radius of the alert view itself
     */
    open var alertCornerRadius: Double {
        get {
            return alertCornerRadius ?? 8
        }
        
    }

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
    open var textFieldMaxLength: Double {
        get {
            return textFieldMaxLength ?? 25
        }
        
    }

    /**
     *  Vertical margin between textfields
     */
    open var textFieldVerticalMargin: Double {
        get {
            return textFieldVerticalMargin ?? 8
        }
        
    }

    /**
     *  Text Insets for input text fields on alerts
     */
    open var textFieldEdgeInsets: UIEdgeInsets {
        get {
            return textFieldEdgeInsets ?? UIEdgeInsets.zero
        }
        
    }

    /**
     *  Width of vertical separator between buttons that are laid out horiztonally
     */

    open var buttonVerticalSeparatorWidth: Double {
        get {
            return buttonVerticalSeparatorWidth ?? 0
        }
        
    }

    /**
     *  Color of vertical separator between buttons that are laid out horiztonally
     */

    open var buttonVerticalSeparatorColor: UIColor {
        get {
            return buttonVerticalSeparatorColor ?? buttonBackgroundColor
        }
        
    }

    /**
     *  Height of horizontal separator between buttons (as in native UIAlertController). Default is nil for compatibility
     */
    open var separatorHeight: Double {
        get {
            return separatorHeight ?? 0
        }
        
    }

    /**
     * Color of the horizontal separator between buttons. Default is buttonTitleColor
     */
    open var separatorColor: UIColor {
        get {
            return separatorColor ?? buttonTitleColor
        }
        
    }

    /**
     *  Boolean flag if to use vertical layout for 2 buttons (for 3+ always vertical being used). Default is nil for compatibility
     */
    open var useVerticalLayoutForTwoButtons: NSNumber {
        get {
            return useVerticalLayoutForTwoButtons ?? 0
        }
        
    }

    /**
     * Height of the alert's buttons
     */
    open var buttonHeight: NSNumber {
        get {
            return buttonHeight ?? 44
        }
        
    }

    /**
     * Margin between sections in the alert. ie margin between the title and the message message and the buttons, etc.
     */
    open var sectionVerticalMargin: NSNumber {
        get {
            return sectionVerticalMargin ?? 24
        }
        
    }

    /**
     * Left & Right margins of the title & message labels
     */
    open var labelHorizontalMargin: NSNumber {
        get {
            return labelHorizontalMargin ?? 16
        }
        
    }

    /**
     * UIEdgeInsets used at the external margins for the buttons of the alert's buttons
     */
    open var buttonMarginEdgeInsets: UIEdgeInsets {
        get {
            return buttonMarginEdgeInsets ?? UIEdgeInsets.zero
        }
        
    }

    /**
     * UIEdgeInsets used for internal content for the buttons of the alert's buttons
     */
    open var buttonContentInsets: UIEdgeInsets {
        get {
            return buttonContentInsets ?? UIEdgeInsets.zero
        }
        
    }

    /**
     * Width of the alert's button's border layer
     */
    open var buttonBorderWidth: NSNumber {
        get {
            return buttonBorderWidth ?? 0
        }
        
    }

    /**
     * UIColor of the alert's button's border
     */

    open var buttonBorderColor: UIColor {
        get {
            return buttonBorderColor ?? .clear
        }
        
    }

    /**
     * Opacity of the alert's button's shadows
     */
    open var buttonShadowOpacity: NSNumber {
        get {
            return buttonShadowOpacity ?? 0
        }
        
    }

    /**
     * Radius of the alert's button's shadows
     */
    open var buttonShadowRadius: NSNumber {
        get {
            return buttonShadowRadius ?? 0
        }
        
    }

    /**
     * Color of the alert's button's shadows
     */
    open var buttonShadowColor: UIColor {
        get {
            return buttonShadowColor ?? .clear
        }
        
    }

    /**
     * Offset of the alert's button's shadows
     */
    open var buttonShadowOffset: CGSize {
        get {
            return buttonShadowOffset ?? CGSize.zero
        }
        
    }

    /**
     * Margin around the custom view if supplied
     */
    open var customViewMargin: NSNumber {
        get {
            return customViewMargin ?? 8
        }
        
    }

    /**
     * Color of the border around a custom view via layer
     */
    open var customViewBorderColor: UIColor {
        get {
            return customViewBorderColor ?? .clear
        }
        
    }

    /**
     * Width of the border around a custom view via layer
     */
    open var customViewBorderWidth: NSNumber {
        get {
            return customViewBorderWidth ?? 0
        }
        
    }

    /**
     * Duration of the presenting and dismissing of the alert view
     */
    open var animationDuration: NSNumber {
        get {
            return animationDuration ?? 0.6
        }
        
    }

    /**
     *  Spring damping for the presenting and dismissing of the alert view
     */
    open var animationDamping: NSNumber {
        get {
            return animationDamping ?? 0.6
        }
        
    }

    /**
     *  Spring initial velocity for the presenting and dismissing of the alert view
     */
    open var animationInitialVelocity: NSNumber {
        get {
            return animationInitialVelocity ?? -10
        }
        
    }

    /**
     * Opacity of the alert view's shadow
     */
    open var alertViewShadowOpacity: NSNumber {
        get {
            return alertViewShadowOpacity ?? 0.3
        }
        
    }

    /**
     * Radius of the alert view's shadow
     */
    open var alertViewShadowRadius: NSNumber {
        get {
            return alertViewShadowRadius ?? 2
        }
        
    }

    /**
     * Color of the alert view's shadow
     */
    open var alertViewShadowColor: UIColor {
        get {
            return alertViewShadowColor ?? .black
        }
        
    }

    /**
     * Offset of the alert view's shadow
     */
    open var alertShadowOffset: CGSize {
        get {
            return alertShadowOffset ?? CGSize(width: 1, height: 1)
        }
        
    }

    /**
     * Pass no to disable blurring in the background
     */
    open var blurEnabled: NSNumber {
        get {
            return blurEnabled ?? 1
        }
        
    }

    /**
     * Tint color of the blurred snapshot
     */
    open var blurTintColor: UIColor {
        get {
            let tintColor = blurTintColor ?? UIColor.white.withAlphaComponent(0.4)
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha : CGFloat = 0
            tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            assert(alpha < 1.0, "URBNAlertStyle: blurTintColor alpha component must be less than 1.0f to see the blur effect. Please use colorWithAlphaComponent: when setting a custom blurTintColor, for example: [[UIColor whiteColor] colorWithAlphaComponent:0.4f]")
            return tintColor
        }
        

    }

    /**
     * Tint color of the view behind the Alert. Blur must be disabled
     */
    open var backgroundViewTintColor: UIColor?

    /**
     * Radius of the blurred snapshot
     */
    open var blurRadius: NSNumber {
        get {
            return blurRadius ?? 5
        }
        
    }

    /**
     * Saturation blur factor of the blurred snapshot. 1 is normal. < 1 removes color, > 1 adds color
     */
    open var blurSaturationDelta: NSNumber {
        get {
            return blurSaturationDelta ?? 1
        }
        
    }

    /**
     * Text color of the error label text
     */
    open var errorTextColor: UIColor {
        get {
            return errorTextColor ?? .red
        }
        
    }

    /**
     * Font of the error label text
     */
    open var errorTextFont: UIFont {
        get {
            return errorTextFont ?? UIFont.boldSystemFont(ofSize: 14)
        }
        
    }

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
