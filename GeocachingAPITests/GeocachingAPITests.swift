//
//  GeocachingAPITests.swift
//  GeocachingAPITests
//
//  Created by Yannick Heinrich on 25/06/15.
//  Copyright © 2015 yageek. All rights reserved.
//

import XCTest
import GeocachingAPI

class GeocachingAPITests: XCTestCase {
    
    var client:GeocachingAPI.APIClient!
    
    override func setUp() {
        
        let bundlePath = NSBundle(forClass: GeocachingAPITests.self).bundlePath
        self.client = GeocachingAPI.APIClient.clientByLoadingBundleCredentials(bundlePath: bundlePath)
    }
    
    func testInitialValues() {
        XCTAssertNotNil(client)
        XCTAssertFalse(client.isConnected)
    }
    
    

    
}
