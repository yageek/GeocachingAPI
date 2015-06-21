//
//  GeocachingAPITests.swift
//  GeocachingAPITests
//
//  Created by Yannick Heinrich on 11/06/15.
//  Copyright (c) 2015 yageek. All rights reserved.
//

import UIKit
import XCTest
import GeocachingAPI

class GeocachingAPITests: XCTestCase {
    
    func testLoadingBundle() {
        
        let testBundle = NSBundle(forClass: GeocachingAPITests.self)
        
        let client = Client.clientByLoadingBundleCredentials(bundlePath: testBundle.resourcePath, plistName:"GeocachingAPI")
        XCTAssertNotNil(client, "Should success to initialize")
        

        client?.Login()
    }
    
    
    
}
