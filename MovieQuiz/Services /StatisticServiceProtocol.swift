//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 26.08.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    
    func store(correct count: Int, total amount: Int)
}
