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
    
    let ConsumerKey:String
    let ConsumerSecret:String
    
    /**
    Check whether the plist at the given URL contains the required elements
    
    :param: plistURL The NSURL? of the plist
    
    :returns: A tuple of String with keys (ConsumerKey, ConsumerSecret)
    */
    static func keysForPlist(url plistURL:NSURL) -> (ConsumerKey: String, ConsumerSecret: String)? {
        
        if let plist = NSDictionary(contentsOfURL: plistURL) {
            if let consumerKey = plist[PlistCredentials.ConsumerKeyPlistKey] as? String, consumerSecret = plist[PlistCredentials.ConsumerSecretPlistKey] as? String {
                return (ConsumerKey: consumerKey, ConsumerSecret: consumerSecret)
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
            
            if let (key, secret) = PlistCredentials.keysForPlist(url: plistURL){
                ConsumerSecret = secret
                ConsumerKey = key
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
}
