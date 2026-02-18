//
//  AppNavigationHub.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//  Refactored on 18.02.2026.
//

import UIKit

final class AppNavigationHub: UITabBarController {

    // MARK: - Tab Definitions

    private struct TabDefinition {
        let viewController: UIViewController
        let iconName: String
        let title: String
        let wrapInNav: Bool

        init(_ vc: UIViewController, icon: String, title: String, wrapInNav: Bool = false) {
            self.viewController = vc
            self.iconName = icon
            self.title = title
            self.wrapInNav = wrapInNav
        }
    }

    // MARK: - Properties

    private var customTabBar: CustomTabBarView!

    /// Tab configurations — order matters
    private lazy var tabDefinitions: [TabDefinition] = [
        TabDefinition(
            FormulaLibraryViewController(), icon: "text.book.closed", title: "Formulas",
            wrapInNav: true),
        TabDefinition(
            MathNotepadViewController(), icon: "note.text", title: "Notes", wrapInNav: true),
        TabDefinition(CalcEngineViewController(), icon: "", title: ""),  // Center (hidden item)
        TabDefinition(
            ConverterViewController(), icon: "arrow.triangle.2.circlepath", title: "Convert"),
        TabDefinition(GraphViewController(), icon: "waveform.path.ecg", title: "Graph"),
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabs()
        setupCustomTabBar()

        delegate = self

        // Hide System Tab Bar
        tabBar.isHidden = true

        // Initial Selection
        selectedIndex = 2
        customTabBar.selectTab(at: 2)
    }

    // MARK: - Tab Configuration

    private func configureTabs() {
        var controllers: [UIViewController] = []

        for (index, def) in tabDefinitions.enumerated() {
            let vc: UIViewController
            if def.wrapInNav {
                vc = UINavigationController(rootViewController: def.viewController)
            } else {
                vc = def.viewController
            }

            // Set tag for identification
            vc.tabBarItem.tag = index

            // Adjust safe area to prevent content from being hidden behind custom tab bar
            vc.additionalSafeAreaInsets.bottom = 64

            controllers.append(vc)
        }

        viewControllers = controllers
    }

    // MARK: - Custom Tab Bar Setup

    private func setupCustomTabBar() {
        // Create configs
        let configs = tabDefinitions.map {
            CustomTabBarView.ItemConfig(icon: $0.iconName, title: $0.title)
        }

        customTabBar = CustomTabBarView(items: configs)
        customTabBar.delegate = self
        customTabBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(customTabBar)

        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Height = Bottom Safe Area + 64 (content height)
            customTabBar.heightAnchor.constraint(
                equalToConstant: 64
                    + (view.safeAreaInsets.bottom > 0 ? view.safeAreaInsets.bottom : 34)),
        ])
    }

    // MARK: - Layout Updates

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Ensure custom tab bar is on top and correctly sized
        view.bringSubviewToFront(customTabBar)

        // Adjust height constraint if safe area changes (e.g. rotation)
        if let heightConstraint = customTabBar.constraints.first(where: {
            $0.firstAttribute == .height
        }) {
            heightConstraint.constant = 64 + view.safeAreaInsets.bottom
        }
    }

    // MARK: - Tab Transition Animation

    private func animateTabTransition(from fromIndex: Int, to toIndex: Int) {
        guard let fromVC = viewControllers?[fromIndex],
            let toVC = viewControllers?[toIndex]
        else { return }

        let direction: CGFloat = toIndex > fromIndex ? 1 : -1

        // Subtle cross-fade + slight horizontal shift
        toVC.view.alpha = 0
        toVC.view.transform = CGAffineTransform(translationX: 30 * direction, y: 0)

        UIView.animate(
            withDuration: Theme.Animation.normal,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.3,
            options: .curveEaseInOut
        ) {
            fromVC.view.alpha = 0.6
            fromVC.view.transform = CGAffineTransform(translationX: -20 * direction, y: 0)

            toVC.view.alpha = 1
            toVC.view.transform = .identity
        } completion: { _ in
            fromVC.view.alpha = 1
            fromVC.view.transform = .identity
        }
    }
}

// MARK: - CustomTabBarViewDelegate

extension AppNavigationHub: CustomTabBarViewDelegate {
    func customTabBar(_ tabBar: CustomTabBarView, didSelectTabAt index: Int) {
        let previousIndex = selectedIndex
        selectedIndex = index

        if previousIndex != index {
            animateTabTransition(from: previousIndex, to: index)
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension AppNavigationHub: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        // We handle selection via custom tab bar.
        // If system tab bar is somehow interacted with (it's hidden but just in case), allow it to sync
        if let index = viewControllers?.firstIndex(of: viewController) {
            customTabBar.selectTab(at: index)
        }
        return true
    }
}
