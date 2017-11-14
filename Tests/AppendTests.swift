import UIKit
import XCTest
import SlideController

class AppendTests: BaseTestCase {
    
    func testAppended() {
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        let contentCount = slideController.content.count
        let currentIndex = slideController.content.index(where: {
            $0 === slideController.currentModel
        })
        
        XCTAssertEqual(contentCount, givenContent.count)
        XCTAssertEqual(currentIndex, 0)
    }
    
    func testAppendedLifeCycle() {
        let page1 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page4 = SlidePageModel<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3, page4]
        slideController.append(object: givenContent)
        
        guard let currentPage = slideController.currentModel?.lifeCycleObject as? TestableLifeCycleObject,
            let secondPage = page2.lifeCycleObject as? TestableLifeCycleObject,
            let thirdPage = page3.lifeCycleObject as? TestableLifeCycleObject,
            let fourthPage = page4.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        /// Presented page
        XCTAssert(currentPage.didAppearTriggered)
        XCTAssert(!currentPage.didDissapearTriggered)
        XCTAssert(currentPage.viewDidLoadTriggered)
        XCTAssert(!currentPage.viewDidUnloadTriggered)
        XCTAssert(!currentPage.didStartSlidingTriggered)
        XCTAssert(!currentPage.didCancelSlidingTriggered)
        
        XCTAssert(!secondPage.didAppearTriggered)
        XCTAssert(!secondPage.didDissapearTriggered)
        XCTAssert(secondPage.viewDidLoadTriggered)
        XCTAssert(!secondPage.viewDidUnloadTriggered)
        XCTAssert(!secondPage.didStartSlidingTriggered)
        XCTAssert(!secondPage.didCancelSlidingTriggered)
        
        XCTAssert(!thirdPage.didAppearTriggered)
        XCTAssert(!thirdPage.didDissapearTriggered)
        XCTAssert(!thirdPage.viewDidLoadTriggered)
        XCTAssert(!thirdPage.viewDidUnloadTriggered)
        XCTAssert(!thirdPage.didStartSlidingTriggered)
        XCTAssert(!thirdPage.didCancelSlidingTriggered)
        
        XCTAssert(!fourthPage.didAppearTriggered)
        XCTAssert(!fourthPage.didDissapearTriggered)
        XCTAssert(!fourthPage.viewDidLoadTriggered)
        XCTAssert(!fourthPage.viewDidUnloadTriggered)
        XCTAssert(!fourthPage.didStartSlidingTriggered)
        XCTAssert(!fourthPage.didCancelSlidingTriggered)
    }
}
