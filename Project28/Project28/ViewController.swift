//
//  ViewController.swift
//  Project28
//
//  Created by MTMAC51 on 14/11/22.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        setNotifications()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .clear
    }
    
    func setNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify Yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, autheticationError in
                DispatchQueue.main.async {
                    if success{
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication Failed!", message: "You could not be verified", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        ac.addAction(UIAlertAction(title: "Use login and password", style: .default, handler: {
                            [weak self] _ in
                            self?.loginWithPassword()
                        }))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometrics Not Available", message: "Your device not configured to biometrics", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage(){
        secret.isHidden = false
        title = "Secret stuff!"
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = nil
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage(){
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .clear
        title = "Nothing to see here!"
    }
    
    private func loginWithPassword(){
        let alert = UIAlertController(title: "Enter your login and password", message: nil, preferredStyle: .alert)
        alert.addTextField{
            login in
            login.placeholder = "Enter your login"
        }
        alert.addTextField(){
            password in
            password.placeholder = "Enter your password"
            password.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: {
            [weak self] _ in
            if let login = alert.textFields?[0].text{
                if let storedLogin = KeychainWrapper.standard.string(forKey: "Login"){
                    if login == storedLogin {
                        if let password = alert.textFields?[1].text{
                            if let storedPassword = KeychainWrapper.standard.string(forKey: "Password"){
                                if password == storedPassword {
                                    self?.unlockSecretMessage()
                                }
                            }
                        }
                    }
                } else {
                    self?.nonStoredPassData()
                }
            }
        }))
        present(alert, animated: true)
    }
    
    private func nonStoredPassData(){
        let alert = UIAlertController(title: "You haven't set your username and password yet", message: "Please register your account first", preferredStyle: .alert)
        alert.addTextField{
            login in
            login.placeholder = "Your Login..."
        }
        alert.addTextField{
            password in
            password.placeholder = "Your Password..."
            password.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak self] _ in
            guard let login = alert.textFields?[0].text else { return }
            guard let password = alert.textFields?[1].text else { return }
            if !login.isEmpty && !password.isEmpty {
                KeychainWrapper.standard.set(login, forKey: "Login")
                KeychainWrapper.standard.set(password, forKey: "Password")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

