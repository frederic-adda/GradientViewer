//
//  InputViewController.swift
//  GradientViewer
//
//  Created by Frédéric ADDA on 11/04/2018.
//  Copyright © 2018 Frédéric ADDA. All rights reserved.
//

import UIKit
import RxSwift


/// Super class for all input ViewControllers
/// Manages textField basic delegate functions
/// and keyboard handler protocol
class InputViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint?
    
    let selectedTextField = Variable<UITextField?>(nil)
    
    
    // MARK: - View controller life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startObservingKeyboardChanges()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopObservingKeyboardChanges()
    }
    
}


// MARK: - TextField delegate
extension InputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.selectedTextField.value = textField
        
        // Set a toolBar as the textField input accessory view, with a "Done" button (only for iPhone, because iPad keyboard already has a "return" key)
        if traitCollection.userInterfaceIdiom == .phone,
            [UIKeyboardType.decimalPad, .numberPad, .phonePad].contains(textField.keyboardType) {
            createInputAccessoryForTextField(textField)
        }
    }
    
    func createInputAccessoryForTextField(_ textField: UITextField) {
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        keyboardToolBar.barStyle = .blackTranslucent
        keyboardToolBar.tintColor = UIColor.white
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(UIResponder.resignFirstResponder))
        keyboardToolBar.setItems([flexSpace, doneButton], animated: false)
        
        textField.inputAccessoryView = keyboardToolBar
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.selectedTextField.value = nil
    }
}


// MARK: - Keyboard handler
extension InputViewController: KeyboardHandler {
    
    // Manage keyboard appearance / disappearance
    func keyboardWillShow(_ notification: Notification) {
        
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = value.cgRectValue.height
        containerBottomConstraint?.constant = -keyboardHeight
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func keyboardWillHide(_ notification: Notification) {
        containerBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
