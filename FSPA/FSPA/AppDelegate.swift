//
//  AppDelegate.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 4/8/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        
        FirebaseApp.configure()


        
        
        window = UIWindow(frame: UIScreen.main.bounds)
               
              if let window = window {
                    
                    let defaults = UserDefaults.standard
                    
                    let initialViewController: UIViewController

                    if let _ = Auth.auth().currentUser,
                        
                       let userData = defaults.object(forKey: "currentUser") as? Data,
                        
                       let user = try? JSONDecoder().decode(User.self, from: userData) {
                        
                        User.setCurrent(user)
                        
                        initialViewController = HomeViewController()
                        
                    } else {
                        
                        initialViewController = LoginViewController()
                        
                    }
                
                
                
                
                navigationController = UINavigationController(rootViewController: initialViewController)
                

                    let leftMenuNavigationController = SideMenuNavigationController(rootViewController: SlideMenuViewController())
                    SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
                    
                    SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
                    SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
                    

                    leftMenuNavigationController.statusBarEndAlpha = 0
                    leftMenuNavigationController.menuWidth = 3 * UIScreen.main.bounds.width/4
                    leftMenuNavigationController.setNavigationBarHidden(true, animated: false)

                           
                navigationController?.setNavigationBarHidden(true, animated: false)
                           
                window.rootViewController = navigationController
                           
                window.makeKeyAndVisible()
                   
//                   let homeVC = HomeViewController()
//
//                   navigationController = UINavigationController(rootViewController: homeVC)
//
//                   navigationController?.setNavigationBarHidden(true, animated: false)
//
//                   window.rootViewController = navigationController
//
 //                  window.makeKeyAndVisible()
                   
               }

        
        return true
        
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
extension AppDelegate {
    
    func configureInitialRootViewController(for window: UIWindow?) {
        
        let defaults = UserDefaults.standard
        
        let initialViewController: UIViewController

        if let _ = Auth.auth().currentUser,
            
           let userData = defaults.object(forKey: "currentUser") as? Data,
            
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            
            User.setCurrent(user)
            
            initialViewController = HomeViewController()
            
        } else {
            
            initialViewController = LoginViewController()
            
        }
        
//        let transition = CATransition()
//
//        transition.type = .fade
//
//        transition.duration = 0.5
        
        guard let window = self.window else {

            return

        }
        
        navigationController = UINavigationController(rootViewController: initialViewController)
//
        navigationController?.setNavigationBarHidden(true, animated: false)
        
   //     window.layer.add(transition, forKey: kCATransition)
        
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
        
    }
    
}


//        guard let window = self.window else {
//
//            return
//
//        }

//        navigationController = UINavigationController(rootViewController: initialViewController)
//
//        navigationController?.setNavigationBarHidden(true, animated: false)
//
//        window.layer.add(transition, forKey: kCATransition)
//
//        window.rootViewController = initialViewController
//
//        window.makeKeyAndVisible()
//
//
//        if let windowScene = scene as? UIWindowScene {
//
//            let window = UIWindow(windowScene: windowScene)
//
//           // let loginVC = LoginViewController()
//
//            navigationController = UINavigationController(rootViewController: initialViewController)
//
//            navigationController?.setNavigationBarHidden(true, animated: false)
//
//            window.rootViewController = navigationController
//
//            self.window = window
//
//            window.makeKeyAndVisible()
//
//        }
//    }
//
//}
//
//
