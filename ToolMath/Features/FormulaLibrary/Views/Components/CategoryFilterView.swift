//
//  CategoryFilterView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import UIKit

protocol CategoryFilterViewDelegate: AnyObject {
    func didSelectCategory(_ category: FormulaCategory?)
}

final class CategoryFilterView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Properties

    weak var delegate: CategoryFilterViewDelegate?

    private var categories: [FormulaCategory] = FormulaCategory.allCases
    private var selectedCategory: FormulaCategory? = nil {
        didSet {
            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(FilterChipCell.self, forCellWithReuseIdentifier: "FilterChipCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = .clear
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public Methods

    func selectCategory(_ category: FormulaCategory?) {
        selectedCategory = category
        // Scroll to selected if needed
        if let category = category, let index = categories.firstIndex(of: category) {
            let indexPath = IndexPath(item: index + 1, section: 0)  // +1 because of "All"
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }

    // MARK: - CollectionView DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int
    {
        return categories.count + 1  // +1 for "All" option
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FilterChipCell", for: indexPath) as? FilterChipCell
        else {
            return UICollectionViewCell()
        }

        if indexPath.item == 0 {
            cell.configure(title: "All", isSelected: selectedCategory == nil)
        } else {
            let category = categories[indexPath.item - 1]
            cell.configure(title: category.rawValue, isSelected: selectedCategory == category)
        }

        return cell
    }

    // MARK: - CollectionView Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            selectedCategory = nil
            delegate?.didSelectCategory(nil)
        } else {
            let category = categories[indexPath.item - 1]
            if selectedCategory == category {
                // Deselect if already selected (toggle) -> go to All
                selectedCategory = nil
                delegate?.didSelectCategory(nil)
            } else {
                selectedCategory = category
                delegate?.didSelectCategory(category)
            }
        }
    }
}

// MARK: - Filter Chip Cell

final class FilterChipCell: UICollectionViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title

        if isSelected {
            containerView.backgroundColor = Theme.Colors.primary.withAlphaComponent(0.2)
            containerView.layer.borderColor = Theme.Colors.primary.cgColor
            titleLabel.textColor = Theme.Colors.primary
            titleLabel.font = Theme.Fonts.display(size: 14, weight: .bold)
        } else {
            containerView.backgroundColor = Theme.Colors.surface
            containerView.layer.borderColor = Theme.Colors.surfaceSecondary.cgColor
            titleLabel.textColor = Theme.Colors.textSecondary
            titleLabel.font = Theme.Fonts.display(size: 14, weight: .medium)
        }
    }
}
