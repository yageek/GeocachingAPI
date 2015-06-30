//
//  KeychainWrapper.swift
//  GeocachingAPI
//
//  Created by Yannick Heinrich on 27/06/15.
//  Copyright © 2015 yageek. All rights reserved.
//

import UIKit
import Security

public class KeychainWrapper: NSObject {

     public enum Error : ErrorType {
        case InvalidData
        case StoreFailed
    }
    
    static let Service = "net.yageek.geocachingapi";
    static let OAuthToken = "net.yageek.geocachingapi.oauthtoken"
    
    func readOAuthToken() -> String?  {
        
       var dataTypeRef :Unmanaged<AnyObject>?
        
        let query = [
            (kSecClass as String): (kSecClassGenericPassword as String),
            (kSecAttrAccount as String): (KeychainWrapper.OAuthToken as String),
           
        ]
        
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        switch(status){
        case errSecSuccess:
            
            if let op = dataTypeRef?.toOpaque() {
                let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()

                // Convert the data retrieved from the keychain into a string
                return NSString(data: retrievedData, encoding: NSUTF8StringEncoding) as? String
            } else {
                return nil
            }
        default: return nil
        }
        
        
    }
    
    func storeOAuthToken(token:String) throws {
        
        
        guard let data = token.dataUsingEncoding(NSUTF8StringEncoding) else { throw Error.InvalidData }
        
        let query = [
            (kSecClass as String): (kSecClassGenericPassword as String),
            (kSecAttrAccount as String): (KeychainWrapper.OAuthToken as String),
            (kSecClass as String): (kSecClassGenericPassword as String),
            (kSecAttrAccessible as String) : (kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String),
            (kSecValueData as String) : data
        ]
        
        
         var dataTypeRef :Unmanaged<AnyObject>?
         let status = SecItemAdd(query as CFDictionary, &dataTypeRef)
        
        switch(status){
            
        case errSecSuccess:
            print("Toke successfully stored");
        case errSecDuplicateItem:
            
            let updateQuery = [
                (kSecAttrAccessible as String) : (kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String),
                (kSecValueData as String) : data
            ]
            
            let status = SecItemUpdate(query, updateQuery)
            
            if status == errSecSuccess {
                print("Token successfully stored")
            } else {
                throw Error.StoreFailed
            }
            
        default:
            throw Error.StoreFailed
        }
        

    }
    
}
