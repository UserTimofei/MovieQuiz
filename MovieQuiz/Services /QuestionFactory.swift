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
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
            self.moviesLoader = moviesLoader
            self.delegate = delegate
        }
    // Чтобы сообщить контроллеру: "Вопрос готов!" (получать вопроса главный контройлер)
//    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    // Список всех вопросов (жёстко задан)
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(image: "The Godfather", text: "Рейтинг этого //фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Dark Knight", text: "Рейтинг //этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого //фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Avengers", text: "Рейтинг этого //фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Deadpool", text: "Рейтинг этого //фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Green Knight", text: "Рейтинг //этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Old", text: "Рейтинг этого фильма //больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", //text: "Рейтинг этого фильма больше чем 6?", //correctAnswer: false),
//        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма //больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "Vivarium", text: "Рейтинг этого //фильма больше чем 6?", correctAnswer: false)
//    ]
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }  
    // Метод, который вызывает контроллер: "Дай следующий вопрос"
    func requestNextQuestion() {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            if self.movies.isEmpty {
                self.loadData()
                return
            }
            guard !self.movies.isEmpty else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: NSError(
                    domain: "QuestionFactory",
                    code: 1001,
                    userInfo: [NSLocalizedDescriptionKey: "Список фильмов пуст"]
                    ))
                }
                return
            }
            
            
            
            
            
            guard let index = (0..<self.movies.count).randomElement(),
                    let movie = self.movies[safe: index] else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: NSError(domain: "QuestionFactory",
                                                                    code: 1002,
                                                                   userInfo: [NSLocalizedDescriptionKey: "Не удалось выбрать случайный фильм"]
                                                                   ))
                }
                return
            }
            
            var imageData = Data()
           
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
                    } catch {
                DispatchQueue.main.async { [weak self] in
                    print("Ошибка загрузки изображения: \(error)")
                    self?.delegate?.didFailToLoadData(with: error)
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
