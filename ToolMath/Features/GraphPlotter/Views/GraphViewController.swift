//
//  GraphViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import UIKit

class GraphViewController: UIViewController {

    private let viewModel = GraphViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.04, green: 0.05, blue: 0.15, alpha: 1).cgColor,
            UIColor(red: 0.10, green: 0.12, blue: 0.23, alpha: 1).cgColor,
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()

    private let graphView = GraphView()

    private let zoomControlsContainer = GlassMorphismCard()

    private let zoomInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(
            UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)),
            for: .normal)
        btn.tintColor = .white
        return btn
    }()

    private let zoomOutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(
            UIImage(
                systemName: "minus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)),
            for: .normal)
        btn.tintColor = .white
        return btn
    }()

    private let zoomLevelLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 12, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        return label
    }()

    private let fab = FloatingActionButton()

    private let functionPanel = GlassMorphismCard()
    private let functionPanelHandle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.cornerRadius = 2.5
        return view
    }()

    private let functionCardsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap + to add function"
        label.font = Theme.Fonts.display(size: 14)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        return label
    }()

    private var panelBottomConstraint: NSLayoutConstraint!
    private var isPanelVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        layout()
        setupGestures()
        setupBindings()
        setupActions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func setupGradient() {
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupUI() {
        graphView.viewModel = viewModel
        view.addSubview(graphView)

        view.addSubview(zoomControlsContainer)
        zoomControlsContainer.addSubview(zoomInButton)
        zoomControlsContainer.addSubview(zoomLevelLabel)
        zoomControlsContainer.addSubview(zoomOutButton)

        view.addSubview(fab)

        view.addSubview(functionPanel)
        functionPanel.addSubview(functionPanelHandle)
        functionPanel.addSubview(functionCardsStack)
        functionPanel.addSubview(emptyStateLabel)
    }

    private func layout() {
        graphView.translatesAutoresizingMaskIntoConstraints = false
        zoomControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        fab.translatesAutoresizingMaskIntoConstraints = false
        functionPanel.translatesAutoresizingMaskIntoConstraints = false
        functionPanelHandle.translatesAutoresizingMaskIntoConstraints = false
        functionCardsStack.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        panelBottomConstraint = functionPanel.topAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([

            graphView.topAnchor.constraint(equalTo: view.topAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            zoomControlsContainer.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            zoomControlsContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            zoomControlsContainer.widthAnchor.constraint(equalToConstant: 44),
            zoomControlsContainer.heightAnchor.constraint(equalToConstant: 140),

            zoomInButton.topAnchor.constraint(
                equalTo: zoomControlsContainer.topAnchor, constant: 12),
            zoomInButton.centerXAnchor.constraint(equalTo: zoomControlsContainer.centerXAnchor),
            zoomInButton.widthAnchor.constraint(equalToConstant: 32),
            zoomInButton.heightAnchor.constraint(equalToConstant: 32),

            zoomLevelLabel.centerYAnchor.constraint(equalTo: zoomControlsContainer.centerYAnchor),
            zoomLevelLabel.leadingAnchor.constraint(
                equalTo: zoomControlsContainer.leadingAnchor, constant: 4),
            zoomLevelLabel.trailingAnchor.constraint(
                equalTo: zoomControlsContainer.trailingAnchor, constant: -4),

            zoomOutButton.bottomAnchor.constraint(
                equalTo: zoomControlsContainer.bottomAnchor, constant: -12),
            zoomOutButton.centerXAnchor.constraint(equalTo: zoomControlsContainer.centerXAnchor),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 32),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 32),

            fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fab.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            fab.widthAnchor.constraint(equalToConstant: 56),
            fab.heightAnchor.constraint(equalToConstant: 56),

            panelBottomConstraint,
            functionPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            functionPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            functionPanel.heightAnchor.constraint(equalToConstant: 300),

            functionPanelHandle.topAnchor.constraint(equalTo: functionPanel.topAnchor, constant: 8),
            functionPanelHandle.centerXAnchor.constraint(equalTo: functionPanel.centerXAnchor),
            functionPanelHandle.widthAnchor.constraint(equalToConstant: 40),
            functionPanelHandle.heightAnchor.constraint(equalToConstant: 5),

            functionCardsStack.topAnchor.constraint(
                equalTo: functionPanelHandle.bottomAnchor, constant: 16),
            functionCardsStack.leadingAnchor.constraint(
                equalTo: functionPanel.leadingAnchor, constant: 20),
            functionCardsStack.trailingAnchor.constraint(
                equalTo: functionPanel.trailingAnchor, constant: -20),

            emptyStateLabel.centerXAnchor.constraint(equalTo: functionPanel.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: functionPanel.centerYAnchor),
        ])
    }

    private func setupGestures() {

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        graphView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(
            target: self, action: #selector(handlePinch(_:)))
        graphView.addGestureRecognizer(pinchGesture)

        let panelSwipe = UIPanGestureRecognizer(
            target: self, action: #selector(handlePanelSwipe(_:)))
        functionPanel.addGestureRecognizer(panelSwipe)
    }

    private func setupActions() {
        fab.onPrimaryAction = { [weak self] in
            self?.showAddFunctionModal()
        }

        zoomInButton.addAction(
            UIAction { [weak self] _ in
                self?.zoom(factor: 1.2)
            }, for: .touchUpInside)

        zoomOutButton.addAction(
            UIAction { [weak self] _ in
                self?.zoom(factor: 0.8)
            }, for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.$functions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] functions in
                self?.graphView.functions = functions
                self?.updateFunctionCards(functions)
                self?.updateZoomLabel()
            }
            .store(in: &cancellables)

        viewModel.$scale
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.graphView.scale = self?.viewModel.scale ?? 40
                self?.updateZoomLabel()
            }
            .store(in: &cancellables)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {

    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            zoom(factor: scale)
            gesture.scale = 1
        }
    }

    @objc private func handlePanelSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if gesture.state == .changed {
            if !isPanelVisible && translation.y < -50 {
                showPanel()
            } else if isPanelVisible && translation.y > 50 {
                hidePanel()
            }
        }
    }

    private func showPanel() {
        guard !isPanelVisible else { return }
        isPanelVisible = true

        panelBottomConstraint.constant = -300

        UIView.animate(
            withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5
        ) {
            self.view.layoutIfNeeded()
            self.functionPanel.alpha = 1
        }

        HapticManager.shared.selection()
    }

    private func hidePanel() {
        guard isPanelVisible else { return }
        isPanelVisible = false

        panelBottomConstraint.constant = 0

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.functionPanel.alpha = 0
        }

        HapticManager.shared.selection()
    }

    private func zoom(factor: CGFloat) {
        let newScale = max(10, min(100, viewModel.scale * factor))
        viewModel.scaleChange.send(newScale)

        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.graphView.setNeedsDisplay()
            })

        HapticManager.shared.selection()
    }

    private func updateZoomLabel() {
        zoomLevelLabel.text = "\(Int(viewModel.scale))"
    }

    private func showAddFunctionModal() {
        let addVC = AddFunctionViewController()
        addVC.modalPresentationStyle = .pageSheet

        if let sheet = addVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        addVC.onFunctionSelected = { [weak self] expression in
            self?.viewModel.addFunctionTrigger.send(expression)
            if !(self?.isPanelVisible ?? false) {
                self?.showPanel()
            }
        }

        present(addVC, animated: true)
    }

    private func updateFunctionCards(_ functions: [GraphFunction]) {
        functionCardsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        emptyStateLabel.isHidden = !functions.isEmpty

        for function in functions {
            let card = FunctionCardView(expression: function.expression, color: function.color)
            card.setVisible(function.visible, animated: false)

            card.onToggleVisibility = { [weak self] in
                self?.viewModel.toggleFunctionTrigger.send(function.id)
            }

            card.onDelete = { [weak self] in
                self?.viewModel.removeFunctionTrigger.send(function.id)
            }

            functionCardsStack.addArrangedSubview(card)
        }
    }
}