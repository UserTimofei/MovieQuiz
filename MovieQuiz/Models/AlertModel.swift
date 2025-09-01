//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Timofei Kirichenko on 21.08.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
