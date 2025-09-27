
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var showQuizCalled = false
    var lastQuiz: QuizStepViewModel?
    
    var showResultCalled = false
    var lastResult: QuizResultsViewModel?
    
    var highlightImageBorderCalled = false
    var lastIsCorrect: Bool?
    
    var showLoadingIndicatorCalled = false
    var hideLoadingIndicatorCalled = false
    var showNetworkErrorCalled = false
    var lastErrorMessage: String?
    
    var enableButtonCalled = false
    var disableButtonsCalled = false
    
    func show(quiz step: QuizStepViewModel) {
        showQuizCalled = true
        lastQuiz = step
    }
    
    func show(result: QuizResultsViewModel) {
        showResultCalled = true
        lastResult = result
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        highlightImageBorderCalled = true
        lastIsCorrect = isCorrectAnswer
    }
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func showNetworkError(message: String) {
        showNetworkErrorCalled = true
        lastErrorMessage = message
    }
    
    func enableButton() {
        enableButtonCalled = true
    }
    
    func disableButtons() {
        disableButtonsCalled = true
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenterNotView(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
         XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
