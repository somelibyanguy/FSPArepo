    //
    //  LoginViewController.swift
    //  FSPA
    //
    //  Created by Abdulrahman Ayad on 4/14/20.
    //  Copyright © 2020 Poppin Software. All rights reserved.
    //
    
    import UIKit
    import SideMenu
    
    class LoginViewController: UIViewController {
        
        lazy var welcomeBackground: UIView = {
            var welcomeBackground = UIView()
            welcomeBackground.backgroundColor = UIColor.PrimaryCrimson
            welcomeBackground.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
            welcomeBackground.accessibilityIdentifier = "loginVC/welcomeBackground"
            return welcomeBackground
        }()
        
        lazy var welcomeLabel: UILabel = {
            var welcomeLabel = UILabel()
            welcomeLabel.text = "Welcome to the passport app. Log in or register below!"
            welcomeLabel.lineBreakMode = .byWordWrapping
            welcomeLabel.numberOfLines = 10
            welcomeLabel.textColor = UIColor.AnalCream
            welcomeLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/30)!)
            welcomeLabel.textAlignment = .center
            return welcomeLabel
        }()
        
        lazy var loginButton: UIButton = {
            var loginButton = UIButton()
            loginButton.setTitle("Login", for: .normal)
            loginButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
            loginButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/25)!)
            loginButton.backgroundColor = UIColor.AnalCream
            loginButton.setTitleColor(UIColor.PrimaryCrimson, for: .normal)
            loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
            return loginButton
        }()
        
        lazy var registerButton: UIButton = {
            var registerButton = UIButton()
            registerButton.setTitle("Register", for: .normal)
            registerButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
            registerButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/25)!)
            registerButton.backgroundColor = UIColor.AnalCream
            registerButton.setTitleColor(UIColor.PrimaryCrimson, for: .normal)
            registerButton.addTarget(self, action: #selector(register(_:)), for: .touchUpInside)
            return registerButton
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
            
            welcomeBackground.addSubview(welcomeLabel)
            welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
            welcomeLabel.topAnchor.constraint(equalTo: welcomeBackground.topAnchor, constant: view.bounds.height/20).isActive = true
            welcomeLabel.leadingAnchor.constraint(equalTo: welcomeBackground.leadingAnchor, constant: view.bounds.width/10).isActive = true
            welcomeLabel.trailingAnchor.constraint(equalTo: welcomeBackground.trailingAnchor, constant: -view.bounds.width/10).isActive = true
            
            welcomeBackground.addSubview(loginButton)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            loginButton.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor).isActive = true
            loginButton.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor).isActive = true
            
            welcomeBackground.addSubview(registerButton)
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: view.bounds.height/20).isActive = true
            registerButton.bottomAnchor.constraint(equalTo: welcomeBackground.bottomAnchor, constant: -view.bounds.height/20).isActive = true
            registerButton.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor).isActive = true
            registerButton.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor).isActive = true
        }
        
        @objc func login(_ sender: UIButton!){
            print("login")
            guard let window = self.view.window else {
                
                return
                
            }
            
            window.rootViewController = LoginPageViewController()
            
            let vc = LoginPageViewController()
            
            navigationController?.popToRootViewController(animated: true)
        }
        
        @objc func register(_ sender: UIButton!){
            print("register")
            
            guard let window = self.view.window else {
                
                return
                
            }
            
            window.rootViewController = RegisterPageViewController()
            
            window.makeKeyAndVisible()
            
            let vc = RegisterPageViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
