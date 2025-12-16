//
//  AddFunctionViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class AddFunctionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UISearchBarDelegate
{

    var onFunctionSelected: ((String) -> Void)?

    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search functions..."
        search.searchBarStyle = .minimal
        search.barTintColor = Theme.Colors.background
        search.backgroundColor = Theme.Colors.background
        return search
    }()

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = Theme.Colors.background
        tv.separatorColor = UIColor.white.withAlphaComponent(0.1)
        return tv
    }()

    private let categorySegment: UISegmentedControl = {
        let items = ["All", "Basic", "Trig", "Advanced"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        return segment
    }()

    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .systemGray
        return btn
    }()

    struct FunctionTemplate {
        let expression: String
        let name: String
        let description: String
        let category: Category

        enum Category: String {
            case basic = "Basic"
            case trigonometric = "Trig"
            case advanced = "Advanced"
        }
    }

    private let allFunctions: [FunctionTemplate] = [

        FunctionTemplate(
            expression: "x", name: "Linear", description: "Simple linear function", category: .basic
        ),
        FunctionTemplate(
            expression: "x^2", name: "Quadratic", description: "Parabola opening upward",
            category: .basic),
        FunctionTemplate(
            expression: "-x^2", name: "Inverted Parabola", description: "Parabola opening downward",
            category: .basic),
        FunctionTemplate(
            expression: "x^3", name: "Cubic", description: "S-shaped cubic curve", category: .basic),
        FunctionTemplate(
            expression: "sqrt(x)", name: "Square Root", description: "Square root function",
            category: .basic),
        FunctionTemplate(
            expression: "1/x", name: "Reciprocal", description: "Hyperbola", category: .basic),
        FunctionTemplate(
            expression: "abs(x)", name: "Absolute Value", description: "V-shaped graph",
            category: .basic),

        FunctionTemplate(
            expression: "sin(x)", name: "Sine", description: "Sine wave", category: .trigonometric),
        FunctionTemplate(
            expression: "cos(x)", name: "Cosine", description: "Cosine wave",
            category: .trigonometric),
        FunctionTemplate(
            expression: "tan(x)", name: "Tangent", description: "Tangent function",
            category: .trigonometric),
        FunctionTemplate(
            expression: "2*sin(x)", name: "Amplitude Sine", description: "Sine with amplitude 2",
            category: .trigonometric),
        FunctionTemplate(
            expression: "sin(2*x)", name: "Frequency Sine",
            description: "Sine with doubled frequency", category: .trigonometric),
        FunctionTemplate(
            expression: "sin(x)+cos(x)", name: "Combined Waves",
            description: "Sum of sine and cosine", category: .trigonometric),

        FunctionTemplate(
            expression: "e^x", name: "Exponential", description: "Natural exponential growth",
            category: .advanced),
        FunctionTemplate(
            expression: "ln(x)", name: "Natural Log", description: "Natural logarithm",
            category: .advanced),
        FunctionTemplate(
            expression: "log(x)", name: "Logarithm", description: "Base-10 logarithm",
            category: .advanced),
        FunctionTemplate(
            expression: "x*sin(x)", name: "Damped Wave",
            description: "Oscillation with linear envelope", category: .advanced),
        FunctionTemplate(
            expression: "e^(-x)*sin(5*x)", name: "Decaying Wave",
            description: "Exponentially damped oscillation", category: .advanced),
        FunctionTemplate(
            expression: "x^2*sin(1/x)", name: "Complex Oscillation",
            description: "Rapidly oscillating function", category: .advanced),
    ]

    private var filteredFunctions: [FunctionTemplate] = []
    private var selectedCategory: FunctionTemplate.Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colors.background

        filteredFunctions = allFunctions

        setupUI()
        layout()
        setupActions()
    }

    private func setupUI() {
        view.addSubview(closeButton)
        view.addSubview(searchBar)
        view.addSubview(categorySegment)
        view.addSubview(tableView)

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FunctionCell.self, forCellReuseIdentifier: "FunctionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomCell")
    }

    private func layout() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        categorySegment.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            searchBar.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            categorySegment.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            categorySegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categorySegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: categorySegment.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupActions() {
        closeButton.addAction(
            UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }, for: .touchUpInside)

        categorySegment.addAction(
            UIAction { [weak self] _ in
                self?.filterByCategory()
            }, for: .valueChanged)
    }

    private func filterByCategory() {
        let index = categorySegment.selectedSegmentIndex

        switch index {
        case 0:
            selectedCategory = nil
        case 1:
            selectedCategory = .basic
        case 2:
            selectedCategory = .trigonometric
        case 3:
            selectedCategory = .advanced
        default:
            selectedCategory = nil
        }

        applyFilters()
    }

    private func applyFilters() {
        let searchText = searchBar.text?.lowercased() ?? ""

        filteredFunctions = allFunctions.filter { function in
            let matchesCategory = selectedCategory == nil || function.category == selectedCategory
            let matchesSearch =
                searchText.isEmpty || function.name.lowercased().contains(searchText)
                || function.expression.lowercased().contains(searchText)
                || function.description.lowercased().contains(searchText)

            return matchesCategory && matchesSearch
        }

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilters()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filteredFunctions.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return filteredFunctions.isEmpty ? nil : "TEMPLATES"
        } else {
            return "CUSTOM"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "FunctionCell", for: indexPath) as? FunctionCell
            else {
                return UITableViewCell()
            }

            let function = filteredFunctions[indexPath.row]
            cell.configure(with: function)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
            cell.backgroundColor = Theme.Colors.surface
            cell.textLabel?.text = "Enter Custom Expression"
            cell.textLabel?.textColor = Theme.Colors.primary
            cell.textLabel?.font = Theme.Fonts.display(size: 16, weight: .semibold)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            let function = filteredFunctions[indexPath.row]
            onFunctionSelected?(function.expression)
            dismiss(animated: true)
        } else {
            showCustomInputDialog()
        }
    }

    func tableView(
        _ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int
    ) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = Theme.Colors.primary
            header.textLabel?.font = Theme.Fonts.display(size: 12, weight: .bold)
        }
    }

    private func showCustomInputDialog() {
        let alert = UIAlertController(
            title: "Custom Function",
            message:
                "Enter a mathematical expression using x as variable.\nExample: x^2 + 3*sin(x)",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "e.g., x^2 + 2*x + 1"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(
            UIAlertAction(title: "Add", style: .default) { [weak self, weak alert] _ in
                if let expression = alert?.textFields?.first?.text, !expression.isEmpty {
                    self?.onFunctionSelected?(expression)
                    self?.dismiss(animated: true)
                }
            })

        present(alert, animated: true)
    }
}

class FunctionCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let expressionLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.mono(size: 14)
        label.textColor = Theme.Colors.primary
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 12)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.primary.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        return view
    }()

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 20, weight: .bold)
        label.textColor = Theme.Colors.primary
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = Theme.Colors.surface
        selectionStyle = .default

        contentView.addSubview(iconView)
        iconView.addSubview(iconLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(expressionLabel)
        contentView.addSubview(descriptionLabel)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),

            iconLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            expressionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            expressionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            expressionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(
                equalTo: expressionLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    func configure(with function: AddFunctionViewController.FunctionTemplate) {
        nameLabel.text = function.name
        expressionLabel.text = "f(x) = \(function.expression)"
        descriptionLabel.text = function.description

        switch function.category {
        case .basic:
            iconLabel.text = "📈"
        case .trigonometric:
            iconLabel.text = "∿"
        case .advanced:
            iconLabel.text = "∑"
        }
    }
}