
import UIKit

final class MainViewController: UIViewController {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let settingsLabel = UILabel()
    private let enableButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }

    private func setupInterface() {
        view.backgroundColor = UIColor(
            red: 0.055,
            green: 0.065,
            blue: 0.09,
            alpha: 1
        )

        titleLabel.text = "Zakhrafi"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        descriptionLabel.text = """
        لوحة مفاتيح للرموز والزخارف النصية

        رموز منظمة، بحث سريع، ومفضلة
        """
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        settingsLabel.text = """
        لتفعيل لوحة المفاتيح:
        1. افتح الإعدادات.
        2. عام ← لوحة المفاتيح.
        3. لوحات المفاتيح ← إضافة لوحة مفاتيح جديدة.
        4. اختر Zakhrafi إذا ظهرت بالقائمة.
        """
        settingsLabel.font = .systemFont(ofSize: 15)
        settingsLabel.textColor = .white
        settingsLabel.numberOfLines = 0
        settingsLabel.textAlignment = .natural

        enableButton.setTitle(
            "طريقة تفعيل لوحة المفاتيح",
            for: .normal
        )
        enableButton.titleLabel?.font =
            .systemFont(ofSize: 17, weight: .semibold)
        enableButton.setTitleColor(.white, for: .normal)
        enableButton.backgroundColor = UIColor(
            red: 0.35,
            green: 0.32,
            blue: 0.85,
            alpha: 1
        )
        enableButton.layer.cornerRadius = 14
        enableButton.contentEdgeInsets = UIEdgeInsets(
            top: 15,
            left: 18,
            bottom: 15,
            right: 18
        )
        enableButton.addTarget(
            self,
            action: #selector(showInstructions),
            for: .touchUpInside
        )

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            enableButton,
            settingsLabel
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
        let alert = UIAlertController(
            title: "تفعيل Zakhrafi",
            message: """
            افتح الإعدادات في الآيفون، ثم عام، ثم لوحة المفاتيح، ثم لوحات المفاتيح، وأضف Zakhrafi إذا كانت متاحة.
            """,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "حسنًا", style: .default)
        )

        present(alert, animated: true)
    }
}
