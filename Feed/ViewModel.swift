//
//  ViewModel.swift
//  RSSFeed
//
//  Created by Nikolay Petrov on 01/08/2023.
//

import Foundation

protocol ViewModelIn {
    func getItemAtIndex(_ index: Int)
    func updateItems(_ items: [Item])
}

protocol ViewModelOut: AnyObject {
    func didUpdateItems(_ items: [Item])
    func didGetItem(_ item: Item)
}

class ViewModel {
    private var items: [Item] = []
    weak var delegate: ViewModelOut?
    init() {}
}

extension ViewModel: ViewModelIn {
    func updateItems(_ items: [Item]) {
        self.items = items
        delegate?.didUpdateItems(self.items)
    }
    
    func getItemAtIndex(_ index: Int) {
        delegate?.didGetItem(items[index])
    }
}
