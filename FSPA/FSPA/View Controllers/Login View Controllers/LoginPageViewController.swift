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
    
    lazy var emailLabel: UILabel = {
        var emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.numberOfLines = 1
        emailLabel.textColor = UIColor.AnalCream
        emailLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/35)!)
        emailLabel.textAlignment = .left
        return emailLabel
    }()
    
    lazy var emailField: UITextField = {
        var emailField = UITextField()
        emailField.textColor = UIColor.PrimaryCrimson
        emailField.backgroundColor = UIColor.BgGray
        emailField.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        emailField.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return emailField
    }()
    
    lazy var passwordLabel: UILabel = {
        var passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.numberOfLines = 1
        passwordLabel.textColor = UIColor.AnalCream
        passwordLabel.textAlignment = .left
        passwordLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/35)!)
        return passwordLabel
    }()
    
    lazy var passwordField: UITextField = {
        var passwordField = UITextField()
        passwordField.textColor = UIColor.PrimaryCrimson
        passwordField.backgroundColor = UIColor.BgGray
        passwordField.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        passwordField.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    lazy var loginButton: UIButton = {
        var loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
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
        welcomeBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/4).isActive = true
        welcomeBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/4).isActive = true
        welcomeBackground.heightAnchor.constraint(equalToConstant: view.bounds.height/2).isActive = true
        welcomeBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/10).isActive = true
        welcomeBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: welcomeBackground.topAnchor, constant: view.bounds.height/20).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        emailField.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        emailField.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: view.bounds.height/30).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor).isActive = true
        passwordField.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.bottomAnchor.constraint(equalTo: welcomeBackground.bottomAnchor, constant: -view.bounds.height/40).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor).isActive = true
        
        welcomeBackground.addSubview(hidePassword)
        hidePassword.translatesAutoresizingMaskIntoConstraints = false
        hidePassword.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor).isActive = true
        hidePassword.bottomAnchor.constraint(equalTo: passwordField.bottomAnchor).isActive = true
        
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
