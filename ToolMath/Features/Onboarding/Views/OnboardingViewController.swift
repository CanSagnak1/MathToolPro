//
//  OnboardingViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    private let slides: [(title: String, desc: String, icon: String)] = [
        (
            "Advanced Calculator", "Experience precision with our scientific calculator engine.",
            "function"
        ),
        (
            "Formula Library", "Access hundreds of formulas for Math, Physics, and Finance.",
            "text.book.closed"
        ),
        ("Math Notepad", "Save your calculations and take notes in one place.", "note.text"),
    ]

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = Theme.Colors.primary
        pc.pageIndicatorTintColor = Theme.Colors.secondaryText.withAlphaComponent(0.3)
        return pc
    }()

    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.titleLabel?.font = Theme.Fonts.display(size: 18, weight: .bold)
        btn.backgroundColor = Theme.Colors.primary
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.background

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")

        pageControl.numberOfPages = slides.count

        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(actionButton)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20),

            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            actionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc private func buttonTapped() {
        if pageControl.currentPage == slides.count - 1 {
            finishOnboarding()
        } else {
            let nextIndex = min(pageControl.currentPage + 1, slides.count - 1)
            let indexPath = IndexPath(item: nextIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = nextIndex
            updateButtonText()
        }
    }

    private func updateButtonText() {
        if pageControl.currentPage == slides.count - 1 {
            actionButton.setTitle("Get Started", for: .normal)
        } else {
            actionButton.setTitle("Next", for: .normal)
        }
    }

    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")

        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        {
            window.rootViewController = AppNavigationHub()
            UIView.transition(
                with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil,
                completion: nil)
        }
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int
    {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell
        else {
            return UICollectionViewCell()
        }
        let slide = slides[indexPath.item]
        cell.configure(title: slide.title, desc: slide.desc, icon: slide.icon)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        if width > 0 {
            let currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
            pageControl.currentPage = currentPage
            updateButtonText()
        }
    }
}

class OnboardingCell: UICollectionViewCell {

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Theme.Colors.primary
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 28, weight: .bold)
        l.textColor = Theme.Colors.textPrimary
        l.textAlignment = .center
        return l
    }()

    private let descLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 16, weight: .regular)
        l.textColor = Theme.Colors.secondaryText
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -80),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 120),
            iconView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
        ])
    }

    func configure(title: String, desc: String, icon: String) {
        titleLabel.text = title
        descLabel.text = desc
        iconView.image = UIImage(systemName: icon)
    }
}
