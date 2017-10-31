//
//  MusicLoverTests.swift
//  MusicLoverTests
//
//  Created by ST21235 on 2017/10/11.
//  Copyright © 2017 He Wu. All rights reserved.
//

//unit test file
import XCTest
@testable import MusicLover

class MusicLoverTests: XCTestCase {
    
    /*override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
    //Mark: Music Class Tests
    //Confirm that the Music initializer returns a Music object when passed valid parameters
    func testMusicInitializationSucceeds(){
        //Zero rating
        let zeroRatingMusic = Music.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMusic)
        
        //Highest positive rating
        let positiveRatingMusic = Music.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMusic)
        
        
    }
    //Confirm that the Music initialier returns nil when passed a negative rating or an empty name
    func testMusicInitializationFails(){
        //Negative rating
        //XCTAssertNil verifies by checking that the returned Music Ojects is nil
        let negativeRatingMusic = Music.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMusic)
        
        //Rating exceeds maximum
        let largeRatingMusic = Music.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMusic)
        
        //Empty String
        let emptyStringMusic = Music.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMusic)
    }
}
