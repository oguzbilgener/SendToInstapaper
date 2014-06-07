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
		
		// init the loading HUD
		hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		
		if(communicator.loggedIn) {
			hud!.labelText = "Sending"
			hud!.mode = MBProgressHUDModeIndeterminate
			communicator.save(url: "http://server2.oguzdev.com/asd", success: successfulSave, failure: failedSave)
		}
		else {
			hud!.mode = MBProgressHUDModeText
			hud!.labelText = "Invalid login"
			hud!.show(true)
			
			// display the message for a while, then hide it and cancel the extension
			hideHUDLater(action: cancelShare, seconds: nil)

		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func successfulSave() {
		hud!.hide(false)
		hud!.mode = MBProgressHUDModeText
		hud!.labelText = "Success"
		hud!.show(true)
		
		
		// So long, and thaks for all the fish
		hideHUDLater(action: cancelShare, seconds: 1)
	}
	
	func failedSave() {
		hud!.hide(false)
		hud!.mode = MBProgressHUDModeText
		hud!.labelText = "Error"
		hud!.show(true)
		
		
		// Oops
		hideHUDLater(action: cancelShare, seconds: 1)
	}
	
	func hideHUDLater(#action: ((Void)->Void)?, seconds:Int?) {
		var secs:Int
		if(seconds == nil) {
			secs = 2
		}
		else {
			secs = seconds!
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds!)*Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
			self.hud!.hide(true)
			if(action != nil) {
				action!()
			}
		}
	}
	
	func cancelShare() {
		self.extensionContext.cancelRequestWithError(NSError(domain: "SendToInstapaperErrorDomain", code: 0, userInfo: nil))
	}
}
