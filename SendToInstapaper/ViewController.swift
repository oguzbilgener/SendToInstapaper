//
//  ViewController.swift
//  SendToInstapaper
//
//  Created by Oguz Bilgener on 05/06/14.
//  Copyright (c) 2014 Oguz Bilgener. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var loginBarButton : UIBarButtonItem
	
	var loggedIn:Bool
	
	
	init(coder aDecoder: NSCoder!) {
		loggedIn = false
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var defaults = NSUserDefaults.standardUserDefaults()
		if(defaults.objectForKey("username") != nil && defaults.objectForKey("password") != nil) {
			loggedIn = true
		}
		
		if(loggedIn) {
			loginBarButton.title = "Log out"
		}
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
		NSLog("viewDidAppear")
	}

	override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
		// Get the new view controller using [segue destinationViewController].
		// Pass the selected object to the new view controller.
		if(segue!.identifier == "ShowLoginSegue" && loggedIn) {
			// log out action
			NSLog("do logout");
		}
	}
	

}

