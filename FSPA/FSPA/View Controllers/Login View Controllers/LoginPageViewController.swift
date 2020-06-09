//
//  LoginPageViewController.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 4/15/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

class LoginPageViewController: UIViewController {
    
    lazy var welcomeBackground: UIView = {
        var welcomeBackground = UIView()
        welcomeBackground.backgroundColor = UIColor.PrimaryCrimson
        welcomeBackground.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        welcomeBackground.accessibilityIdentifier = "loginVC/welcomeBackground"
        return welcomeBackground
    }()
    
    lazy var loginLabel: UILabel = {
        var loginLabel = UILabel()
        loginLabel.text = "Log in to your account"
        loginLabel.numberOfLines = 1
        loginLabel.textColor = UIColor.AnalCream
        loginLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        loginLabel.textAlignment = .center
        return loginLabel
    }()
    
    lazy var emailField: UITextField = {
        var emailField = UITextField()
        emailField.textColor = UIColor.PrimaryCrimson
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.backgroundColor = UIColor.BgGray
        emailField.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        emailField.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return emailField
    }()
    
    lazy var passwordField: UITextField = {
        var passwordField = UITextField()
        passwordField.textColor = UIColor.PrimaryCrimson
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.backgroundColor = UIColor.BgGray
        passwordField.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        passwordField.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    lazy var loginButton: UIButton = {
        var loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 2.0, height: 2.0))
        loginButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        loginButton.backgroundColor = UIColor.AnalCream
        loginButton.setTitleColor(UIColor.PrimaryCrimson, for: .normal)
        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        return loginButton
    }()
    
    lazy var hidePassword: UIButton = {
        var hidePassword = UIButton()
        hidePassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        hidePassword.addTarget(self, action: #selector(hidePassword(_:)), for: .touchUpInside)
        return hidePassword
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.BgGray
        
        view.addSubview(welcomeBackground)
        welcomeBackground.translatesAutoresizingMaskIntoConstraints = false
        welcomeBackground.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.4).isActive = true
        welcomeBackground.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        welcomeBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        welcomeBackground.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 0.8, height: view.bounds.height * 0.4)

        welcomeBackground.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.topAnchor.constraint(equalTo: welcomeBackground.topAnchor, constant: welcomeBackground.bounds.height * 0.1111).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: welcomeBackground.bounds.height * 0.1111).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: welcomeBackground.bounds.width/15).isActive = true
        loginLabel.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -welcomeBackground.bounds.width/15).isActive = true
        
        welcomeBackground.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: welcomeBackground.bounds.height * 0.1111).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: welcomeBackground.bounds.height * 0.1111).isActive = true
        emailField.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant:  welcomeBackground.bounds.width/10).isActive = true
        emailField.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -welcomeBackground.bounds.width/10).isActive = true

        welcomeBackground.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: welcomeBackground.bounds.height * 0.1111).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: welcomeBackground.bounds.height * 0.1111).isActive = true
        passwordField.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant:  welcomeBackground.bounds.width/10).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -welcomeBackground.bounds.width/10).isActive = true

        welcomeBackground.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant:  welcomeBackground.bounds.height * 0.1111).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: welcomeBackground.bounds.height * 0.1111).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant:  welcomeBackground.bounds.width/10).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -welcomeBackground.bounds.width/10).isActive = true
        
//        welcomeBackground.addSubview(hidePassword)
//        hidePassword.translatesAutoresizingMaskIntoConstraints = false
//        hidePassword.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor).isActive = true
//        hidePassword.bottomAnchor.constraint(equalTo: passwordField.bottomAnchor).isActive = true
        
    }
    
    @objc func hidePassword(_ sender: UIButton!){
        if(passwordField.isSecureTextEntry){
            passwordField.isSecureTextEntry = false
            hidePassword.setImage(UIImage(systemName: "eye"), for: .normal)
        }else{
            passwordField.isSecureTextEntry = true
            hidePassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @objc func login(_ sender: UIButton!){
        if (emailField.isEditing || passwordField.isEditing) {
            
            emailField.resignFirstResponder()
            
            passwordField.resignFirstResponder()
            
            self.view.layoutIfNeeded()
            
        }
        
        if (emailField.text == "" || passwordField.text == "") {
            
            let utils = Utils()
            
            let button1 = AlertButton(title: "Ok", action: nil)
            
            let alertPayload = AlertPayload(icon: UIImage.init(systemName: "xmark.circle.fill"), message: "Some information is missing, please fill it out.", buttons: [button1])
            
            utils.showAlert(payload: alertPayload, parentViewController: self)
            
        } else {
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { [weak self] authResult, error in
                
                guard let strongSelf = self else {return}
                
                if (error != nil) {
                    
                    let errorCode = AuthErrorCode(rawValue: error!._code)
                    
                    var errorMessage = ""
                    
                    switch errorCode {
                        
                    case .userNotFound:
                        
                        errorMessage = "No user found with that email. Please try another one."
                        
                    case .invalidEmail:
                        
                        errorMessage = "Invalid email. Please enter another one."
                        
                    case .wrongPassword:
                        
                        errorMessage = "The Password is incorrect. Please enter another one."
                        
                    default:
                        
                        errorMessage = "Oops! Something went wrong. Please try again."
                    }
                    
                    let utils = Utils()
                    
                    let button1 = AlertButton(title: "Ok", action: nil)
                    
                    let alertPayload = AlertPayload(icon: UIImage.init(systemName: "xmark.circle.fill"), message: errorMessage, buttons: [button1])
                    
                    utils.showAlert(payload: alertPayload, parentViewController: strongSelf)
                    
                } else {
                    
                    let newUser = authResult!.user
                    
                    let ref = Database.database().reference().child("users").child(newUser.uid)
                    
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let user = User(snapshot: snapshot)
                        
                        User.setCurrent(user!, writeToUserDefaults: true)
                        
                        guard let window = strongSelf.view.window else {
                            
                            return
                            
                        }
                        
                        let vc = UINavigationController(rootViewController: HomeViewController())
                        vc.setNavigationBarHidden(true, animated: false)
                        
                        
                        window.rootViewController = vc

                        self?.present(vc, animated: false, completion: nil)
                    })
                    
                }
                
            })
            
        }
        
    }
    
    
}
