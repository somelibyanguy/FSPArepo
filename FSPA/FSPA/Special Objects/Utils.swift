//
//  Utils.swift - Bridges between an external view controller and the alert view controllers.
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 10/30/19.
//  Copyright © 2019 PoppinREPO. All rights reserved.
//

import UIKit

class Utils {
    
    /*
     This function is called by the external view controller to create an alert view controller and
     initialize its parameters.
     */
    
    public func showAlert(payload: AlertPayload, parentViewController: UIViewController) {
        
        var customAlertController: dangerousActionAlert!
        
        if (payload.buttons.count == 1) {
            
            // The "informationMissingAlert" is called.
            
            customAlertController = (self.instantiateAlertStoryboard(storyboardName: "Alerts", viewControllerIdentifier: "informationMissingAlert") as! dangerousActionAlert)
            
        } else if (payload.buttons.count == 2) {
            
            // The "dangerousActionAlert" is called.
            
            customAlertController = (self.instantiateAlertStoryboard(storyboardName: "Alerts", viewControllerIdentifier: "dangerousActionAlert") as! dangerousActionAlert)
            
        } else {
            
            // Alert not yet supported
            
            print("\nERROR: Requested alert is not yet supported.\n")
            
            return
            
        }
        
        customAlertController?.payload = payload
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // *** ALERT VIEW CONTROLLER STYLING ***
        
        customAlertController.preferredContentSize.height = 150
        
        alertController.setValue(customAlertController, forKey: "contentViewController")
        
        alertController.view.layer.shadowColor = UIColor.black.cgColor
        
        alertController.view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        alertController.view.layer.shadowOpacity = 0.5
        
        alertController.view.layer.shadowRadius = 2
        
        parentViewController.present(alertController, animated: true, completion: nil)
        
    }
    
    /*
     This function is called in order to pick which of the two Alert storyboards will be called depending on the
     type of Alert the external view controller wants.
     */
    
    private func instantiateAlertStoryboard(storyboardName: String, viewControllerIdentifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        
    }
    
}
