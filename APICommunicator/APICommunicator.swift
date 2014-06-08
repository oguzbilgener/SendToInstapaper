//
//  APICommunicator.swift
//  SendToInstapaper
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
	
	let kUsername = "username"
	let kPassword = "password"
	let kUrl = "url"
	let kDefaultsPackage = "com.oguzdev.SendToInstapaper.shared"
	
	init() {
		var defaults = NSUserDefaults(suiteName: kDefaultsPackage)
		manager = AFHTTPRequestOperationManager()
		if(defaults.objectForKey(kUsername) != nil && defaults.objectForKey(kPassword) != nil) {
			username = defaults.objectForKey(kUsername) as String
			password = defaults.objectForKey(kPassword) as String
			loggedIn = true
		}
		else {
			username = ""
			password = ""
			loggedIn = false
		}
	}
	
	func storeLogin(#username: String, password: String) {
		var defaults = NSUserDefaults(suiteName: kDefaultsPackage)
		self.username = username
		self.password = password
		defaults.setObject(username, forKey: kUsername)
		defaults.setObject(password, forKey: kPassword)
		
		defaults.synchronize()
	}
	
	func login(#success: (Void)->Void, failure: (Void)->Void) {
		var params = [kUsername: username, kPassword: password]
		
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
	
	func save(#url:String, success: (Void)->Void, failure: (Void)->Void) {
		if(!loggedIn) {
			failure()
			return
		}
		var params = [kUsername: username, kPassword: password, kUrl: url]
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
	
	func logout() {
		var defaults = NSUserDefaults(suiteName: kDefaultsPackage)
		defaults.removeObjectForKey(kUsername)
		defaults.removeObjectForKey(kPassword)
		loggedIn = false
	}
	
	
}