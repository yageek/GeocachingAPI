//
//  APIEndpoint.swift
//  GeocachingAPI
//
//  Created by Yannick Heinrich on 23/06/15.
//  Copyright © 2015 yageek. All rights reserved.
//

import Foundation


public struct API {
    
    public struct Endpoint{
        let method:String
        let endpoint:String
        static let baseURL = NSURL(string:"https://staging.api.groundspeak.com/Live/V6Beta/geocaching.svc")!
        
        
        init(method:String, _ endpoint:String){
            self.method = method
            self.endpoint = endpoint
        }
        
        var URLRequest: NSMutableURLRequest { get {
            
            let url = Endpoint.baseURL.URLByAppendingPathComponent(self.endpoint)
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = self.method
            return request
            }
        }
    }
    
    public let AddFavoritePointToCache = Endpoint(method: "GET", "/AddFavoritePointToCache")
    public let AddGeocachesToBookmarkList = Endpoint(method: "POST", "/AddGeocachesToBookmarkList")
    
}