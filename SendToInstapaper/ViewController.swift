//
//  ViewController.swift
//  SendToInstapaper
//
//  Created by Oguz Bilgener on 05/06/14.
//  Copyright (c) 2014 Oguz Bilgener. All rights reserved.
//

import UIKit
import APICommunicator

class ViewController: UIViewController {
	
	@IBOutlet var loginBarButton : UIBarButtonItem
	
	var communicator: APICommunicator?
	
	init(coder aDecoder: NSCoder!) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let accentColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
//		var barAttributes:NSDictionary? = self.navigationController.navigationBar.titleTextAttributes
//		
//		if let attrs = barAttributes {
//		}
//		else {
//			barAttributes = NSDictionary()
//		}
//		barAttributes!.setValue(accentColor, forKey: UITextAttributeTextColor)
//		self.navigationController.navigationBar.titleTextAttributes = barAttributes!
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidAppear(animated: Bool) {
		// Update UI and communicator every time the VC appears
		communicator = APICommunicator()
		
		if(communicator!.loggedIn) {
			loginBarButton.title = "Log out"
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
		// Get the new view controller using [segue destinationViewController].
		// Pass the selected object to the new view controller.
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
		// If this is a show LoginViewController segue and the user is already logged in, log out instead
		// because the same button is used for log in and log out actions.
		// Also do not show the controller for this time.
		if(identifier! == "ShowLoginSegue" && communicator!.loggedIn) {
			NSLog("do logout");
			loginBarButton.title = "Log in"
			communicator!.logout()
			return false
		}
		return true
	}
	

}

