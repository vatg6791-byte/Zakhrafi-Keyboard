
import UIKit

final class KeyboardViewController: UIInputViewController {

    private let backgroundColor = UIColor(
        red: 0.055,
        green: 0.063,
        blue: 0.10,
        alpha: 1
    )

    private let accentColor = UIColor(
        red: 0.85,
        green: 0.73,
        blue: 0.34,
        alpha: 1
    )

    private let symbols = [
        "⌌", "⌍", "⌎", "⌏", "⌜", "⌝", "⌞", "⌟",
        "─", "━", "│", "┃", "┄", "┅", "┈", "┉",
        "╭", "╮", "╰", "╯", "╔", "╗", "╚", "╝",
        "◇", "◆", "○", "●", "□", "■", "△", "▲",
        "✦", "✧", "✩", "✪", "✿", "❀", "❖", "⋆",
        "♡", "♥", "❥", "❦", "❧", "ღ", "ෆ", "ꨄ",
        "←", "↑", "→", "↓", "↔", "↕", "↗", "↘",
        "⌘", "⌥", "⇧", "⌃", "⎋", "⌫", "⌦", "⏎",
        "∞", "≠", "≈", "≤", "≥", "±", "×", "÷",
        "༺", "༻", "༼", "༽", "࿐", "༒", "۞", "۩"
    ]

    private let categoryNames = [
        "الكل",
        "إطارات",
        "خطوط",
        "أشكال",
        "زخارف",
        "قلوب",
        "أسهم",
        "تقنية",
        "رياضيات",
        "عربية"
    ]

    private var selectedCategory = 0
    private var searchText = ""

    private let categoryScroll = UIScrollView()
    private let categoryStack = UIStackView()
    private let symbolScroll = UIScrollView()
    private let symbolGrid = UIStackView()
    private let searchField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setupCategories()
        setupSearch()
        setupSymbolArea()
        renderSymbols()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = CGSize(width: 0, height: 310)
    }

    private func setupKeyboard() {
        view.backgroundColor = backgroundColor
        view.heightAnchor.constraint(
            equalToConstant: 310
        ).isActive = true
    }

    private func setupCategories() {
        categoryScroll.showsHorizontalScrollIndicator = false
        categoryStack.axis = .horizontal
        categoryStack.spacing = 8
        categoryStack.translatesAutoresizingMaskIntoConstraints = false

        categoryScroll.addSubview(categoryStack)
        categoryScroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryScroll)

        NSLayoutConstraint.activate([
            categoryScroll.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 8
            ),
            categoryScroll.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 8
            ),
            categoryScroll.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -8
            ),
            categoryScroll.heightAnchor.constraint(equalToConstant: 40),

            categoryStack.topAnchor.constraint(
                equalTo: categoryScroll.contentLayoutGuide.topAnchor
            ),
            categoryStack.bottomAnchor.constraint(
                equalTo: categoryScroll.contentLayoutGuide.bottomAnchor
            ),
            categoryStack.leadingAnchor.constraint(
                equalTo: categoryScroll.contentLayoutGuide.leadingAnchor
            ),
            categoryStack.trailingAnchor.constraint(
                equalTo: categoryScroll.contentLayoutGuide.trailingAnchor
            ),
            categoryStack.heightAnchor.constraint(
                equalTo: categoryScroll.frameLayoutGuide.heightAnchor
            )
        ])

        for (index, name) in categoryNames.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(
                ofSize: 13,
                weight: .medium
            )
            button.backgroundColor = index == 0
                ? accentColor.withAlphaComponent(0.28)
                : UIColor.white.withAlphaComponent(0.07)
            button.layer.cornerRadius = 11
            button.contentEdgeInsets = UIEdgeInsets(
                top: 7,
                left: 12,
                bottom: 7,
                right: 12
            )
            button.tag = index
            button.addTarget(
                self,
                action: #selector(categoryTapped(_:)),
                for: .touchUpInside
            )
            categoryStack.addArrangedSubview(button)
        }
    }

    private func setupSearch() {
        searchField.placeholder = "بحث عن رمز..."
        searchField.textColor = .white
        searchField.tintColor = accentColor
        searchField.backgroundColor = UIColor.white.withAlphaComponent(0.07)
        searchField.layer.cornerRadius = 12
        searchField.font = .systemFont(ofSize: 14)
        searchField.returnKeyType = .search
        searchField.clearButtonMode = .whileEditing
        searchField.autocorrectionType = .no
        searchField.autocapitalizationType = .none
        searchField.delegate = self
        searchField.translatesAutoresizingMaskIntoConstraints = false

        let padding = UIView(
            frame: CGRect(x: 0, y: 0, width: 12, height: 1)
        )
        searchField.leftView = padding
        searchField.leftViewMode = .always

        view.addSubview(searchField)

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(
                equalTo: categoryScroll.bottomAnchor,
                constant: 8
            ),
            searchField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
            searchField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            ),
            searchField.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    private func setupSymbolArea() {
        symbolScroll.showsVerticalScrollIndicator = true
        symbolScroll.translatesAutoresizingMaskIntoConstraints = false

        symbolGrid.axis = .vertical
        symbolGrid.spacing = 8
        symbolGrid.translatesAutoresizingMaskIntoConstraints = false

        symbolScroll.addSubview(symbolGrid)
        view.addSubview(symbolScroll)

        NSLayoutConstraint.activate([
            symbolScroll.topAnchor.constraint(
                equalTo: searchField.bottomAnchor,
                constant: 8
            ),
            symbolScroll.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 8
            ),
            symbolScroll.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -8
            ),
            symbolScroll.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -8
            ),

            symbolGrid.topAnchor.constraint(
                equalTo: symbolScroll.contentLayoutGuide.topAnchor
            ),
            symbolGrid.bottomAnchor.constraint(
                equalTo: symbolScroll.contentLayoutGuide.bottomAnchor
            ),
            symbolGrid.leadingAnchor.constraint(
                equalTo: symbolScroll.contentLayoutGuide.leadingAnchor
            ),
            symbolGrid.trailingAnchor.constraint(
                equalTo: symbolScroll.contentLayoutGuide.trailingAnchor
            ),
            symbolGrid.widthAnchor.constraint(
                equalTo: symbolScroll.frameLayoutGuide.widthAnchor
            )
        ])
    }

    @objc private func categoryTapped(_ sender: UIButton) {
        selectedCategory = sender.tag

        for case let button as UIButton in categoryStack.arrangedSubviews {
            button.backgroundColor = button.tag == selectedCategory
                ? accentColor.withAlphaComponent(0.28)
                : UIColor.white.withAlphaComponent(0.07)
        }

        renderSymbols()
    }

    private func renderSymbols() {
        symbolGrid.arrangedSubviews.forEach { row in
            symbolGrid.removeArrangedSubview(row)
            row.removeFromSuperview()
        }

        let filtered = symbols.filter { symbol in
            let matchesSearch = searchText.isEmpty ||
                symbol.localizedCaseInsensitiveContains(searchText)

            return matchesSearch &&
                matchesSelectedCategory(symbol)
        }

        let columns = 8

        for start in stride(
            from: 0,
            to: filtered.count,
            by: columns
        ) {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 6

            let end = min(start + columns, filtered.count)

            for index in start..<end {
                let symbol = filtered[index]
                let button = UIButton(type: .system)

                button.setTitle(symbol, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 23)
                button.backgroundColor =
                    UIColor.white.withAlphaComponent(0.07)
                button.layer.cornerRadius = 10
                button.addAction(
                    UIAction { [weak self] _ in
                        self?.textDocumentProxy.insertText(symbol)
                    },
                    for: .touchUpInside
                )

                row.addArrangedSubview(button)
            }

            while row.arrangedSubviews.count < columns {
                let spacer = UIView()
                spacer.backgroundColor = .clear
                row.addArrangedSubview(spacer)
            }

            row.heightAnchor.constraint(equalToConstant: 42).isActive = true
            symbolGrid.addArrangedSubview(row)
        }
    }

    private func matchesSelectedCategory(_ symbol: String) -> Bool {
        switch selectedCategory {
        case 1:
            return "⌌⌍⌎⌏⌜⌝⌞⌟╭╮╰╯╔╗╚╝".contains(symbol)
        case 2:
            return "─━│┃┄┅┈┉".contains(symbol)
        case 3:
            return "◇◆○●□■△▲".contains(symbol)
        case 4:
            return "✦✧✩✪✿❀❖⋆".contains(symbol)
        case 5:
            return "♡♥❥❦❧ღෆꨄ".contains(symbol)
        case 6:
            return "←↑→↓↔↕↗↘".contains(symbol)
        case 7:
            return "⌘⌥⇧⌃⎋⌫⌦⏎".contains(symbol)
        case 8:
            return "∞≠≈≤≥±×÷".contains(symbol)
        case 9:
            return "༺༻༼༽࿐༒۞۩".contains(symbol)
        default:
            return true
        }
    }
}

extension KeyboardViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let current = textField.text ?? ""
        guard let swiftRange = Range(range, in: current) else {
            return false
        }

        searchText = current.replacingCharacters(
            in: swiftRange,
            with: string
        )

        DispatchQueue.main.async { [weak self] in
            self?.renderSymbols()
        }

        return true
    }
}
