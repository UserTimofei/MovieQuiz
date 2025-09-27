import UIKit
import Foundation
final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol!
    
    private var presenterConvert: MovieQuizPresenterNotView!
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAccessibilityIdentifiers()
        setupDependencies()
        
    }
    
    private func setupDependencies() {
        statisticService = StatisticService()
        
        // Создаём основной презентер
        presenterConvert = MovieQuizPresenterNotView(
            viewController: self)
        imageView.layer.cornerRadius = 20
    }
    
    private func setupUI() {
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 2
        imageView.layer.cornerRadius = 20
       
    }
    
    private func setupAccessibilityIdentifiers() {
        yesButton.accessibilityIdentifier = "YesButton"
        noButton.accessibilityIdentifier = "NoButton"
        imageView.accessibilityIdentifier = "PosterImage"
        indexLabel.accessibilityIdentifier = "IndexLabel"
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenterConvert.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenterConvert.noButtonClicked()
    }
    
    func show(result: QuizResultsViewModel) {
        
        let message = presenterConvert.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenterConvert.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
   
    func enableButton() {
        yesButton.isEnabled = true
        yesButton.alpha = 1.0
        
        noButton.isEnabled = true
        noButton.alpha = 1.0
    }
    
    func disableButtons() {
        yesButton.alpha = 0.5
        noButton.alpha = 0.5
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            guard let self = self else { return}
            
            self.presenterConvert?.restartGame()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    func show(quiz step: QuizStepViewModel) {
        
        print("🖼 Размер изображения: \(step.image.size)")
        print("🔢 Отображаемый счётчик: \(step.questionNumber)")
        
        imageView.image = nil
        // Устанавливает изображение
        imageView.image = step.image
        // Устанавливает текст
        questionLabel.text = step.question
        // Устанавливает счетчик
        indexLabel.text = step.questionNumber
        // Убирает рамку (на случай, если был предыдущий ответ)
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}
