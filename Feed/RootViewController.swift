//
//  ViewController.swift
//  RSSFeed
//
//  Created by Nikolay Petrov on 31/07/2023.
//

import UIKit
import SwiftUI

protocol RootViewControllerInDelegate {
    func startSpinner()
    func updateArticles(_ articles: [ArticleItem])
    func didGetImageForCellAt(index: Int, image: UIImage)
    func showDetails(item: Item)
}

protocol RootViewControllerOutDelegate: AnyObject {
    func viewDidLoad()
    func didTapReload()
    func didTapCellAtIndex(_ index: Int)
    func getImageForCellAt(index: Int, imageURL: String)
}

struct ArticleItem {
    let title: String
    let image: String
}

class RootViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let reloadButton = UIButton()
    private let spinner = UIActivityIndicatorView()
    
    private var articles: [ArticleItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var delegate: RootViewControllerOutDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpTitle()
        setUpTableView()
        setUpReloadButton()
        setUpSpinner()
        
        delegate?.viewDidLoad()
    }
    
    private func setUpSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.style = .large
        spinner.color = .black
        spinner.isHidden = true
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpReloadButton() {
        view.addSubview(reloadButton)
        reloadButton.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.addTarget(self, action: #selector(didTapReloadButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            reloadButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            reloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -10)
        ])
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewCell.self, forCellReuseIdentifier: NewCell.Reuse.identifier)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpTitle() {
        titleLabel.text = "RSS Feed"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc private func didTapReloadButton() {
        delegate?.didTapReload()
    }
}

// MARK: DataSource
extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewCell.Reuse.identifier) as? NewCell else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        delegate?.getImageForCellAt(index: indexPath.row, imageURL: article.image)
        cell.updateTitle(article.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapCellAtIndex(indexPath.row)
    }
    
}

// MARK: TableViewDelegate
extension RootViewController: UITableViewDelegate {
    
}

// MARK: RootViewControllerInDelegate
extension RootViewController: RootViewControllerInDelegate {
    func showDetails(item: Item) {
        let vc = UIHostingController(rootView: DetailsView(title: item.title,
                                                           description: item.description,
                                                           imageURL: item.imageURL ?? "",
                                                           link: item.link.absoluteString))
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func didGetImageForCellAt(index: Int, image: UIImage) {
        guard let cell = tableView.cellForRow(at: IndexPath(index: index)) as? NewCell else {
            return
        }
        
        cell.updateImage(image)
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func updateArticles(_ articles: [ArticleItem]) {
        self.articles = articles
        spinner.stopAnimating()
    }
}
