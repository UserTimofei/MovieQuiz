//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 21.08.2025.
//

import Foundation

final class MovieQuizPresenter: MovieQuizPresenterProtocol {
   /// Подготовитель данных для отображения
   /// Он не показывает алерт, не знает про кнопки
   /// Он только готовит текст результата
    
    // Сколько всего вопросов
    private let questionsAmount: Int
    // Замыкание: "Спроси у контроллера, сколько правильных ответов"
    private let correctAnswersClosure: () -> Int
    
    private let restartGameHandler: () -> Void
    init(questionsAmount: Int, correctAnswersClosure: @escaping () -> Int, restartGameHandler: @escaping () -> Void) {
        self.questionsAmount = questionsAmount
        self.correctAnswersClosure = correctAnswersClosure
        self.restartGameHandler = restartGameHandler
    }

    // Готовит строку: "Ваш результат: 7/10"
    func makeResultsMessage() -> String {
        let correсt = correctAnswersClosure()
        return "Ваш результат: \(correсt)/\(questionsAmount)"
    }
    func restartGame() {
        restartGameHandler()
    }
}
