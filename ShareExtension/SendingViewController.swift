//
//  SendingViewController.swift
//  SendToInstapaper
//
//  Created by Oguz Bilgener on 07/06/14.
//  Copyright (c) 2014 Oguz Bilgener. All rights reserved.
//

import UIKit
import APICommunicator

class SendingViewController: UIViewController {

	var loggedIn:Bool
	var hud:MBProgressHUD?
	var communicator:APICommunicator
	
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		loggedIn = false
		communicator = APICommunicator()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
	
	init(coder aDecoder: NSCoder!) {
		loggedIn = false
		communicator = APICommunicator()
		super.init(coder: aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		// transparent bg color
		self.view.backgroundColor = UIColor.clearColor()
		
		var defaults = NSUserDefaults.standardUserDefaults()
		if(defaults.objectForKey("username") != nil && defaults.objectForKey("password") != nil) {
			loggedIn = true
		}
		
		var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		
		if(loggedIn) {
			hud.labelText = "Sending"
		}
		else {
			hud.mode = MBProgressHUDModeText
			hud.labelText = "Invalid login"
			hud.show(true)
			
			// display the message for one second, then hide it and cancel the extension
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2)*Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
				hud.hide(true)
				self.extensionContext.cancelRequestWithError(NSError(domain: "SendToInstapaperErrorDomain", code: 0, userInfo: nil))
			}

		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
