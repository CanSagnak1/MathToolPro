//
//  FormulaLibraryViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//  Refactored on 18.02.2026.
//

import UIKit

class FormulaLibraryViewController: UIViewController {

    // MARK: - Properties

    private let engine = FormulaEngine.shared
    private var filteredFormulas: [Formula] = []
    private var selectedCategory: FormulaCategory? = nil

    private var dataSource: UICollectionViewDiffableDataSource<Int, Formula.ID>?

    // MARK: - UI Components

    private let filterView = CategoryFilterView()

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.keyboardDismissMode = .onDrag
        cv.delegate = self
        cv.register(ModernFormulaCell.self, forCellWithReuseIdentifier: "ModernFormulaCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let emptyStateView: EmptyStateView = {
        let v = EmptyStateView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search formulas..."
        sc.searchBar.tintColor = Theme.Colors.primary
        return sc
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        filterView.delegate = self

        // Initial Data Load
        applySnapshot(animatingDifferences: false)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        title = "Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchResultsUpdater = self

        view.addSubview(filterView)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)

        filterView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 60),

            collectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(
                equalTo: collectionView.centerYAnchor, constant: 50),  // Offset for filter bar
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(88)  // Fixed height for cards
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(88)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16, leading: 16, bottom: 24, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Data Source

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Formula.ID>(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, id) -> UICollectionViewCell? in
            guard let self = self,
                let formula = self.engine.allFormulas.first(where: { $0.id == id })
            else {
                return nil
            }

            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ModernFormulaCell", for: indexPath) as? ModernFormulaCell
            else {
                return UICollectionViewCell()
            }

            cell.configure(with: formula)
            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        let searchText = searchController.searchBar.text ?? ""

        // Filter Logic
        var formulas = engine.allFormulas

        if let category = selectedCategory {
            formulas = formulas.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            formulas = engine.searchFormulas(query: searchText, in: formulas)
        }

        self.filteredFormulas = formulas

        // Update Snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Int, Formula.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(formulas.map { $0.id })

        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)

        updateEmptyState(isEmpty: formulas.isEmpty)
    }

    private func updateEmptyState(isEmpty: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.emptyStateView.isHidden = !isEmpty
            self.emptyStateView.alpha = isEmpty ? 1 : 0
        }
    }
}

// MARK: - CollectionView Delegate

extension FormulaLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let id = dataSource?.itemIdentifier(for: indexPath),
            let formula = engine.allFormulas.first(where: { $0.id == id })
        else { return }

        let detailVC = FormulaDetailViewController(formula: formula)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Search Results Updating

extension FormulaLibraryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applySnapshot()
    }
}

// MARK: - Filter Delegate

extension FormulaLibraryViewController: CategoryFilterViewDelegate {
    func didSelectCategory(_ category: FormulaCategory?) {
        self.selectedCategory = category
        applySnapshot()
    }
}
