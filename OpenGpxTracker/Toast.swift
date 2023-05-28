//
//  Toast.swift
//  OpenGpxTracker
//
//  Created by Merlos on 5/28/23.
//

import Foundation
import UIKit

/// Supporting UILabel for Toast.
class ToastLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

///
/// Display a toast message in a label for a few seconds and dissapears
///
///  Usage:
///
///      Toast.regular("My message") // It accepts delay in seconds and position (.top, .center .bottom)
///
///      // There are .info, .warning, .error and .success toasts.
///      Toast.info("My message", position: .top, delay: 10)
///
///  Originally extracted from https://stackoverflow.com/questions/31540375/how-to-create-a-toast-message-in-swift
///
class Toast {
    
    /// Short delay
    static let kDelayShort = 2.0
    
    /// Long delay
    static let kDelayLong = 5.0
    
    /// Background opacity
    static let kBackgroundOpacity: Double = 0.9
    
    /// height of the toast
    static let kToastHeight = 20
    
    /// withd of the toast
    static let kToastWidth = 24
    
    ///  Offset from the closest screen edge (top or bottom).
    static let kToastOffset = 120
    
    /// Font size of the toast
    static let kFontSize = 16
    
    /// Toast.regular text color
    static let kRegularTextColor: UIColor = UIColor(ciColor: .white)
    /// Toast.regular background color
    static let kRegularBackgroundColor: UIColor = UIColor(ciColor: .black)
    
    /// Toast.info text color
    static let kInfoTextColor: UIColor = UIColor(ciColor: .white)
    /// Toast.info background color
    static let kInfoBackgroundColor: UIColor = UIColor(red: 0/255, green: 100/255, blue: 225/255, alpha: kBackgroundOpacity)
    
    /// Toast.success text color
    static let kSuccessTextColor: UIColor = UIColor(ciColor: .white)
    /// Toast.success background color
    static let kSuccessBackgroundColor: UIColor = UIColor(red: 0/255, green: 150/255, blue: 0/255, alpha: kBackgroundOpacity)
  
    /// Toast.warning text color
    static let kWarningTextColor: UIColor = UIColor(ciColor: .black)
    
    static let kWarningBackgroundColor: UIColor = UIColor(red: 255/255, green: 175/255, blue: 0/255, alpha: kBackgroundOpacity)
    
    /// Toast.error text color
    static let kErrorTextColor: UIColor = UIColor(ciColor: .white)
    /// Toast.error background color
    static let kErrorBackgroundColor: UIColor = UIColor(red: 175/255, green: 0/255, blue: 0/255, alpha: kBackgroundOpacity)
  
    /// Position of the toast in the vertical access
    enum Position {
        case bottom
        case center
        case top
    }
    
        
    ///
    /// Generic implementation to show toast
    /// - Parameters:
    ///     - message: Text message to display
    ///     - textColor: Color of the text
    ///     - backgroundColor: Color of the text
    ///     - position: Position within the screen (.bottom, .center, .top)
    ///     - delay: time in seconds that the toast will be displayed
    static func showToast(_ message: String, textColor: UIColor, backgroundColor: UIColor, position: Position, delay: Double) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let label = ToastLabel()
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: CGFloat(kFontSize))
        label.alpha = 0
        label.text = message
        label.numberOfLines = 0
        var vertical: CGFloat = 0
        var size = label.intrinsicContentSize
        var width = min(size.width, window.frame.width - 60)
        if width != size.width {
            vertical = 1000
            label.textAlignment = .justified
        }
        label.textInsets = UIEdgeInsets(top: vertical, left: 15, bottom: vertical, right: 15)
        size = label.intrinsicContentSize
        width = min(size.width, window.frame.width - 60)
        
        if position == Position.bottom {
            label.frame = CGRect(x: CGFloat(kToastWidth),
                                 y: window.frame.height - CGFloat(kToastOffset),
                                 width: width,
                                 height: size.height + CGFloat(kToastHeight))
        } else if position == Position.center {
            label.frame = CGRect(x: CGFloat(kToastWidth), y: window.frame.height / 2, width: width, height: size.height + CGFloat(kToastHeight))
        } else if position == Position.top {
            label.frame = CGRect(x: CGFloat(kToastWidth), y: CGFloat(kToastOffset), width: width, height: size.height + CGFloat(kToastHeight))
        }
        label.center.x = window.center.x
        label.layer.cornerRadius = min(label.frame.height / 2, 32)
        label.layer.masksToBounds = true
        window.addSubview(label)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
                label.alpha = 0
            }, completion: {_ in
                label.removeFromSuperview()
            })
        })
    }
    
    ///
    /// Displays a regular toast (black)
    /// - SeeAlso showToast
    ///
    class func regular(_ message: String, position: Position = Position.bottom, delay: Double = kDelayLong) {
        showToast(message, textColor: kRegularTextColor, backgroundColor: kRegularBackgroundColor, position: position, delay: delay)
    }
    
    ///
    ///  Information toast (blue)
    ///
    /// - SeeAlso showToast
    class func info(_ message: String, position: Position = Position.bottom, delay: Double = kDelayLong) {
        showToast(String("\u{24D8}")+"  "+message, textColor: kInfoTextColor, backgroundColor: kInfoBackgroundColor,
                  position: position, delay: delay)
    }
    
    ///
    /// Display a warning toast (orange)
    ///
    /// - SeeAlso showToast
    class func warning(_ message: String, position: Position = Position.bottom, delay: Double = kDelayLong) {
        showToast(String("\u{26A0}")+"  "+message, textColor: kWarningTextColor, backgroundColor: kWarningBackgroundColor,
                  position: position, delay: delay)
    }
    
    ///
    /// Display a Success toast
    ///
    /// - SeeAlso showToast
    class func success(_ message: String, position: Position = Position.bottom, delay: Double = kDelayLong) {
        showToast(String("\u{2705}")+"  "+message, textColor: kSuccessTextColor, backgroundColor: kSuccessBackgroundColor, position: position, delay:delay)
    }
    
    ///
    /// Display a error toast
    ///
    /// - SeeAlso showToast
    class func error(_ message: String, position: Position = Position.bottom, delay: Double = kDelayLong) {//2757
        showToast(String("\u{274C}")+"  "+message, textColor: kErrorTextColor, backgroundColor: kErrorBackgroundColor, position: position, delay: delay)
    }
    
}

