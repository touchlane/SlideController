import UIKit
import XCTest
import SlideController

class Tests: XCTestCase {
    
    private var slideController: SlideController<HorizontalTitleScrollView, HorizontalTitleItem>!
    
    override func setUp() {
        super.setUp()
        slideController = SlideController(
            pagesContent: [],
            startPageIndex: 0,
            slideDirection: SlideDirection.horizontal)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAppended() {
        let page1 = SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        let page2 = SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        let page3 = SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)

        let contentCount = slideController.content.count
        let currentIndex = slideController.content.index(where: {
            $0 === slideController.currentModel
        })
        
        XCTAssertEqual(contentCount, givenContent.count)
        XCTAssertEqual(currentIndex, 0)
    }
}
