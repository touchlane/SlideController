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
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        slideController.viewDidAppear()
        
        
        let contentCount = slideController.content.count
        let currentIndex = slideController.content.index(where: {
            $0 === slideController.currentModel
        })
        
        XCTAssertEqual(contentCount, givenContent.count)
        XCTAssertEqual(currentIndex, 0)
    }
    
    func testAppendedLifeCycle() {
        let utils = TestLifeCycleObjectUtils()
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page4 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3, page4]
        slideController.append(object: givenContent)
        slideController.viewDidAppear()
        
        guard let currentPage = slideController.currentModel?.lifeCycleObject as? TestableLifeCycleObject,
            let secondPage = page2.lifeCycleObject as? TestableLifeCycleObject,
            let thirdPage = page3.lifeCycleObject as? TestableLifeCycleObject,
            let fourthPage = page4.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        utils.assertPresentedLifeCycleObject(object: currentPage, wasSlided: false)
        utils.assertOutsideScreenLifeCycleObject(object: secondPage, shouldBeLoad: true)
        utils.assertOutsideScreenLifeCycleObject(object: thirdPage, shouldBeLoad: false)
        utils.assertOutsideScreenLifeCycleObject(object: fourthPage, shouldBeLoad: false)
    }
}
