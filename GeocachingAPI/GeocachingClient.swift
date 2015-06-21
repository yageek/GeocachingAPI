//
//  GeocachingClient.swift
//  GeocachingAPI
//
//  Created by Yannick Heinrich on 11/06/15.
//  Copyright (c) 2015 yageek. All rights reserved.
//

import Foundation
import SwiftOAuth1a

// MARK: Client
public class Client {
    
    /// The backed oauthClient
    let consumerKey:String
    let consumerSecret:String
    
    
    let GeocachingRequestTokenURL = "https://staging.geocaching.com/OAuth/oauth.ashx"
    let GeocachingAuthorizeURL = "https://staging.geocaching.com/OAuth/Authorize.aspx"

    //!MARK: Initialization
    
    /**
    Create a client from a consumer key and a consumer secret
    
    :param: consumerKey    The consumer key
    :param: consumerSecret The consumer secret
    
    */
    public init(consumerKey:String, consumerSecret:String){
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
    
    /**
    Load credentials from a stored plist
    
    :param: path      The path to the bundle
    :param: plistName The name of the plist. Default "GCOAUTH"
    :returns: A Client instance
    */
    public class func clientByLoadingBundleCredentials(bundlePath path:String? = nil, plistName:String? = nil) -> Client?{
        
        guard let credentials = PlistCredentials(bundlePath: path, plistName: plistName)  else { return nil}

        return Client(consumerKey: credentials.ConsumerKey, consumerSecret: credentials.ConsumerSecret)
    }
    
    
    //!MARK - Log
    public func Login(){
        
        let oauthSerializer = SwiftOAuth1a.Serializer(consumerKey: self.consumerKey, consumerSecret: self.consumerSecret)

        let request = oauthSerializer.URLRequest("GET", url: NSURL(string: GeocachingRequestTokenURL)!, parameters: ["oauth_callback" : "http://blog.yageek.net/"])
        
        var response:NSURLResponse?
        let data = try! NSURLConnection.sendSynchronousRequest(request!, returningResponse: &response)
        
        
        if let answer = NSString(data: data, encoding: NSUTF8StringEncoding){
            print("Answer:\(answer)")
        }
        
    


    }
    
}
