//
//  LoginViewController.swift
//  SendToInstapaper
//
//  Created by Oguz Bilgener on 05/06/14.
//  Copyright (c) 2014 Oguz Bilgener. All rights reserved.
//

import UIKit
import APICommunicator

class LoginViewController: UIViewController {

	@IBOutlet var emailField : UITextField
	@IBOutlet var passwordField : UITextField
	
	var communicator: APICommunicator
	
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		communicator = APICommunicator()
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
	
	init(coder aDecoder: NSCoder!) {
		communicator = APICommunicator()
		super.init(coder: aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view!.backgroundColor = UIColor(patternImage: UIImage(named: "login_background"))

//		if let navItem = self.navigationItem  {
//			navItem.backBarButtonItem.title = "Back"
//		}
//		self.navigationItem.backBarButtonItem.title = "Back"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loginCancelled(sender : AnyObject) {
		// just dismiss the modal
		self.dismissModalViewControllerAnimated(true)
	}
	
	@IBAction func loginSubmitted(sender : AnyObject) {
		var emailAddress = String(emailField.text)
		var password = String(passwordField.text)

		if(countElements(emailAddress) == 0 || countElements(password) == 0) {
			// TODO: display a simple error
			NSLog("empty email address or password")
		}
		else {
			var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
			func successfulLogin() {
				hud.hide(true)
				hud.mode = MBProgressHUDModeText
				hud.labelText = "Success!"
				hud.show(true)
				
				// gotta remember the user credentials to use the simple api
				// might not be the securest solution.
				communicator.storeLogin(username: emailAddress, password: password)
				
				// done for now.
				self.dismissModalViewControllerAnimated(true)
			}
			
			func failedLogin() {
				hud.hide(true)
				hud.mode = MBProgressHUDModeText
				hud.labelText = "Invalid login."
				hud.show(true)
			}
			
			communicator.login(success: successfulLogin, failure: failedLogin)
		}
	}
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
