//
//  FavoritesRickAndMortyTest.swift
//  RickAndMortyTests
//
//  Created by Isaiah Ojo on 29/05/2023.
//

import XCTest
@testable import RickAndMorty

class FavoritesTableViewControllerTests: XCTestCase {
    var sut: FavoritesTableViewController!
    var mockTableView: MockTableView!
    
    override func setUp() {
        super.setUp()
        sut = FavoritesTableViewController()
        mockTableView = MockTableView()
        sut.tableView = mockTableView
    }

    override func tearDown() {
        sut = nil
        mockTableView = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        sut.viewDidLoad()
        XCTAssertTrue(sut.tableView.dataSource is FavoritesTableViewController)
        XCTAssertTrue(sut.tableView.delegate is FavoritesTableViewController)
        XCTAssertNotNil(sut.fetchedResultsController)
    }

    func testNumberOfSections() {
        let sections = sut.numberOfSections(in: mockTableView)
        XCTAssertEqual(sections, sut.fetchedResultsController.sections?.count ?? 0)
    }

    func testNumberOfRowsInSection() {
        let rows = sut.tableView(mockTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, sut.fetchedResultsController.sections?[0].numberOfObjects ?? 0)
    }

    func testCellForRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(mockTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell is FavoritesTableViewCell)
    }
}

class MockTableView: UITableView {
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return FavoritesTableViewCell()
    }
}
