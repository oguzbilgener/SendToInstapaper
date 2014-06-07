//
//  APICommunicator.swift
//  APICommunicator
//
//  Created by Oguz Bilgener on 07/06/14.
//  Copyright (c) 2014 Oguz Bilgener. All rights reserved.
//

import UIKit

class APICommunicator {
	
	var loggedIn:Bool
	var username:String
	var password:String
	var manager:AFHTTPRequestOperationManager
	
	let loginURLString = "https://www.instapaper.com/api/authenticate"
	let saveURLString = "https://www.instapaper.com/api/add"
	
	init() {
		manager = AFHTTPRequestOperationManager()
		var defaults = NSUserDefaults.standardUserDefaults()
		if(defaults.objectForKey("username") != nil && defaults.objectForKey("password") != nil) {
			username = defaults.objectForKey("username") as String
			password = defaults.objectForKey("password") as String
			loggedIn = true
		}
		else {
			loggedIn = false
			username = ""
			password = ""
		}
	}
	
	func storeLogin(#username: String, password: String) {
		var defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(username, forKey: "username")
		defaults.setObject(password, forKey: "password")
		
		defaults.synchronize()
	}
	
	func login(#success: (Void)->Void, failure: (Void)->Void) {
		var params = ["username": username, "password": password]
		manager.responseSerializer = AFHTTPResponseSerializer()
		manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain"]);
		
		manager.POST(loginURLString, parameters: params,
			success: {
				(operation: AFHTTPRequestOperation!, responseObject: AnyObject!)->(Void) in NSLog("s")
				success()
			}, failure: {
				(operation: AFHTTPRequestOperation!, error:NSError!) -> Void in NSLog("f "+error.localizedDescription+" "+String(operation.response.statusCode))
				failure()
		})
	}
	
	func save(#url:String!, success: (Void)->Void, failure: (Void)->Void) {
		if(!loggedIn) {
			failure()
			return
		}
		var params = ["username": username, "password": password, "url": url]
		manager.responseSerializer = AFHTTPResponseSerializer()
		manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain"]);
		
		manager.POST(loginURLString, parameters: params,
			success: {
				(operation: AFHTTPRequestOperation!, responseObject: AnyObject!)->(Void) in
				success()
			}, failure: {
				(operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
				failure()
		})
	}
	
	
}
