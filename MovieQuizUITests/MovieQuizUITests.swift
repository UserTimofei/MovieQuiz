
import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    private func waitFor(_ element: XCUIElement, timeout: TimeInterval = 10) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "Element not found")
    }
    
    func testYesButton() {
        waitFor(app.buttons["YesButton"])
        
        let firstPoster = app.images["PosterImage"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["YesButton"].tap()
        
        waitFor(app.staticTexts["IndexLabel"])
        let secondPoster = app.images["PosterImage"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["IndexLabel"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        waitFor(app.buttons["NoButton"])
        
        let firstPoster = app.images["PosterImage"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["NoButton"].tap()
        
        waitFor(app.staticTexts["IndexLabel"])
        let secondPoster = app.images["PosterImage"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["IndexLabel"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testGameFinish() {
        waitFor(app.buttons["NoButton"])
        for i in 1...10 {
            app.buttons["NoButton"].tap()
            
            if i < 10 {
                            waitFor(app.staticTexts["\(i + 1)/10"]) // ← ждём конкретный счётчик
                        }
            
            waitFor(app.staticTexts["IndexLabel"])
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        waitFor(app.buttons["NoButton"])
        
        for i in 1...10 {
            app.buttons["NoButton"].tap()
//            if i < 10 {
//                waitFor(app.staticTexts["IndexLabel"])
//            }
            if i < 10 {
                            waitFor(app.staticTexts["\(i + 1)/10"])
                        }
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["Сыграть ещё раз"].tap()
        
//        sleep(2)
        
//        let indexLabel = app.staticTexts["Index"]
        waitFor(app.staticTexts["1/10"])
//        waitFor(app.staticTexts["IndexLabel"])
//        XCTAssertEqual(app.staticTexts["IndexLabel"].label, "1/10")
    }
    
}
