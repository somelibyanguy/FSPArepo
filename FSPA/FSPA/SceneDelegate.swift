//
//  SceneDelegate.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 4/8/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var navigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        

        
        if let windowScene = scene as? UIWindowScene {
            
           let window = UIWindow(windowScene: windowScene)
            
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

//                            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
//                            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)

                       

                            leftMenuNavigationController.statusBarEndAlpha = 0
                            

                            leftMenuNavigationController.menuWidth = 3 * UIScreen.main.bounds.width/4
                            leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
                           

            
 
                       navigationController?.setNavigationBarHidden(true, animated: false)
                       
                       window.rootViewController = navigationController
                       
                       self.window = window
                       
                       window.makeKeyAndVisible()
            
        }

            
//            let homeVC = HomeViewController()
//
//            navigationController = UINavigationController(rootViewController: homeVC)
//
//            navigationController?.setNavigationBarHidden(true, animated: false)
//
//            window.rootViewController = navigationController
////
//          self.window = window
////
//            window.makeKeyAndVisible()
               
 //          }
        
        //configureInitialRootViewController(for: window)
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }

}
extension SceneDelegate {
    
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
//
//        guard let window = self.window else {
//
//            return
//
//        }
//
        navigationController = UINavigationController(rootViewController: initialViewController)

        navigationController?.setNavigationBarHidden(true, animated: false)
        
 //       window.layer.add(transition, forKey: kCATransition)
        
        window?.rootViewController = initialViewController
        
        //self.window = window

        window?.makeKeyAndVisible()
        
    }
    
}
