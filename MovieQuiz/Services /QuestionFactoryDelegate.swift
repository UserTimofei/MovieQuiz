//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 20.08.2025.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    // Метод получил следующий вопрос
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
