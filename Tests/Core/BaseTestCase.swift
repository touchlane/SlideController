import SlideController
import XCTest

class BaseTestCase: XCTestCase {
    var slideController: SlideController<TestTitleScrollView, TestTitleItem>!

    override func setUp() {
        super.setUp()
        slideController = SlideController(
            pagesContent: [],
            startPageIndex: 0,
            slideDirection: SlideDirection.horizontal)

        slideController.viewDidAppear()
    }

    override func tearDown() {
        super.tearDown()
        slideController = nil
    }
}
