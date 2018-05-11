//
//  LoginVC.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/9/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //Outlets for scroll binding
    @IBOutlet weak var layoutView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var voidConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var containerViews: [UIView]!
    
    //Variables for binding
    private var keyboardNotificationManager = KeyboardNotificationManager()
    
    private var activeTextField: UITextField?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        
        // Set random colors for containers for better visualisation
        containerViews.forEach { $0.backgroundColor = UIColor.random() }
        
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboard)))
        
        // Do any additional setup after loading the view.
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardNotificationManager.add(subscriber: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardNotificationManager.remove(subscriber: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //signInButton.bindToKeyBoard()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signInButtonPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, loginError) in
                if success {
                    print("success")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, loginError) in
                            if success {
                               self.dismiss(animated: true, completion: nil)
                            } else {
                                print(String(describing: loginError?.localizedDescription))
                            }
                        })
                    
                    } else {
                        print(String(describing: registrationError?.localizedDescription))
                    }
                })
                
            }
        }
    }
    
    
    // MARK: - Private functions
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Keyboard Changed Observer
extension LoginVC: KeyboardChangedObserver {
    
    func keyboardFrameChanged(keyboardNotification: KeyboardNotificationProtocol) {
        let keyboardYPosition = keyboardNotification.keyboardYPosition(inView: layoutView)
        
        // Set scroll view bottom constraint
        scrollViewBottomConstraint.constant = keyboardYPosition
        
        //Decrease 
        voidConstraint.constant -= keyboardYPosition
        
        UIView.animate(
            withDuration: keyboardNotification.animationDuration,
            delay: 0,
            options: keyboardNotification.keyboardAnimationCurve,
            animations: { [weak self] in
                // Animate the constraint
                self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                
                // Scroll to textfield if not visible
                
                let layoutViewRect = self.layoutView.frame
                let visibleRectHeight = layoutViewRect.size.height - keyboardYPosition
                
                if let activeTextFieldSuperview = self.activeTextField?.superview,
                    visibleRectHeight < activeTextFieldSuperview.frame.maxY {
                    self.scrollView.setContentOffset(
                        CGPoint(
                            x: self.scrollView.contentOffset.x,
                            y: activeTextFieldSuperview.frame.maxY
                                - visibleRectHeight),
                        animated: true)
                }
                
        })
    }
}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

// MARK: - Helpers for random color generation
private extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

private extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
    
    

    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */




