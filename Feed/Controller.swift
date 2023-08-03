//
//  Controller.swift
//  RSSFeed
//
//  Created by Nikolay Petrov on 01/08/2023.
//

import Foundation
import XMLParsing
import Kingfisher

class Controller {
    
    private let view: RootViewControllerInDelegate
    private let viewModel: ViewModelIn
    
    init(view: RootViewControllerInDelegate, viewModel: ViewModelIn) {
        self.view = view
        self.viewModel = viewModel
    }
    
    private func makeRequest() {
        view.startSpinner()
        guard let url = URL(string: "http://feeds.a.dj.com/rss/WSJcomUSBusiness.xml") else {
            print("Unexisting URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, respnse, error in
            guard let data = data else {
                return
            }
            
            let decoder = XMLDecoder()
            
            do {
                let feed = try decoder.decode(RSSFeed.self, from: data)
                self.viewModel.updateItems(feed.channel.items)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

extension Controller: RootViewControllerOutDelegate {
    func getImageForCellAt(index: Int, imageURL: String) {
        guard let url = URL(string: imageURL) else {
            return
        }
        
        let downloader = KingfisherManager.shared.downloader
        downloader.trustedHosts = [imageURL]
        downloader.downloadImage(with: url, options: .none) { result in
            switch result {
            case .success(let value):
                self.view.didGetImageForCellAt(index: index, image: value.image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didTapCellAtIndex(_ index: Int) {
        viewModel.getItemAtIndex(index)
    }
    
    func viewDidLoad() {
        makeRequest()
    }
}

extension Controller: ViewModelOut {
    func didGetItem(_ item: Item) {
        view.showDetails(item: item)
    }
    
    func didUpdateItems(_ items: [Item]) {
        let articles = items.map { ArticleItem(title: $0.title, image: $0.imageURL ?? "") }
        DispatchQueue.main.sync {
            view.updateArticles(articles)
        }
    }
    
    func didTapReload() {
        makeRequest()
    }
}
