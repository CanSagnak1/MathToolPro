//
//  MainTabBarController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let converterVC = ConverterViewController()
        converterVC.tabBarItem = UITabBarItem(
            title: "Convert",
            image: UIImage(systemName: "arrow.triangle.2.circlepath"),
            tag: 0
        )

        let graphVC = GraphViewController()
        graphVC.tabBarItem = UITabBarItem(
            title: "Graph",
            image: UIImage(systemName: "waveform.path.ecg"),
            tag: 1
        )

        let calcVC = CalculatorViewController()
        calcVC.tabBarItem = UITabBarItem(
            title: "Calc",
            image: UIImage(systemName: "function"),
            tag: 2
        )

        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 3
        )

        viewControllers = [converterVC, graphVC, calcVC, settingsVC]

        delegate = self
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = Theme.Colors.background.withAlphaComponent(0.9)
        appearance.backgroundEffect = UIBlurEffect(style: .dark)

        appearance.stackedLayoutAppearance.selected.iconColor = Theme.Colors.primary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Theme.Colors.primary
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = Theme.Colors.primary
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController, didSelect viewController: UIViewController
    ) {
        let settings = AppSettings.load()
        if settings.hapticFeedbackEnabled {
            HapticManager.shared.selection()
        }
    }
}