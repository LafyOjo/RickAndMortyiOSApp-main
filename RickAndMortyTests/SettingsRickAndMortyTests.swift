//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Isaiah Ojo on 29/05/2023.
//

import XCTest
@testable import RickAndMorty

class RMSettingsViewControllerTests: XCTestCase {
    var sut: RMSettingsViewController!
    
    override func setUp() {
        super.setUp()
        sut = RMSettingsViewController()
        // Load the view hierarchy into memory
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
        XCTAssertEqual(sut.title, "Settings")
        XCTAssertNotNil(sut.settingsSwiftUIController)
    }

    func testViewDidLoad_SetsSettingsSwiftUIControllerParent() {
        XCTAssertEqual(sut.settingsSwiftUIController?.parent, sut)
    }

    func testViewDidLoad_SetsSettingsSwiftUIControllerViewConstraints() {
        let constraints = sut.view.constraints
        let settingsSwiftUIControllerView = sut.settingsSwiftUIController?.view
        XCTAssertTrue(constraints.contains { $0.firstItem as? UIView == settingsSwiftUIControllerView })
    }
}
