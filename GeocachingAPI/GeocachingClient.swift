//
//  GeocachingClient.swift
//  GeocachingAPI
//
//  Created by Yannick Heinrich on 11/06/15.
//  Copyright (c) 2015 yageek. All rights reserved.
//

import Foundation
import SwiftOAuth1a
import Locksmith
// MARK: Client
public class APIClient {
    
    struct GeocachingAPICredential : ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable {
        var oauthToken:String
        
        let service = "net.yageek.geocachingapi"
        let account = "geocachingAPILibrary"
        
        var data : [String:AnyObject] {
            return ["token" : oauthToken]
        }
        
    }
    
    public enum GeocachingAPIError : ErrorType {
        case InvalidCallbackURL
    }
    
    /// The backed oauthClient
    let oauthSerializer:SwiftOAuth1a.Serializer
    public let callbackURL:NSURL
    
    let api = GeocachingAPI.API()
    let GeocachingRequestOAuthURL = "https://staging.geocaching.com/OAuth/oauth.ashx"
    let GeocachingAPIBaseURL = NSURL(string: "https://staging.api.groundspeak.com/Live/V6Beta/geocaching.svc")!
    var credential = GeocachingAPICredential(oauthToken: "")
    
   public var isConnected:Bool {
        get {
            return self.oauthSerializer.tokenSecret != nil
        }
    }
    
    //!MARK: Initialization
    
    /**
    Create a client from a consumer key and a consumer secret
    
    :param: consumerKey    The consumer key
    :param: consumerSecret The consumer secret
    
    */
    public init(consumerKey:String, consumerSecret:String, callbackURL:NSURL){
        self.oauthSerializer = Serializer(consumerKey: consumerKey, consumerSecret: consumerSecret)
        self.callbackURL = callbackURL
        let passwordResult:GenericPasswordSecureStorableResultType? = credential.readFromSecureStore()
        
        if let token = passwordResult?.data?["token"] as? String {
            oauthSerializer.tokenSecret = token
        }
        

      
    }
    
    /**
    Load credentials from a stored plist
    
    :param: path      The path to the bundle
    :param: plistName The name of the plist. Default "GCOAUTH"
    :returns: A Client instance
    */

    public class func clientByLoadingBundleCredentials(bundlePath path:String? = nil, plistName:String? = nil) -> APIClient?{
        
        guard let credentials = PlistCredentials(bundlePath: path, plistName: plistName)  else { return nil}

        return APIClient(consumerKey: credentials.ConsumerKey, consumerSecret: credentials.ConsumerSecret, callbackURL: credentials.CallbackURL)
    }
    
    
    // MARK: Login
    /*!
    @abstract
    Get LoginURL
    
    @param callback The callback returning the NSURL to log
    */
    public func LoginURL(callback:(loginURL:NSURL?) -> Void ){
        
        //Start requeting
        let request = self.oauthSerializer.URLRequest("GET", url: NSURL(string: GeocachingRequestOAuthURL)!, parameters: ["oauth_callback" :  callbackURL.absoluteString])

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in

            var response:NSURLResponse? = nil
            var reply:NSData
            
            var accessToken:String? = nil
            var tokenSecret:String? = nil
            
            do {


                reply = try NSURLConnection.sendSynchronousRequest(request!, returningResponse: &response)
                
                let httpResponse = response as? NSHTTPURLResponse
                
                if httpResponse?.statusCode == 200 {
                    
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
                    
                }
                
                } catch {
                print("An error occured:\(error)")
            }
            
            let loginURL:NSURL?
            if let uwAcessToken = accessToken, let uwTokenSecret = tokenSecret {
                self.oauthSerializer.accessToken = uwAcessToken
                self.oauthSerializer.tokenSecret = uwTokenSecret
                
                let URLString = String(format: "%@?oauth_token=%@&force_login=true", arguments: [self.GeocachingRequestOAuthURL, uwAcessToken])
                loginURL = NSURL(string: URLString)
            } else {
                loginURL = nil
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                callback(loginURL: loginURL)
            })
        })
    }
    /*!
    Read the token provided by the callback
    
    @param url The url of the callback
    @returns true if succeed to read the content
    */
    public func readTokenFromCallback(url:NSURL) -> Bool {
        
       let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
       
        guard let scheme = components?.scheme, host = components?.host  else { return false }
            
        if scheme != self.callbackURL.scheme ||  host != self.callbackURL.host {
            return false
        }
        
        guard let items = components?.queryItems else { return false }
        
        var token:String? = nil
        
        for item in items {
            
            if item.name == "oauth_token" {
                token = item.value
                break
            }
        }
        
        guard let tok = token else { return false }
        
        self.oauthSerializer.accessToken = tok
        credential.oauthToken = tok
        
        do {
            try credential.createInSecureStore()
        } catch {
            print("Could not store token into the keychain. It will be lost after the application quits")
        }
        
        return true
        
    }
    
    //Mark: Endpoint
    public func GetUserProfile(callback:((profile:AnyObject) -> Void)?){
        
        let request = NSMutableURLRequest(URL: NSURL(string:"https://staging.api.groundspeak.com/Live/V6Beta/geocaching.svc/GetYourUserProfile")!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let profileOptions = [
            "ChallengesData" : true,
            "FavoritePointsData" : true,
            "GeocacheData" : true,
            "PublicProfileData": true,
            "SouvenirData": true,
            "TrackableData" : true,
            "EmailData" : true
        ] as NSDictionary

        let dict = [
            "AccessToken" : self.oauthSerializer.accessToken!,
            "ProfileOptions" : profileOptions
        ] as NSDictionary
        
        var data:NSData? = nil
        do {
            data = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
        } catch {
            print("Could not serialize data:\(error)")
        }
        print("Data:\(data)")
        
    }

}
    
    


