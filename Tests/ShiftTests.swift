import UIKit
import XCTest
import SlideController

class ShiftTests: BaseTestCase {
    func testContentShift() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.shift(pageIndex: 1, animated: false)
        
        let contentCount = slideController.content.count
        let currentIndex = slideController.content.index(where: { $0 === slideController.currentModel })
        
        XCTAssertEqual(contentCount, givenContent.count)
        XCTAssertEqual(currentIndex, 1)
    }
    
    func testShiftAtCurrent() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.shift(pageIndex: 0, animated: false)
        
        let currentIndex = slideController.content.index(where: { $0 === slideController.currentModel })
        XCTAssertEqual(currentIndex, 0)
    }
    
    func testShiftAtLast() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.shift(pageIndex: givenContent.count - 1, animated: true)
        
        let currentIndex = slideController.content.index(where: { $0 === slideController.currentModel })
        XCTAssertEqual(currentIndex, givenContent.count - 1)
    }
    
    func testShiftedAtCurrentLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        slideController.shift(pageIndex: 0, animated: false)
        
        guard let currentPage = slideController.currentModel?.lifeCycleObject as? TestableLifeCycleObject else {
            XCTFail("page is not TestableLifeCycleObject")
            return
        }
        
        XCTAssert(currentPage.didAppearTriggered)
        XCTAssert(!currentPage.didDissapearTriggered)
        XCTAssert(currentPage.viewDidLoadTriggered)
        XCTAssert(!currentPage.viewDidUnloadTriggered)
        XCTAssert(!currentPage.didStartSlidingTriggered)
        XCTAssert(!currentPage.didCancelSlidingTriggered)
    }
    
    func testShiftedAtSecond() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        slideController.shift(pageIndex: 1)
        
        guard let object1 = page1.lifeCycleObject as? TestableLifeCycleObject,
            let object2 = page2.lifeCycleObject as? TestableLifeCycleObject,
            let object3 = page3.lifeCycleObject as? TestableLifeCycleObject else {
                XCTFail("page is not TestableLifeCycleObject")
                return
        }
        
        XCTAssert(object1.viewDidLoadTriggered)
        XCTAssert(object1.didDissapearTriggered)
        
        XCTAssert(object2.viewDidLoadTriggered)
        XCTAssert(object2.didAppearTriggered)
        
        XCTAssert(object3.viewDidLoadTriggered)
    }
    
    func testShiftedAtFarLifeCycle() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        
        self.slideController.shift(pageIndex: 2, animated: false)
        
        guard let finishPage = page3.lifeCycleObject as? TestableLifeCycleObject,
            let middlePage = page2.lifeCycleObject as? TestableLifeCycleObject,
            let initialPage = page1.lifeCycleObject as? TestableLifeCycleObject else {
                XCTFail("page is not TestableLifeCycleObject")
                return
        }
        
        XCTAssert(initialPage.didAppearTriggered)
        XCTAssert(initialPage.didDissapearTriggered)
        XCTAssert(initialPage.viewDidLoadTriggered)
        XCTAssert(initialPage.viewDidUnloadTriggered)
        
        XCTAssert(!middlePage.didAppearTriggered)
        XCTAssert(!middlePage.didDissapearTriggered)
        XCTAssert(middlePage.viewDidLoadTriggered)
        XCTAssert(!middlePage.viewDidUnloadTriggered)
        XCTAssert(!middlePage.didStartSlidingTriggered)
        XCTAssert(!middlePage.didCancelSlidingTriggered)
        
        XCTAssert(finishPage.didAppearTriggered)
        XCTAssert(!finishPage.didDissapearTriggered)
        XCTAssert(finishPage.viewDidLoadTriggered)
        XCTAssert(!finishPage.viewDidUnloadTriggered)
    }
    
    func testShowNext() {
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        slideController.showNext()
        
        let currentIndex = slideController.content.index(where: { $0 === slideController.currentModel })
        XCTAssertEqual(currentIndex, 1)
    }
    
    func testShowNextCarousel() {
        slideController.isCarousel = true
        let page1 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page2 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let page3 = SlideLifeCycleObjectBuilder<TestableLifeCycleObject>(object: TestableLifeCycleObject())
        let givenContent = [page1, page2, page3]
        slideController.append(object: givenContent)
        slideController.shift(pageIndex: 2)
        slideController.showNext()
        
        let currentIndex = slideController.content.index(where: { $0 === slideController.currentModel })
        XCTAssertEqual(currentIndex, 0)
    }
}
