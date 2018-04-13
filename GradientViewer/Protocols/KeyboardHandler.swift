//
//  KeyboardHandler.swift
//  GradientViewer
//
//  Created by Frédéric ADDA on 11/04/2018.
//  Copyright © 2018 Frédéric ADDA. All rights reserved.
//

import UIKit

protocol KeyboardHandler: class {
    
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
    func startObservingKeyboardChanges()
    func stopObservingKeyboardChanges()
}


extension KeyboardHandler where Self: UIViewController {
    
    func startObservingKeyboardChanges() {
        
        // NotificationCenter observers
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillShow(notification)
        }
        
        // Deal with rotations
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillShow(notification)
        }
        
        // Deal with keyboard type change (emoji, number, etc.)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextInputCurrentInputModeDidChange, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillShow(notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillHide(notification)
        }
    }
    
    
    func stopObservingKeyboardChanges() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
