//
//  LocationsRickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Isaiah Ojo on 29/05/2023.
//

import XCTest
@testable import RickAndMorty

class RMLocationViewControllerTests: XCTestCase {
    var sut: RMLocationViewController!
    
    override func setUp() {
        super.setUp()
        sut = RMLocationViewController()
        // Load the view hierarchy into memory
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
        XCTAssertEqual(sut.title, "Locations")
        XCTAssertNotNil(sut.primaryView)
    }

    func testViewDidLoad_SetsPrimaryViewConstraints() {
        let constraints = sut.view.constraints
        XCTAssertTrue(constraints.contains { $0.firstItem as? UIView == sut.primaryView })
    }

    func testViewDidLoad_SetsPrimaryViewDelegate() {
        XCTAssertEqual(sut.primaryView.delegate as? RMLocationViewController, sut)
    }

    func testViewDidLoad_SetsViewModelDelegate() {
        XCTAssertEqual(sut.viewModel.delegate as? RMLocationViewController, sut)
    }
}
