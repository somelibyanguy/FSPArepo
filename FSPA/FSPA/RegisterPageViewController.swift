//
//  RegisterPageViewController.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 4/15/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase

class RegisterPageViewController: UIViewController {
    
    lazy var welcomeBackground: UIView = {
        var welcomeBackground = UIView()
        welcomeBackground.backgroundColor = UIColor.PrimaryCrimson
        welcomeBackground.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        welcomeBackground.accessibilityIdentifier = "loginVC/welcomeBackground"
        return welcomeBackground
    }()
    
    lazy var firstNameLabel: UILabel = {
        var firstNameLabel = UILabel()
        firstNameLabel.text = "First Name"
        firstNameLabel.numberOfLines = 1
        firstNameLabel.textColor = UIColor.AnalCream
        firstNameLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/35)!)
        firstNameLabel.textAlignment = .left
        return firstNameLabel
    }()
    
    lazy var firstNameField: UITextField = {
        var firstNameField = UITextField()
        firstNameField.textColor = UIColor.PrimaryCrimson
        firstNameField.backgroundColor = UIColor.BgGray
        firstNameField.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        firstNameField.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return firstNameField
    }()
    
    lazy var lastNameLabel: UILabel = {
        var lastNameLabel = UILabel()
        lastNameLabel.text = "Last Name"
        lastNameLabel.numberOfLines = 1
        lastNameLabel.textColor = UIColor.AnalCream
        lastNameLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/35)!)
        lastNameLabel.textAlignment = .left
        return lastNameLabel
    }()
    
    lazy var lastNameField: UITextField = {
        var lastNameField = UITextField()
        lastNameField.textColor = UIColor.PrimaryCrimson
        lastNameField.backgroundColor = UIColor.BgGray
        lastNameField.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        lastNameField.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return lastNameField
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
    
    lazy var registerButton: UIButton = {
        var registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        registerButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        registerButton.backgroundColor = UIColor.AnalCream
        registerButton.setTitleColor(UIColor.PrimaryCrimson, for: .normal)
        registerButton.addTarget(self, action: #selector(register(_:)), for: .touchUpInside)
        return registerButton
    }()
    
    lazy var hidePassword: UIButton = {
        var hidePassword = UIButton()
        hidePassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        hidePassword.setImage(UIImage(systemName: "eye"), for: .selected)
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
        
        welcomeBackground.addSubview(firstNameLabel)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.topAnchor.constraint(equalTo: welcomeBackground.topAnchor, constant: view.bounds.height/30).isActive = true
        firstNameLabel.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        firstNameLabel.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(firstNameField)
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        firstNameField.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        firstNameField.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(lastNameLabel)
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: view.bounds.height/30).isActive = true
        lastNameLabel.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        lastNameLabel.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(lastNameField)
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor).isActive = true
        lastNameField.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
        lastNameField.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
        
        welcomeBackground.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: view.bounds.height/30).isActive = true
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
        
        welcomeBackground.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.bottomAnchor.constraint(equalTo: welcomeBackground.bottomAnchor, constant: -view.bounds.height/40).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor).isActive = true
        
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
    
    @objc func register(_ sender: UIButton!){
        print("register")
        if (firstNameField.isEditing || lastNameField.isEditing || emailField.isEditing || passwordField.isEditing) {
            
            firstNameField.resignFirstResponder()
            
            lastNameField.resignFirstResponder()
            
            emailField.resignFirstResponder()
            
            passwordField.resignFirstResponder()
            
            self.view.layoutIfNeeded()
            
        }
        
        if (firstNameField.text == "" || lastNameField.text == "" || emailField.text == "" || passwordField.text == "") {
            
            let utils = Utils()
            
            let button1 = AlertButton(title: "Ok", action: nil)
            
            let alertPayload = AlertPayload(icon: UIImage.init(systemName: "xmark.circle.fill"), message: "Some information is missing, please fill it out.", buttons: [button1])
            
            utils.showAlert(payload: alertPayload, parentViewController: self)
            
        } else {
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (authResult, error) in
                
                if (error != nil) {
                    
                    let errorCode = AuthErrorCode(rawValue: error!._code)
                    
                    var errorMessage = ""
                    
                    switch errorCode {
                        
                    case .emailAlreadyInUse:
                        
                        errorMessage = "The email is already in use. Please enter a new one."
                        
                    case .invalidEmail:
                        
                        errorMessage = "Invalid email. Please enter another one."
                        
                    case .weakPassword:
                        
                        errorMessage = "The Password is too weak. Please enter a longer one."
                        
                    default:
                        
                        errorMessage = "Oops! Something went wrong. Please try again."
                    }
                    
                    let utils = Utils()
                    
                    let button1 = AlertButton(title: "Ok", action: nil)
                    
                    let alertPayload = AlertPayload(icon: UIImage.init(systemName: "xmark.circle.fill"), message: errorMessage, buttons: [button1])
                    
                    utils.showAlert(payload: alertPayload, parentViewController: self)
                    
                } else {
                    
                    let newUser = authResult!.user
                    
                    let fullName = self.firstNameField.text! + " " + self.lastNameField.text!
                    
                    let userAttrs = ["fullName": fullName, "firstName": self.firstNameField.text!, "lastName": self.lastNameField.text!]
                    
                    let ref = Database.database().reference().child("users").child(newUser.uid)
                    
                    ref.setValue(userAttrs) { (error, ref) in
                        
                        if let error = error {
                            
                            assertionFailure(error.localizedDescription)
                        }
                        
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let user = User(snapshot: snapshot)
                            
                            User.setCurrent(user!, writeToUserDefaults: true)
                            
                            print("Created new user: \(user!.fullName)")
                            
                            guard let window = self.view.window else {
                                
                                return
                                
                            }
                            let vc = UINavigationController(rootViewController: HomeViewController())
                            vc.setNavigationBarHidden(true, animated: false)
                            
                            window.rootViewController = vc
                                                                                    
                            self.present(vc, animated: false, completion: nil)
                        })
                        
                    }
                    
                }
                
            })
            
        }
        
        
    }
    

}
