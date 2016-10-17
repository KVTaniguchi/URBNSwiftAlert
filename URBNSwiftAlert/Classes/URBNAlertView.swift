//
//  URBNSwiftAlertView.swift
//  Pods
//
//  Created by Kevin Taniguchi on 10/9/16.
//
//

import Foundation

public typealias URBNSwiftAlertViewButtonTouched = (URBNSwiftAlertAction) -> Void
public typealias URBNSwiftAlertViewTouched = (URBNSwiftAlertAction) -> Void

open class URBNSwiftAlertView: UIView, UITextFieldDelegate {
    open var errorLabelText: String {
        get {
            return ""
        }
        set {}
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open var buttonTouchedBlock: URBNSwiftAlertViewButtonTouched? {
        get {
            return buttonTouchedBlock ?? nil
        }
        set {}
    }
    open var alertViewTouchedClosure: URBNSwiftAlertViewTouched? {
        get {
            return alertViewTouchedClosure ?? nil
        }
        set {}
    }

    open var alertConfig: URBNSwiftAlertConfig
    open var alertStyler: URBNSwiftAlertStyle
    let titleLabel = UILabel()
    let messageTextView = UITextView()
    let errorLabel = UILabel()
    var customView: UIView?
    lazy var buttons = [URBNSwiftAlertActionButton]()
    var sectionCount: Int = 0
    lazy var buttonContainer = UIView()
    let kURBNAlertViewHeightPadding: CGFloat = 80.0

    public init(alertConfig: URBNSwiftAlertConfig, alertStyler: URBNSwiftAlertStyle, customView: UIView? = nil) {
        self.alertStyler = alertStyler
        self.alertConfig = alertConfig

        super.init(frame: CGRect.zero)

        // set up and add component views
        setUpTitleLabel()
        setUpMessageTextView()

        // addCustomView()
        handleCustomView(customView: customView)

        backgroundColor = self.alertStyler.backgroundColor ?? .white
        layer.cornerRadius = CGFloat(self.alertStyler.alertCornerRadius)


        // set up buttons
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        setUpButtonContainerBorders()

        var views = ["titleLabel": titleLabel, "messageTextView": messageTextView, "buttonContainer": buttonContainer, "errorLabel": errorLabel]
        addSubview(titleLabel)
        addSubview(messageTextView)
        addSubview(errorLabel)
        if let customView = customView {
            addSubview(customView)
            views["customView"] = customView
        }

        for (index, textField) in alertConfig.inputs.enumerated() {
            textField.edgeInsets = alertStyler.textFieldEdgeInsets
            textField.translatesAutoresizingMaskIntoConstraints = false
            views["textField\(index)"] = textField
            sectionCount += 1
            addSubview(textField)
        }

        // add button separators, as per actions
        var separators = [UIView]()
        for (index, action) in alertConfig.actions.enumerated() {
            if action.isButton {
                if alertStyler.separatorHeight > 0 {
                    let separator = UIView()
                    separator.backgroundColor = alertStyler.separatorColor
                    separator.translatesAutoresizingMaskIntoConstraints = false
                    buttonContainer.addSubview(separator)
                    separators.append(separator)
                }
            }

            let button = createAlertViewButtonWith(action: action, index: index)
            buttonContainer.addSubview(button)
            buttons.append(button)
            action.actionButton = button
        }

        addSubview(buttonContainer)

        // Handle if no title or messages, give 0 margins
        let titleMargin = alertConfig.title.isEmpty ? 0 : alertStyler.sectionVerticalMargin
        let msgMargin = alertConfig.message.isEmpty ? 0 : alertStyler.sectionVerticalMargin

        if titleMargin.intValue > 0 {
            sectionCount += 1
        }

        if msgMargin.intValue > 0 {
            sectionCount += 1
        }

        let metrics = ["sectionMargin" : self.alertStyler.sectionVerticalMargin,
                       "btnH" : self.alertStyler.buttonHeight,
                       "lblHMargin" : self.alertStyler.labelHorizontalMargin,
                       "topVMargin" : titleMargin,
                       "msgVMargin" : msgMargin,
                       "sprHeight"  : self.alertStyler.separatorHeight,
                       "btnTopMargin" : self.alertStyler.buttonMarginEdgeInsets.top,
                       "btnLeftMargin" : self.alertStyler.buttonMarginEdgeInsets.left,
                       "btnBottomMargin" : self.alertStyler.buttonMarginEdgeInsets.bottom,
                       "btnRightMargin" : self.alertStyler.buttonMarginEdgeInsets.right,
                       "btnVInterval" : self.alertStyler.buttonMarginEdgeInsets.top + self.alertStyler.buttonMarginEdgeInsets.bottom,
                       "cvMargin" : self.alertStyler.customViewMargin,
                       "tfVMargin" : self.alertStyler.textFieldVerticalMargin,
                       "btnVSepW" : self.alertStyler.buttonVerticalSeparatorWidth,
                       "btnVSepMargin": self.alertStyler.buttonMarginEdgeInsets.right/2] as [String: Any]

        for lbl in [titleLabel, errorLabel] {
            lbl.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-lblHMargin-[lbl]-lblHMargin-|", options: [], metrics: metrics, views: ["lbl": lbl]))
        }

        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-lblHMargin-[tv]-lblHMargin-|", options: [], metrics: metrics, views: ["tv": messageTextView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-cvMargin-[customView]-cvMargin-|", options: [], metrics: metrics, views: views))

        if self.alertConfig.inputs.isEmpty {
            if self.alertConfig.isActiveAlert {
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topVMargin-[titleLabel]-msgVMargin-[messageTextView]-cvMargin-[customView]-5-[errorLabel]-cvMargin-[buttonContainer]|", options: [], metrics: metrics, views: views))
            }
            else {
                // Passive alert, dont added margins for buttonContainer
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topVMargin-[_titleLabel]-msgVMargin-[_messageTextView]-cvMargin-[_customView]-cvMargin-|", options: [], metrics: metrics, views: views))
            }
        }
        else {
            var vertVFL = "V:|-topVMargin-[titleLabel]-msgVMargin-[messageTextView]-cvMargin-[customView]-cvMargin-"

            for (index, tf) in self.alertConfig.inputs.enumerated() {
                vertVFL += "[textField\(index)]-tfVMargin-"
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-lblHMargin-[textField\(index)]-lblHMargin-|", options: [], metrics: metrics, views: views))
            }

            vertVFL += "[errorLabel][buttonContainer]|"
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: vertVFL, options: [], metrics: metrics, views: views))
        }

        // Button Constraints
        self.sectionCount += 1

        if buttons.count == 1, let btnOne = buttons.first {
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-btnLeftMargin-[btnOne]-btnRightMargin-|", options: [], metrics: metrics, views: ["btnOne": btnOne]))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-btnTopMargin-[btnOne(btnH)]-btnBottomMargin-|", options: [], metrics: metrics, views: ["btnOne": btnOne]))
        }
        else if buttons.count == 2 && self.alertStyler.useVerticalLayoutForTwoButtons.boolValue == false, let btnOne = buttons.first, let btnTwo = buttons.last  {
            var btns = ["btnOne": btnOne ,"btnTwo": btnTwo] as [String: Any]
            if self.alertStyler.buttonVerticalSeparatorWidth == nil {
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-btnLeftMargin-[btnOne]-btnRightMargin-[btnTwo(==btnOne)]-btnRightMargin-|", options: [], metrics: metrics, views: btns ))
            }
            else {
                let verticalSeparator = UIView()
                verticalSeparator.backgroundColor = self.alertStyler.buttonVerticalSeparatorColor
                verticalSeparator.translatesAutoresizingMaskIntoConstraints = false
                buttonContainer.addSubview(verticalSeparator)

                btns["vertSep"] = verticalSeparator

                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-btnLeftMargin-[btnOne]-btnVSepMargin-[vertSep(btnVSepW)]-btnVSepMargin-[btnTwo(==btnOne)]-btnRightMargin-|", options: [], metrics: metrics, views: btns))
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-btnTopMargin-[vertSep(btnH)]-btnBottomMargin-|", options: [], metrics: metrics, views: btns))
            }

            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-btnTopMargin-[btnOne(btnH)]-btnBottomMargin-|", options: [], metrics: metrics, views: btns))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-btnTopMargin-[btnTwo(btnH)]-btnBottomMargin-|", options: [], metrics: metrics, views: btns))
        }
        else {
            var viewsDict = [:] as [String: Any]
            var vertVFL = "V:|"

            for index in 0...buttons.count {
                let buttonName = "btn\(index)"
                viewsDict[buttonName] = buttons[index]

                if separators.count == buttons.count {
                    let separatorName = "spr\(index)"
                    vertVFL += "[\(separatorName)(sprHeight)]-btnTopMargin-"
                    viewsDict[separatorName] = separators[index]
                    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-btnLeftMargin-[separator]-btnRightMargin-|", options: [], metrics: metrics, views: ["separator": separators[index]]))
                }
                else if index == 0 {
                    vertVFL += "-btnTopMargin-"
                }
                else {
                    vertVFL += "-btnVInterval-"
                }

                vertVFL += "[\(buttonName)(btnH)]"
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-btnLeftMargin-[button]-btnRightMargin-|", options: [], metrics: metrics, views: ["button": buttons[index]]))
            }

            if !buttons.isEmpty {
                vertVFL += "-btnBottomMargin-|"
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: vertVFL, options: [], metrics: metrics, views: viewsDict))
            }
        }

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[buttonContainer]|", options: [], metrics: metrics, views: views))

        // If passive alert & a passive action was added, need call back when alertview is touched
        if !self.alertConfig.isActiveAlert && !self.alertConfig.actions.isEmpty {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(passiveAlertViewTouched))
        }
    }

    func passiveAlertViewTouched() {
        guard let alertViewTouchedClosure = alertViewTouchedClosure, let firstAction = alertConfig.actions.first else { return }
        alertViewTouchedClosure(firstAction)
    }
}

extension URBNSwiftAlertView {
    func handleCustomView(customView: UIView?) {
        if let customView = customView {
            self.customView = customView
            sectionCount += 1
            self.customView?.layer.borderWidth = CGFloat(self.alertStyler.customViewBorderWidth)
            self.customView?.layer.borderColor = self.alertStyler.customViewBorderColor.cgColor
        }
        else {
            self.customView = UIView()
        }
        self.customView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setUpButtonContainerBorders() {
        buttonContainer.setURBNBorder(border: buttonContainer.urbn_topBorder, color: self.alertStyler.buttonContainerTopBorderColor, width: CGFloat(self.alertStyler.buttonContainerTopBorderWidth))
        buttonContainer.setURBNBorder(border: buttonContainer.urbn_bottomBorder, color: self.alertStyler.buttonContainerBottomBorderColor, width: CGFloat(self.alertStyler.buttonContainerBottomBorderWidth))
        buttonContainer.setURBNBorder(border: buttonContainer.urbn_rightBorder, color: self.alertStyler.buttonContainerRightBorderColor, width: CGFloat(self.alertStyler.buttonContainerRightBorderWidth))
        buttonContainer.setURBNBorder(border: buttonContainer.urbn_leftBorder, color: self.alertStyler.buttonContainerLeftBorderColor, width: CGFloat(self.alertStyler.buttonContainerLeftBorderWidth))
    }
}

extension URBNSwiftAlertView {
    override open func layoutSubviews() {
        messageTextView.sizeToFit()
        messageTextView.layoutIfNeeded()

        let buttonHeight = buttons.isEmpty ? 0 : alertStyler.buttonHeight.floatValue
        var numberOfVerticalButtons = 0

        if buttons.count == 2 && !alertStyler.useVerticalLayoutForTwoButtons.boolValue == true {
            numberOfVerticalButtons = 2
        }
        else {
            numberOfVerticalButtons = buttons.count
        }

        let screenHeight = UIScreen.main.bounds.height

        let verticalSectionMarginsHeight = CGFloat(alertStyler.sectionVerticalMargin) * CGFloat(sectionCount)
        let buttonsHeight = CGFloat(buttonHeight) * CGFloat(numberOfVerticalButtons)
        let buttonsSeparatorHeight = numberOfVerticalButtons > 1 ? CGFloat(alertStyler.separatorHeight) * CGFloat(numberOfVerticalButtons) : 0
        let maxHeight = screenHeight - titleLabel.intrinsicContentSize.height - verticalSectionMarginsHeight - buttonsHeight - buttonsSeparatorHeight - kURBNAlertViewHeightPadding

        if messageTextView.urbn_heightLayoutConstraint == nil {
            messageTextView.urbn_addHeightLayoutConstraint(withConstant: 0)
        }

        if !messageTextView.text.isEmpty {
            if messageTextView.contentSize.height > maxHeight {
                messageTextView.urbn_heightLayoutConstraint().constant = maxHeight
                messageTextView.isScrollEnabled = true
            }
            else {
                messageTextView.urbn_heightLayoutConstraint().constant = messageTextView.contentSize.height
            }
        }

        // code above needs to be called before super. Crashes on iOS 7 if called after
        super.layoutSubviews()

        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width

        layer.shadowColor = alertStyler.alertViewShadowColor.cgColor
        layer.shadowOffset = alertStyler.alertShadowOffset
        layer.shadowOpacity = Float(alertStyler.alertViewShadowOpacity)
        layer.shadowRadius = CGFloat(alertStyler.alertViewShadowRadius)
        layer.actions =  ["shadowPath": NSNull()]
    }
}

extension URBNSwiftAlertView {
    func setUpTitleLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = alertStyler.titleAlignment
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = alertStyler.titleFont
        titleLabel.textColor = alertStyler.titleColor
        titleLabel.text = alertConfig.title
    }

    func setUpMessageTextView() {
        messageTextView.backgroundColor = .clear
        messageTextView.font = alertStyler.messageFont
        messageTextView.textColor = alertStyler.messageColor
        messageTextView.text = alertConfig.message
        messageTextView.textAlignment = alertStyler.messageAlignment
        messageTextView.isScrollEnabled = false
        messageTextView.isEditable = false
        messageTextView.contentInset = UIEdgeInsets.zero
        messageTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    func setUpErrorLabel() {
        errorLabel.numberOfLines = 0
        errorLabel.font = alertStyler.errorTextFont
        errorLabel.textColor = alertStyler.errorTextColor
        errorLabel.alpha = 0
    }

    func setErrorLabelText(errorText: String) {
        UIView.animate(withDuration: 0.2) {
            self.errorLabel.text = errorText
            self.errorLabel.alpha = 1.0
        }
    }

    func setLoadingState(newState: Bool, index: Int) {
        setButtons(enabled: !newState)

        if index < alertConfig.inputs.count {
            let textField = alertConfig.inputs[index]
            if newState {
                // Disable buttons, show loading
                textField.urbn_showLoading(true, animated: true, spinnerInsets: UIEdgeInsetsMake(0, 0, 0, 8))
            }
            else {
                textField.urbn_showLoading(false, animated: true)
            }
        }
    }

    func setButtons(enabled: Bool) {
        for action in alertConfig.actions {
            action.isEnabled = enabled
        }
    }

    @objc(textField:shouldChangeCharactersInRange:replacementString:) public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // TODO Verify this guard
        guard let text = textField.text, range.length + range.location < text.characters.count else { return false }

        let newLength = Double(text.characters.count + string.characters.count - range.length)
        return newLength > alertStyler.textFieldMaxLength ? false : true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension URBNSwiftAlertView {
    func createAlertViewButtonWith(action: URBNSwiftAlertAction, index: Int) -> URBNSwiftAlertActionButton {
        var bgColor = action.isSelected ? alertStyler.buttonSelectedBackgroundColor : alertStyler.buttonBackgroundColor
        var titleColor = alertStyler.buttonTitleColor
        var highlightColor = alertStyler.buttonHighlightTitleColor
        let selectedColor = alertStyler.buttonSelectedTitleColor

        if action.actionType == .destructive {
            titleColor = alertStyler.destructiveButtonTitleColor
            bgColor = alertStyler.destructionButtonBackgroundColor;
            highlightColor = alertStyler.destructiveButtonHighlightTitleColor;
        }
        else if action.actionType == .cancel {
            titleColor = alertStyler.cancelButtonTitleColor;
            bgColor = alertStyler.cancelButtonBackgroundColor;
            highlightColor = alertStyler.cancelButtonHighlightTitleColor;
        }

        let btn = URBNSwiftAlertActionButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = bgColor
        btn.titleLabel?.font = alertStyler.buttonFont;
        btn.layer.cornerRadius = CGFloat(alertStyler.buttonCornerRadius)
        btn.layer.shadowColor = alertStyler.buttonShadowColor.cgColor
        btn.layer.shadowOpacity = Float(alertStyler.buttonShadowOpacity)
        btn.layer.shadowRadius = CGFloat(alertStyler.buttonShadowRadius)
        btn.layer.shadowOffset = alertStyler.buttonShadowOffset
        btn.layer.borderColor = alertStyler.buttonBorderColor.cgColor;
        btn.layer.borderWidth = CGFloat(alertStyler.buttonBorderWidth)
        btn.contentEdgeInsets = alertStyler.buttonContentInsets;

        btn.tag = index;
        btn.actionType = action.actionType;
        btn.alertStyler = alertStyler;

        btn.setTitle(action.title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitleColor(highlightColor, for: .highlighted)
        btn.setTitleColor(selectedColor, for: .selected)

        btn.addTarget(self, action: #selector(URBNSwiftAlertView.buttonTouch(sender:)), for: .touchUpInside)
        btn.isSelected = action.isSelected
        return btn
    }
    
    func buttonTouch(sender: URBNSwiftAlertActionButton) {
        if let buttonTouchedBlock = buttonTouchedBlock {
            buttonTouchedBlock(alertConfig.actions[sender.tag])
        }
    }
}

extension UIView {
    func setURBNBorder(border: URBNBorder, color: UIColor?, width: CGFloat) {
        border.color = color
        border.width = width
    }
}

