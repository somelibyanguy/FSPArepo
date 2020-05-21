//
//  dangerousActionAlert.swift - Contains necessary code to set up the alert storyboards.
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 10/30/19.
//  Copyright © 2019 PoppinREPO. All rights reserved.
//

import UIKit

struct AlertButton {
    
    var title: String!
    
    // action is a function
    
    var action: (() -> Swift.Void)? = nil
    
}

/*
 This structure is the one used by external view controllers to pass the neccessary
 parameters to the alert view controller.
 */

struct AlertPayload {
    
    var icon: UIImage!
    
    var message: String!
    
    var buttons: [AlertButton]!
    
}

class dangerousActionAlert: UIViewController {
    
    // payload gets loaded in "Utils" with the necessary parameters.

    var payload: AlertPayload!
    
    @IBOutlet var dangerousActionAlertView: UIView!
    
    @IBOutlet weak var dangerousActionAlertIcon: UIImageView!
    
    @IBOutlet weak var dangerousActionAlertMessage: UILabel!
    
    @IBOutlet weak var dangerousActionAlertButton1: UIButton!
    
    @IBOutlet weak var dangerousActionAlertButton2: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*
         These two are set depending on the type of alert passed by the external
         ViewControllers.
         */
        
        dangerousActionAlertIcon.image = payload.icon
        
        dangerousActionAlertMessage.text = payload.message
        
        /*
         If the payload has only one button then "informationMissingAlert" storyboard
         is called, else "dangerousActionAlert" storyboard is called.
         */
        
        if (payload.buttons.count == 1) {
            
            createButton(alertButton: dangerousActionAlertButton1, payloadButton: payload.buttons[0])
            
        } else if (payload.buttons.count == 2) {
            
            createButton(alertButton: dangerousActionAlertButton1, payloadButton: payload.buttons[0])
            
            createButton(alertButton: dangerousActionAlertButton2, payloadButton: payload.buttons[1])
            
        }
        
    }
    
    // Set the shouldAutorotate to False
    
    override open var shouldAutorotate: Bool {
        
        return false
        
    }
       
    // Specify the orientation.
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
           return .portrait
        
    }
    
    private func createButton(alertButton: UIButton, payloadButton: AlertButton) {
        
        alertButton.setTitle(payloadButton.title, for: .normal);

    }
    
    /*
     This function is called when the "Cancel" or "OK" buttons are pressed.
     */
    
    @IBAction func button1Tapped() {
        
        parent?.dismiss(animated: false, completion: nil)
        
        payload.buttons.first?.action?()
        
    }
    
    /*
     This function is called when the "Proceed" button is pressed.
     */
    
    @IBAction func button2Tapped() {
        
        parent?.dismiss(animated: false, completion: nil)
        
        payload.buttons[1].action?()
        
    }
    
}
