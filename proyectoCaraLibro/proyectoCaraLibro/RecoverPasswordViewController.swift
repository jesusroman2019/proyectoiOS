//
//  RecoverPasswordViewController.swift
//  proyectoCaraLibro
//
//  Created by user191022 on 5/15/22.
//

import UIKit

class RecoverPasswordViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet private weak var AnchorViewContent: NSLayoutConstraint!
    @IBOutlet private weak var viewContent: UIView!
    
    @IBAction private func tapToCloseKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyBoardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyBoardEvents()
    }
    
    private func registerKeyBoardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyBoardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func keyboardWillShow(_ notification: Notification){
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        if keyboardFrame.origin.y < self.viewContent.frame.maxY {
            self.AnchorViewContent.constant = keyboardFrame.origin.y - self.viewContent.frame.maxY
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification){
        self.AnchorViewContent.constant = 0
    }
}
