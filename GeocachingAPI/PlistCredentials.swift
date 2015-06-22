//
//  PlistCredentials.swift
//  GeocachingAPI
//
//  Created by Yannick Heinrich on 17/06/15.
//  Copyright (c) 2015 yageek. All rights reserved.
//

import Foundation

// MARK: Plist Credential
public struct PlistCredentials {
    
    static let DefaultPlistName = "GCOAUTH"
    static let ConsumerKeyPlistKey = "ConsumerKey"
    static let ConsumerSecretPlistKey = "ConsumerSecret"
    static let CallbackURLPlistKey = "Callback"
    
    let ConsumerKey:String
    let ConsumerSecret:String
    let CallbackURL:NSURL
    
    /**
    Check whether the plist at the given URL contains the required elements
    
    :param: plistURL The NSURL? of the plist
    
    :returns: A tuple of String with keys (ConsumerKey, ConsumerSecret)
    */
    static func keysForPlist(url plistURL:NSURL) -> (ConsumerKey: String, ConsumerSecret: String, CallbackURL:NSURL)? {
        
        if let plist = NSDictionary(contentsOfURL: plistURL) {
            if let consumerKey = plist[PlistCredentials.ConsumerKeyPlistKey] as? String, consumerSecret = plist[PlistCredentials.ConsumerSecretPlistKey] as? String, let  callbackURL = plist[PlistCredentials.CallbackURLPlistKey] as? String {
                
                if let url = NSURL(string: callbackURL)
                {
                    return (ConsumerKey: consumerKey, ConsumerSecret: consumerSecret, CallbackURL: url)
                    
                } else{
                    return nil
                }

            }
            return nil
        }
        
        return nil
    }
    
    /**
    Default initializer
    
    :param: bundlePath The bundle to use
    :param: plistName The plist filename
    
    */
    init?(bundlePath path:String? = nil, plistName plist:String?){
        
        let bundle:NSBundle?
        
        if let bundlePath = path {
            
            bundle = NSBundle(path: bundlePath)
        } else {
            bundle = NSBundle.mainBundle()
        }
        
        let plistName = plist ?? PlistCredentials.DefaultPlistName
        
        print("Load credential in \(plistName).plist from bundle: \(bundle?.resourcePath)")
        
        if let plistURL = bundle?.URLForResource(plistName, withExtension: "plist"){
            
            if let (key, secret, url) = PlistCredentials.keysForPlist(url: plistURL){
                ConsumerSecret = secret
                ConsumerKey = key
                CallbackURL = url
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
}
