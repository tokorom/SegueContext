//
//  Tests.swift
//
//  Created by ToKoRo on 2016-09-10.
//

import XCTest
import UIKit
import SegueContext

class Tests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPerformSegue() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.performSegue(withIdentifier: "Test", sender: nil)
        }

        XCTAssertTrue(true)
    }

    func testPerformSegueWithCallback() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.performSegue(withIdentifier: "Test", context: 1) { (_: Int) -> Int in
                return 0
            }
        }

        XCTAssertTrue(true)
    }

    func testPresent() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.present(storyboardName: "Test")
        }

        XCTAssertTrue(true)
    }

    func testPresentWithCallback() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.present(storyboardName: "Test", context: 1) { (value: Int) -> Int in
                return 0
            }
        }

        XCTAssertTrue(true)
    }

    func testPresentStoryboard() {
        let vc = UIViewController()

        if let _ = Int("x") {
            let storyboard = UIStoryboard(name: "Test", bundle: nil)
            vc.present(storyboard: storyboard)
        }

        XCTAssertTrue(true)
    }

    func testPresentStoryboardWithCallback() {
        let vc = UIViewController()

        if let _ = Int("x") {
            let storyboard = UIStoryboard(name: "Test", bundle: nil)
            vc.present(storyboard: storyboard, context: 1) { (value: Int) -> Int in
                return 0
            }
        }

        XCTAssertTrue(true)
    }

    func testPresentViewControllerIdentifier() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.present(viewControllerIdentifier: "Test")
        }

        XCTAssertTrue(true)
    }

    func testPresentViewControllerIdentifierWithCallback() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.present(viewControllerIdentifier: "Test", context: 1) { (value: Int) -> Int in
                return 0
            }
        }

        XCTAssertTrue(true)
    }

    func testPush() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.pushViewController(storyboardName: "Test")
        }

        XCTAssertTrue(true)
    }

    func testPushWithCallback() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.pushViewController(storyboardName: "Test", context: 1) { (value: Int) -> Int in
                return 0
            }
        }

        XCTAssertTrue(true)
    }

    func testPushStoryboard() {
        let vc = UIViewController()

        if let _ = Int("x") {
            let storyboard = UIStoryboard(name: "Test", bundle: nil)
            vc.pushViewController(storyboard: storyboard)
        }

        XCTAssertTrue(true)
    }

    func testPushStoryboardWithCallback() {
        let vc = UIViewController()

        if let _ = Int("x") {
            let storyboard = UIStoryboard(name: "Test", bundle: nil)
            vc.pushViewController(storyboard: storyboard, context: 1) { (value: Int) -> Int in
                return 0
            }
        }

        XCTAssertTrue(true)
    }

    func testPushViewControllerIdentifier() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.pushViewController(viewControllerIdentifier: "Test")
        }

        XCTAssertTrue(true)
    }

    func testPushViewControllerIdentifierWithCallback() {
        let vc = UIViewController()

        if let _ = Int("x") {
            vc.pushViewController(viewControllerIdentifier: "Test", context: 1) { (value: Int) -> Int in
                return 0
            }
        }

        XCTAssertTrue(true)
    }
}
