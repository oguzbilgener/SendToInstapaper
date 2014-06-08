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

	@IBOutlet var usernameField : UITextField
	@IBOutlet var passwordField : UITextField
	
	var hud:MBProgressHUD?
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
		var username = String(usernameField.text)
		var password = String(passwordField.text)
		
		// gotta remember the user credentials to use the simple api
		// might not be the securest solution.
		communicator.storeLogin(username: username, password: password)

		if(countElements(username) == 0 || countElements(password) == 0) {
			// TODO: display a simple error
			NSLog("empty username or password")
		}
		else {
			hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
			func successfulLogin() {
				NSLog("successful login")
				hud!.hide(true)
				hud = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
				hud!.mode = MBProgressHUDModeText
				hud!.labelText = "Success!"

				// done for now.
				self.hideHUDLater(action: {
						self.navigationController.popViewControllerAnimated(true)
						return
					}, seconds: 1)
			}
			
			func failedLogin() {
				NSLog("failed login")
				hud!.hide(true)
				hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
				hud!.mode = MBProgressHUDModeText
				hud!.labelText = "Invalid login"
				
				self.hideHUDLater(action: nil, seconds: 2)
			}
			
			communicator.login(success: successfulLogin, failure: failedLogin)
		}
	}
	
	func hideHUDLater(#action: ((Void)->Void)?, seconds:Int?) {
		var secs:Int
		if(seconds == nil) {
			secs = 2
		}
		else {
			secs = seconds!
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(secs)*Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
			self.hud!.hide(true)
			if(action != nil) {
				action!()
			}
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
