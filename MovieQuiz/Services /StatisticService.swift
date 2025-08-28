//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 26.08.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    var totalAccuracy: Double {
        guard totalQuestionAsked > 0 else { return 0.0 }
        return ( Double(totalCorrectAnswer) / Double(totalQuestionAsked)) * 100.0
    }
    
    private var storage = UserDefaults.standard
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
    var gamesCount: Int {
        get { return storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameResult {
        get {
            let correсt = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correсt, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    private var totalCorrectAnswer: Int {
        get { storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue) }
    }
    
    private var totalQuestionAsked: Int {
        get { storage.integer(forKey: Keys.totalQuestionsAsked.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue) }
    }
    
    
    func store(correct count: Int, total amount: Int) {
        totalQuestionAsked += amount
        totalCorrectAnswer += count
        gamesCount += 1        
        if bestGame.total == 0 {
            bestGame = GameResult(correct: count, total: amount, date: Date())
        } else {
            let newAnswer = (Double(count) / Double(amount))
            let currentBestGame = (Double(bestGame.correct) / Double(bestGame.total))
            if newAnswer > currentBestGame || (newAnswer == currentBestGame && count > bestGame.correct) {
                bestGame = GameResult(correct: count, total: amount, date: Date())
            }
        }
    }
}
