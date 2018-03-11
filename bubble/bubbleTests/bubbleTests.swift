//
//  bubbleTests.swift
//  bubbleTests
//
//  Created by Sawyer Blatz on 1/31/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import XCTest
import Firebase
@testable import bubble

class bubbleTests: XCTestCase {
    
    override func setUp() {
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
        
        print("Hello")
        XCTAssert(true)
    }
    
    func testSignUpAndDeleteUser() {
        var users = [[String: Any]]()
        
        users.append(["email": "test1@gmail.com",
                      "password": "test1password",
                      "name": "test1"
            ])
        users.append(["email": "test2@gmail.com",
                      "password": "test2password",
                      "name": "test2"
            ])
        users.append(["email": "test3@gmail.com",
                      "password": "tester4",
                      "name": "test3"
            ])
        users.append(["email": "test4@gmail.com",
                      "password": "tester4",
                      "name": "test4"
            ])
        
        
        let expect = expectation(description: "Create users")
        expect.expectedFulfillmentCount = users.count
        
        
        for user in users {
            AuthService.sharedInstance.registerEmail(userData: user, success: { (newUser) in
                AuthService.sharedInstance.deleteUser(user: newUser, success: { (success) in
                    expect.fulfill()
                }, failure: { (error) in
                    XCTFail(error.localizedDescription)
                })
                
            }, failure: { (error) in
                XCTFail(error.localizedDescription)
            })
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testCreateBubble() {
        var bubbles: [[String: Any]] = []
        var bubblesCoordinates: [(latitude: Double, longitude: Double)] = []
        
        let bubble1 = ["text": "WOW"] as [String : Any]
        let bubbleCoordinate1 = (43.934857, 24.029348)
        
        let bubble2 = ["text": "AWESOME"] as [String : Any]
        let bubbleCoordinate2 = (43.934857, 24.029348)
        
        let bubble3 = ["text": "DUDE"] as [String : Any]
        let bubbleCoordinate3 = (43.934857, 24.029348)
        
        let bubble4 = ["text": "COOL"] as [String : Any]
        let bubbleCoordinate4 = (43.934857, 24.029348)
        
        bubbles.append(bubble1)
        bubbles.append(bubble2)
        bubbles.append(bubble3)
        bubbles.append(bubble4)
        
        bubblesCoordinates.append(bubbleCoordinate1)
        bubblesCoordinates.append(bubbleCoordinate2)
        bubblesCoordinates.append(bubbleCoordinate3)
        bubblesCoordinates.append(bubbleCoordinate4)
        
        let expect = expectation(description: "Create Bubbles")
        expect.expectedFulfillmentCount = bubbles.count
        
        Auth.auth().signIn(withEmail: "tester@example.com", password: "123456") { (user, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else if let user = user {
                for (bubble, coordinates) in zip(bubbles, bubblesCoordinates) {
                    var bubbleData = bubble
                    bubbleData["owner"] = user.uid
                    DataService.instance.createBubble(bubbleData: bubbleData, latitude: coordinates.latitude, longitude: coordinates.longitude, success: { (bubble) in
                        expect.fulfill()
                    }, failure: { (error) in
                        XCTFail(error.localizedDescription)
                    })
                }
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testGetBubbles() {
        let expect = expectation(description: "Get Bubbles")
        DataService.instance.getBubbles(latitude: 43.934857, longitude: 24.029348, success: { (bubbles) in
            expect.fulfill()
        }) { (error) in
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testGetUserBubbles() {
        let expect = expectation(description: "Get User Bubbles")
        
        Auth.auth().signIn(withEmail: "tester@example.com", password: "123456") { (user, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else if let user = user {
                DataService.instance.getUserBubbles(uid: user.uid, success: { (bubbles) in
                    expect.fulfill()
                }, failure: { (error) in
                    XCTFail(error.localizedDescription)
                })
            }
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testDeleteBubble() {
        var bubbles: [[String: Any]] = []
        var bubblesCoordinates: [(latitude: Double, longitude: Double)] = []
        
        let bubble1 = ["text": "WOW"] as [String : Any]
        let bubbleCoordinate1 = (43.934857, 24.029348)
        
        let bubble2 = ["text": "AWESOME"] as [String : Any]
        let bubbleCoordinate2 = (43.934857, 24.029348)
        
        let bubble3 = ["text": "DUDE"] as [String : Any]
        let bubbleCoordinate3 = (43.934857, 24.029348)
        
        let bubble4 = ["text": "COOL"] as [String : Any]
        let bubbleCoordinate4 = (43.934857, 24.029348)
        
        bubbles.append(bubble1)
        bubbles.append(bubble2)
        bubbles.append(bubble3)
        bubbles.append(bubble4)
        
        bubblesCoordinates.append(bubbleCoordinate1)
        bubblesCoordinates.append(bubbleCoordinate2)
        bubblesCoordinates.append(bubbleCoordinate3)
        bubblesCoordinates.append(bubbleCoordinate4)
        
        let expect = expectation(description: "Delete Bubbles")
        expect.expectedFulfillmentCount = bubbles.count
        
        Auth.auth().signIn(withEmail: "tester@example.com", password: "123456") { (user, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else if let user = user {
                for (bubble, coordinates) in zip(bubbles, bubblesCoordinates) {
                    var bubbleData = bubble
                    bubbleData["owner"] = user.uid
                    DataService.instance.createBubble(bubbleData: bubbleData, latitude: coordinates.latitude, longitude: coordinates.longitude, success: { (bubble) in
                        DataService.instance.deleteBubble(bubble: bubble, success: { (success) in
                            expect.fulfill()
                        }, failure: { (error) in
                            XCTFail(error.localizedDescription)
                        })
                    }, failure: { (error) in
                        XCTFail(error.localizedDescription)
                    })
                }
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testBubbleVote() {
        let expect = expectation(description: "Bubble Vote")
        
        var bubble1 = ["text": "WOW"] as [String : Any]
        let bubbleCoordinate1 = (latitude: 43.934857, longitude: 24.029348)
        
        Auth.auth().signIn(withEmail: "tester@example.com", password: "123456") { (user, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else if let user = user {
                bubble1["owner"] = user.uid
                DataService.instance.createBubble(bubbleData: bubble1, latitude: bubbleCoordinate1.latitude, longitude: bubbleCoordinate1.longitude, success: { (bubble) in
                    DataService.instance.voteBubble(bubble: bubble, uid: user.uid, success: { (newValue) in
                        expect.fulfill()
                    }, failure: { (error) in
                        XCTFail(error.localizedDescription)
                    })
                }, failure: { (error) in
                    XCTFail(error.localizedDescription)
                })
                
            }
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    
    func testBubbleDownVote() {
        let expect = expectation(description: "Bubble Vote")
        
        var bubble1 = ["text": "WOW"] as [String : Any]
        let bubbleCoordinate1 = (latitude: 43.934857, longitude: 24.029348)
        
        Auth.auth().signIn(withEmail: "tester@example.com", password: "123456") { (user, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else if let user = user {
                bubble1["owner"] = user.uid
                DataService.instance.createBubble(bubbleData: bubble1, latitude: bubbleCoordinate1.latitude, longitude: bubbleCoordinate1.longitude, success: { (bubble) in
                    DataService.instance.unvoteBubble(bubble: bubble, uid: user.uid, success: { (newValue) in
                        expect.fulfill()
                    }, failure: { (error) in
                        XCTFail(error.localizedDescription)
                    })
                }, failure: { (error) in
                    XCTFail(error.localizedDescription)
                })
                
            }
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    
}
