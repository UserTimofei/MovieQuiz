//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 19.08.2025.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    // Класс поставщик вопросов
    // Он только хранит вопросы и выдаёт следующий по запросу
    
    // Чтобы сообщить контроллеру: "Вопрос готов!"
    weak var delegate: QuestionFactoryDelegate?
    
    // Список всех вопросов (жёстко задан)
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    // Метод, который вызывает контроллер: "Дай следующий вопрос"
    func requestNextQuestion() {
        /// Проверяем, есть ли вообще вопросы:
        /// 1. Берём случайный индекс от 0 до 9
        /// 2. Если список пуст — отправляем nil через делегат
        /// 3. В вашем случае список не пустой, поэтому это вряд ли сработает
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        /// safe: — это безопасный доступ (предположительно, расширение Array)
        /// Защита от index out of range (от выхода за пределы диапазона индексов)
        let question = questions[safe: index]
        /// Сообщаем делегату
        delegate?.didReceiveNextQuestion(question: question)
        ///Это связь с контроллером.
        ///"Эй, MovieQuizViewController, держи вопрос!"
    }
    
}
