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

	var hud:MBProgressHUD?
	var communicator:APICommunicator?
	
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
	
	init(coder aDecoder: NSCoder!) {
		super.init(coder: aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		// transparent bg color
		self.view.backgroundColor = UIColor.clearColor()
		
		communicator = APICommunicator()
		
		// init the loading HUD
		hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		
		// Try to get input items
		var extensionItems = self.extensionContext.inputItems
		if(extensionItems.count > 0) {
			if (communicator!.loggedIn) {
				// get the first attachment
				var item = extensionItems[0] as NSExtensionItem
				var attachments = item.attachments
				
				// gotta love AnyObject
				if let urlProvider = attachments[0] as? NSItemProvider {
					// The attachment has to be a URL. We cannot accept it otherwise.
					urlProvider.loadItemForTypeIdentifier("public.url", options: nil) {
						(decoder: NSSecureCoding!, error: NSError!) -> Void in
						if let url = decoder as? NSURL {
							// we found our URL, start sending!
							self.hud!.labelText = "Sending"
							self.hud!.mode = MBProgressHUDModeIndeterminate
							self.communicator!.save(url: url.absoluteString, success: self.successfulSave, failure: self.failedSave)
						}
						else {
							self.showTextError("Please select a URL")
						}
					}
				}
				else {
					self.cancelShare()
				}
				
			}
			else {
				self.showTextError("Please log in first")
			}
		}
		else {
			self.showTextError("Please select a URL")
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func successfulSave() {
		hud!.hide(false)
		hud = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
		hud!.mode = MBProgressHUDModeText
		hud!.labelText = "Success"
		
		
		// So long, and thaks for all the fish
		hideHUDLater(action: finalizeShare, seconds: 1)
	}
	
	func failedSave() {
		hud!.hide(false)
		hud = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
		hud!.mode = MBProgressHUDModeText
		hud!.labelText = "Error"
		
		// Oops
		hideHUDLater(action: cancelShare, seconds: 1)
	}
	
	func showTextError(text: String) {
		hud!.mode = MBProgressHUDModeText
		hud!.labelText = text
		hud!.show(true)
		// display the message for a while, then hide it and cancel the extension
		hideHUDLater(action: cancelShare, seconds: nil)
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
			if(action) {
				action!()
			}
		}
	}
	
	func finalizeShare() {
		self.extensionContext.completeRequestReturningItems(Array<NSExtensionItem>()) {
			(expired: Bool) -> Void in
			NSLog("done")
		}
	}
	
	func cancelShare() {
		self.extensionContext.cancelRequestWithError(NSError(domain: "SendToInstapaperErrorDomain", code: 0, userInfo: nil))
	}
}
