//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 21.08.2025.
//

import UIKit

final class AlertPresenter {
    /// Принимает два параметра:
    /// vc — контроллер, в котором нужно показать алерт
    /// model — данные: что написать, какая кнопка, что делать при нажатии
    func show(in vc: UIViewController, model: AlertModel) {
        // Создаёт алерт: берёт заголовок, текст и стиль из model.
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        // Создаёт кнопку: текст кнопки — из model.buttonText
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            // При нажатии — вызывается model.completion() — замыкание, которое вы передали
            model.completion()
        }
        // Добавляет кнопку в алерт
        alert.addAction(action)
        /// Показывает алерт: показывает алерт в переданном контроллере, с анимацией
        vc.present(alert, animated: true, completion: nil)
    }
    
}
