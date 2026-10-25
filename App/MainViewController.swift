
import UIKit

final class MainViewController: UIViewController {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusLabel = UILabel()
    private let settingsButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }

    private func setupInterface() {
        view.backgroundColor = UIColor(
            red: 0.055,
            green: 0.063,
            blue: 0.10,
            alpha: 1
        )

        titleLabel.text = "Zakhrafi"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        descriptionLabel.text = "رموزك وزخارفك في مكان واحد"
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.textAlignment = .center

        statusLabel.text = "لوحة المفاتيح قيد الإعداد"
        statusLabel.font = .systemFont(ofSize: 15, weight: .medium)
        statusLabel.textColor = UIColor(
            red: 0.55,
            green: 0.78,
            blue: 1,
            alpha: 1
        )
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0

        settingsButton.setTitle(
            "طريقة تفعيل لوحة المفاتيح",
            for: .normal
        )
        settingsButton.titleLabel?.font =
            .systemFont(ofSize: 17, weight: .semibold)
        settingsButton.backgroundColor = UIColor(
            red: 0.30,
            green: 0.32,
            blue: 0.90,
            alpha: 1
        )
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.layer.cornerRadius = 14
        settingsButton.contentEdgeInsets = UIEdgeInsets(
            top: 16,
            left: 20,
            bottom: 16,
            right: 20
        )
        settingsButton.addTarget(
            self,
            action: #selector(showInstructions),
            for: .touchUpInside
        )

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            statusLabel,
            settingsButton
        ])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),
            stack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            stack.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    @objc private func showInstructions() {
        let message = """
        بعد اكتمال بناء التطبيق وتثبيته:

        ١. افتح الإعدادات.
        ٢. ادخل إلى عام.
        ٣. افتح لوحة المفاتيح.
        ٤. اختر لوحات المفاتيح ثم إضافة لوحة مفاتيح جديدة.
        ٥. اختر Zakhrafi إذا ظهرت في القائمة.
        """

        let alert = UIAlertController(
            title: "تفعيل Zakhrafi",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "حسنًا", style: .default)
        )

        present(alert, animated: true)
    }
}
