//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 20.08.2025.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
