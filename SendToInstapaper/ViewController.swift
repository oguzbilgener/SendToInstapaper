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
		// Do any additional setup after loading the view, typically from a nib.
		
		if(loggedIn) {
			self.navigationItem.rightBarButtonItems = nil;
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

