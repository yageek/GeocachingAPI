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
    
    func testPlistCredentialLoading() {
        
        let bundlePath = NSBundle(forClass: GeocachingAPITests.self).bundlePath
        
        let client = GeocachingAPI.APIClient.clientByLoadingBundleCredentials(bundlePath: bundlePath)
        XCTAssertNotNil(client)
    }
    
}
