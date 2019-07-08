//
//  ECCTableViewController.swift
//  EmojiCountryCode
//
//  Created by zubair on 7/5/19.
//  Copyright © 2019 zubair. All rights reserved.
//

import UIKit

protocol ECCTableViewControllerDelegate:class {
    func didSelectCountry(country: Country, in tableviewController:UITableViewController)
}

class ECCTableViewController: UITableViewController {
    
    fileprivate var searchResults : [Country] {
        didSet {
            reloadTableView()
        }
    }
    fileprivate let font:UIFont
    fileprivate let textColor:UIColor
    fileprivate let countries: [Country]
    weak fileprivate var delegate:ECCTableViewControllerDelegate?
    let searchBar:UISearchBar
    
    init(countries:[Country], textColor:UIColor, font:UIFont ,delegate:ECCTableViewControllerDelegate) {
        self.font = font
        self.delegate = delegate
        self.countries = countries
        self.textColor = textColor
        self.searchResults = countries
        searchBar = UISearchBar(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
        searchBar.inputAccessoryView = createToolbar()
//        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func reloadTableView() {
        if searchResults.count > 0 {
            tableView.reloadData()
            tableView.scrollsToTop = true
        }
    }
    
    private func registerCell() {
        let xibName = String(describing:ECCTableViewCell.self)
        tableView.register(UINib(nibName: xibName, bundle: Bundle(for: ECCTableViewController.self)), forCellReuseIdentifier: xibName)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
        dismiss(animated: true)
    }
    
    private func createToolbar() -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,target: self, action: #selector(ECCTableViewController.dismissKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:ECCTableViewCell.self), for: indexPath) as? ECCTableViewCell {
            cell.populateCell(with: searchResults[indexPath.row], textColor: textColor, font:font)
            return cell
        }

        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCountry(country: searchResults[indexPath.row], in: self)
        dismissKeyboard()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar.frame = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 45))
        let view = UIView(frame: searchBar.frame)
        view.addSubview(searchBar)
        
        return view
    }
}

extension ECCTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults = countries
        }else {
            searchResults = countries.filter{$0.name.lowercased().contains(searchText.lowercased())}
        }
    }
    
}
