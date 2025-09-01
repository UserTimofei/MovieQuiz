//
//  MovieQuizPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 21.08.2025.
//

import Foundation

protocol MovieQuizPresenterProtocol {
    func makeResultsMessage() -> String
    func restartGame()
}
