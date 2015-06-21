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
    let oauthSerializer:SwiftOAuth1a.Serializer
    
    
    let GeocachingRequestTokenURL = "https://staging.geocaching.com/OAuth/oauth.ashx"
    let GeocachingAuthorizeURL = "https://staging.geocaching.com/OAuth/Authorize.aspx"

    //!MARK: Initialization
    
    /**
    Create a client from a consumer key and a consumer secret
    
    :param: consumerKey    The consumer key
    :param: consumerSecret The consumer secret
    
    */
    public init(consumerKey:String, consumerSecret:String){
        self.oauthSerializer = Serializer(consumerKey: consumerKey, consumerSecret: consumerSecret)
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
    public func Login(callback:(authToken:String?, tokenSecret:String? ) -> Void ){

        let request = self.oauthSerializer.URLRequest("GET", url: NSURL(string: GeocachingRequestTokenURL)!, parameters: ["oauth_callback" : "http://blog.yageek.net/"])

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in

            var response:NSURLResponse? = nil
            var reply:NSData
            
            var accessToken:String? = nil
            var tokenSecret:String? = nil
            
            do {
                reply = try NSURLConnection.sendSynchronousRequest(request!, returningResponse: &response)
                
                if let raw_string = NSString(data: reply, encoding: NSUTF8StringEncoding){
                    
                    let nodes = raw_string.componentsSeparatedByString("&")
                    
                    for node in nodes {
                        let token = node.componentsSeparatedByString("=")
                        
                        let key = token[0]
                        let value = token[1]
                        
                        if key == "oauth_token" {
                            accessToken = value
                        }
                        
                        if key == "oauth_token_secret" {
                            tokenSecret = value
                        }
                    }
                    
                }
            } catch {
                
            }

            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                callback(authToken: accessToken, tokenSecret: tokenSecret)
            })
        })

        
    
    
        
            
    
        
    


    }
    
}
