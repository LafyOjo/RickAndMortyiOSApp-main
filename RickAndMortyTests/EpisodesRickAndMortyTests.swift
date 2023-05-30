//
//  EpisodesRickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Isaiah Ojo on 30/05/2023.
//

import XCTest
@testable import RickAndMorty

class RMEpisodeViewControllerTests: XCTestCase {
    var sut: RMEpisodeViewController!
    
    override func setUp() {
        super.setUp()
        sut = RMEpisodeViewController()
        // Load the view hierarchy into memory
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
        XCTAssertEqual(sut.title, "Episodes")
        XCTAssertNotNil(sut.episodeListView)
    }

    func testViewDidLoad_SetsEpisodeListViewConstraints() {
        let constraints = sut.view.constraints
        XCTAssertTrue(constraints.contains { $0.firstItem as? UIView == sut.episodeListView })
    }

    func testViewDidLoad_SetsEpisodeListViewDelegate() {
        XCTAssertEqual(sut.episodeListView.delegate as? RMEpisodeViewController, sut)
    }
    
    func testAddSearchButton() {
        sut.addSearchButton()
        let rightBarButtonItem = sut.navigationItem.rightBarButtonItem
        XCTAssertNotNil(rightBarButtonItem)
        XCTAssertEqual(rightBarButtonItem?.action, #selector(sut.didTapSearch))
        XCTAssertEqual(rightBarButtonItem?.target as? RMEpisodeViewController, sut)
    }
}
