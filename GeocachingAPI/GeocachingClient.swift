//
//  GeocachingClient.swift
//  GeocachingAPI
//
//  Created by Yannick Heinrich on 11/06/15.
//  Copyright (c) 2015 yageek. All rights reserved.
//

import Foundation
import OAuthSwift


// MARK: Client
public class Client {
    

    
    /// The backed oauthClient
    let oauthClient:OAuthSwiftClient!
    
    /**
    Create a client from a consumer key and a consumer secret
    
    :param: consumerKey    The consumer key
    :param: consumerSecret The consumer secret
    
    */
    public init(consumerKey:String, consumerSecret:String){
        oauthClient = OAuthSwiftClient(consumerKey: consumerKey, consumerSecret: consumerKey)
    }
    /**
    Load credentials from a stored plist
    
    :param: path      The path to the bundle
    :param: plistName The name of the plist. Default "GCOAUTH"
    :returns: A Client instance
    */
    public class func clientByLoadingBundleCredentials(bundlePath path:String? = nil, plistName:String? = nil) -> Client?{
        
        if let credentials = PlistCredentials(bundlePath: path, plistName: plistName) {
            return Client(consumerKey: credentials.ConsumerKey, consumerSecret: credentials.ConsumerSecret)
        } else {
            return nil
        }
    }
    
    
}
