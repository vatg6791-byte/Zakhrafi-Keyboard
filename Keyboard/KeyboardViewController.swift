
import UIKit

private struct SymbolCategory: Decodable {
    let name: String
    let items: [String]
}

final class KeyboardViewController: UIInputViewController,
                                    UITextFieldDelegate {

    private let panelColor = UIColor(
        red: 0.055, green: 0.063, blue: 0.10, alpha: 1
    )

    private let accentColor = UIColor(
        red: 0.85, green: 0.73, blue: 0.34, alpha: 1
    )

    private var categories: [SymbolCategory] = []
    private var selectedCategory: Int? = nil
    private var searchText = ""

    private let categoryScroll = UIScrollView()
    private let categoryStack = UIStackView()
    private let searchField = UITextField()
    private let symbolScroll = UIScrollView()
    private let symbolGrid = UIStackView()
    private let toolbar = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = panelColor

        loadSymbols()
        setupCategories()
        setupSearch()
        setupSymbolGrid()
        setupToolbar()
        renderSymbols()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = CGSize(width: 0, height: 310)
    }

    private func loadSymbols() {
        guard
            let url = Bundle.main.url(
                forResource: "symbols",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(
                [SymbolCategory].self,
                from: data
            )
        else {
            categories = [
                SymbolCategory(
                    name: "زخارف",
                    items: ["⌌", "⌍", "⌜", "⌝", "◇", "◆", "✦", "✧"]
                )
            ]
            return
        }

        categories = decoded
    }

    private func setupCategories() {
        categoryScroll.translatesAutoresizingMaskIntoConstraints = false
        categoryScroll.showsHorizontalScrollIndicator = false

        categoryStack.axis = .horizontal
        categoryStack.spacing = 8
        categoryStack.translatesAutoresizingMaskIntoConstraints = false

        categoryScroll.addSubview(categoryStack)
        view.addSubview(categoryScroll)

        NSLayoutConstraint.activate([
            categoryScroll.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 7
            ),
            categoryScroll.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 8
            ),
            categoryScroll.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -8
            ),
            categoryScroll.heightAnchor.constraint(equalToConstant: 38),

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

        addCategoryButton(title: "الكل", tag: 0)

        for (index, category) in categories.enumerated() {
            addCategoryButton(title: category.name, tag: index + 1)
        }
    }

    private func addCategoryButton(title: String, tag: Int) {
        let button = UIButton(type: .system)
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(
            ofSize: 13,
            weight: .medium
        )
        button.backgroundColor = tag == 0
            ? accentColor.withAlphaComponent(0.3)
            : UIColor.white.withAlphaComponent(0.07)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(
            top: 6, left: 11, bottom: 6, right: 11
        )
        button.addTarget(
            self,
            action: #selector(categoryTapped(_:)),
            for: .touchUpInside
        )

        categoryStack.addArrangedSubview(button)
    }

    private func setupSearch() {
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "بحث عن رمز..."
        searchField.textColor = .white
        searchField.tintColor = accentColor
        searchField.backgroundColor = UIColor.white.withAlphaComponent(0.07)
        searchField.layer.cornerRadius = 11
        searchField.font = .systemFont(ofSize: 14)
        searchField.clearButtonMode = .whileEditing
        searchField.autocorrectionType = .no
        searchField.autocapitalizationType = .none
        searchField.returnKeyType = .search
        searchField.delegate = self

        let padding = UIView(
            frame: CGRect(x: 0, y: 0, width: 12, height: 1)
        )
        searchField.leftView = padding
        searchField.leftViewMode = .always

        view.addSubview(searchField)

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(
                equalTo: categoryScroll.bottomAnchor,
                constant: 7
            ),
            searchField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
            searchField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            ),
            searchField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupSymbolGrid() {
        symbolScroll.translatesAutoresizingMaskIntoConstraints = false
        symbolScroll.showsVerticalScrollIndicator = true

        symbolGrid.axis = .vertical
        symbolGrid.spacing = 6
        symbolGrid.translatesAutoresizingMaskIntoConstraints = false

        symbolScroll.addSubview(symbolGrid)
        view.addSubview(symbolScroll)

        NSLayoutConstraint.activate([
            symbolScroll.topAnchor.constraint(
                equalTo: searchField.bottomAnchor,
                constant: 7
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
                equalTo: toolbar.topAnchor,
                constant: -6
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

    private func setupToolbar() {
        toolbar.axis = .horizontal
        toolbar.distribution = .fillEqually
        toolbar.spacing = 7
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(toolbar)

        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 8
            ),
            toolbar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -8
            ),
            toolbar.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -7
            ),
            toolbar.heightAnchor.constraint(equalToConstant: 39)
        ])

        addToolbarButton(title: "⌫") { [weak self] in
            self?.textDocumentProxy.deleteBackward()
        }

        addToolbarButton(title: "مسافة") { [weak self] in
            self?.textDocumentProxy.insertText(" ")
        }

        addToolbarButton(title: "رجوع") { [weak self] in
            self?.textDocumentProxy.insertText("\n")
        }

        addToolbarButton(title: "🌐") { [weak self] in
            self?.advanceToNextInputMode()
        }
    }

    private func addToolbarButton(
        title: String,
        action: @escaping () -> Void
    ) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(
            ofSize: 15,
            weight: .medium
        )
        button.backgroundColor = UIColor.white.withAlphaComponent(0.09)
        button.layer.cornerRadius = 9
        button.addAction(
            UIAction { _ in action() },
            for: .touchUpInside
        )
        toolbar.addArrangedSubview(button)
    }

    @objc private func categoryTapped(_ sender: UIButton) {
        selectedCategory = sender.tag == 0 ? nil : sender.tag - 1

        for case let button as UIButton in categoryStack.arrangedSubviews {
            let isSelected = button.tag == sender.tag
            button.backgroundColor = isSelected
                ? accentColor.withAlphaComponent(0.3)
                : UIColor.white.withAlphaComponent(0.07)
        }

        renderSymbols()
    }

    private func renderSymbols() {
        for row in symbolGrid.arrangedSubviews {
            symbolGrid.removeArrangedSubview(row)
            row.removeFromSuperview()
        }

        let source: [String]

        if let index = selectedCategory,
           categories.indices.contains(index) {
            source = categories[index].items
        } else {
            source = categories.flatMap { $0.items }
        }

        var seen = Set<String>()

        let filtered = source.filter { symbol in
            guard seen.insert(symbol).inserted else {
                return false
            }

            return searchText.isEmpty ||
                symbol.localizedCaseInsensitiveContains(searchText)
        }

        let columns = 8

        for start in stride(from: 0, to: filtered.count, by: columns) {
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
                button.titleLabel?.font = .systemFont(ofSize: 22)
                button.backgroundColor =
                    UIColor.white.withAlphaComponent(0.07)
                button.layer.cornerRadius = 9

                button.addAction(
                    UIAction { [weak self] _ in
                        self?.textDocumentProxy.insertText(symbol)
                    },
                    for: .touchUpInside
                )

                row.addArrangedSubview(button)
            }

            while row.arrangedSubviews.count < columns {
                row.addArrangedSubview(UIView())
            }

            row.heightAnchor.constraint(equalToConstant: 40).isActive = true
            symbolGrid.addArrangedSubview(row)
        }
    }

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

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchText = ""
        DispatchQueue.main.async { [weak self] in
            self?.renderSymbols()
        }
        return true
    }
}
