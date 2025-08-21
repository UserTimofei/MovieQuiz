import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenterProtocol?
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    // MARK: - Lifecycle
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // Проверяет, не обрабатывается ли уже ответ
        guard !isProcessingAnswer else { return }
        // Запоминает ответ 
        isProcessingAnswer = true
        // Отключает кнопки (чтобы нельзя было нажать дважды)
        disableButtons()
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        // Сравнивается с правильным ответом и вызывается showAnswerResult(...)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard !isProcessingAnswer else { return }
        isProcessingAnswer = true
        disableButtons()
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 2
        
        // Создаем Фабрику вопросов QuestionFactory
        let questionFactory = QuestionFactory()
        // Говорим: Ты, фабрика - я твой делегат. Когда вопрос будет - скажи мне.
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        // Создаем призентер - он будет готовить текст результата
        self.presenter = MovieQuizPresenter(questionsAmount: questionsAmount, correctAnswersClosure: {[weak self] in self?.correctAnswers ?? 0
            }
        )
        // Запрашиваем первый вопрос - это как "Старт! Давай первый вопрос!"
        self.questionFactory?.requestNextQuestion()
    }
    
    private var isProcessingAnswer = false
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private func enableButton() {
        yesButton.isEnabled = true
        yesButton.alpha = 1.0
        
        noButton.isEnabled = true
        noButton.alpha = 1.0
    }
    
    private func disableButtons() {
        yesButton.alpha = 0.5
        noButton.alpha = 0.5
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
// MARK: - QuestionFactoryDelegate
    // Приходит вопрос
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // QuestionFactory нашел вопрос и сообщил делегату
        // Проверил: вопрос не nil
        guard let question = question else { return }
        // Сохранил его как currentQuestion
        currentQuestion = question
        // Преобразовал в QuizStepViewModel (модель для отображения)
        let viewModel = convert(model: question)
        // В главном потоке показал вопрос на экране
        // DispatchQueue.main.async - потому что вопрос мог прийти из фона (например из сети)
        DispatchQueue.main.async {
            [weak self] in self?.show(quiz: viewModel)
        }
    }
    
    
// MARK: - Private functions
    // Преобразование данных
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // Берет сырой вопрос (QuizQuestion) - строка с именем изображения
        // Создает QuizStepViewModel - готовый у показу объект:
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage (),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    // Показ вопроса
    private func show(quiz step: QuizStepViewModel) {
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
    // Показ результата
    private func showAnswerResult(isCorrect: Bool) {
        // Если ответ верный — увеличивает счётчик
        if isCorrect {
            correctAnswers += 1
        }
        // Устанавливаем рамку
        imageView.layer.masksToBounds = true
        // Определяем ее толщину
        imageView.layer.borderWidth = 8
        // Показывает зелёную рамку (верно) или красную (неверно)
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        // Через 1 секунду:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // 1. Переходит к следующему вопросу или результату
            self.showNextQuestionOrResults()
            // 2. Включает кнопки
            self.enableButton()
            // 3. Снимает флаг обработка
            self.isProcessingAnswer = false
        }
    }
    // Переход к следующему
    private func showNextQuestionOrResults() {
        // Увеличивает индекс
        currentQuestionIndex += 1
        // Если уже 10 вопросов — показывает результат
        // Если ещё нет — запрашивает следующий вопрос у QuestionFactory
        if currentQuestionIndex >= questionsAmount {
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            show(result: viewModel)
        } else {
            questionFactory?.requestNextQuestion()
        }
        // Вопрос приходит через делегат -> цикл повторяется
    }
    
    // Метод отвечает за отоборажения алерта с результатами после прохождения всех вопросов
        private func show(result: QuizResultsViewModel) {
            // Берёт текст результата у presenter
            let message = presenter?.makeResultsMessage() ?? "Игра окончена"
            // Создаёт модель алерта: что показать
            // В замыкании — что делать при нажатии кнопки
            let model = AlertModel(title: result.title,
                                   message: message,
                                   buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                
                self.presenter = MovieQuizPresenter(questionsAmount: self.questionsAmount, correctAnswersClosure: {[weak self] in self?.correctAnswers ?? 0 }) ///Это значит:
               /// "Когда нужно узнать количество правильных ответов — спроси у контроллера"
                self.presenter?.restartGame()
                
                let newFactory = QuestionFactory()
                newFactory.delegate = self
                self.questionFactory = newFactory
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.isProcessingAnswer = false
                self.enableButton()
                
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter.show(in: self, model: model)
        }
}
/// viewDidLoad — точка входа. Здесь всё начинается
/// didReceiveNextQuestion — сердце приёма данных
/// convert → show — путь от данных к экрану
/// showAnswerResult — визуальный фидбэк
/// show(result:) — конец и перезапуск
/// Презентер — не UI, а подготовка данных
/// Делегат — это не вы, а договор: "Сделай и скажи мне"
