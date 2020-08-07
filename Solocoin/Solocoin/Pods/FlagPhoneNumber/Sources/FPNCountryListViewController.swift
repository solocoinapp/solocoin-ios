//
//  FPNCountryListViewController.swift
//  FlagPhoneNumber
//
//  Created by Aurélien Grifasi on 06/08/2017.
//  Copyright (c) 2017 Aurélien Grifasi. All rights reserved.
//

import UIKit

open class FPNCountryListViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {

	open var repository: FPNCountryRepository?
	open var showCountryPhoneCode: Bool = true
	open var searchController: UISearchController = UISearchController(searchResultsController: nil)
	open var didSelect: ((FPNCountry) -> Void)?

	var results: [FPNCountry]?

	override open func viewDidLoad() {
		super.viewDidLoad()
		let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.goingBack(_:)))
		let attrs = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 240/255, green: 81/255, blue: 105/255, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 20)!]
		tableView.tableFooterView = UIView()
		tableView.tableFooterView?.backgroundColor = .white
		var frame = CGRect.zero
		frame.size.height = .leastNormalMagnitude
		tableView.tableHeaderView = UIView(frame: frame)
		tableView.tableHeaderView?.backgroundColor = .white
		tableView.backgroundColor = .white
		tableView.separatorColor = UIColor.init(red: 240/255, green: 81/255, blue: 105/255, alpha: 1)
        	tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		self.navigationController?.navigationBar.titleTextAttributes = attrs
        	self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.barTintColor = .white
		tableView.backgroundView?.backgroundColor = .white
		self.navigationItem.leftBarButtonItem = backButton
		initSearchBarController()
	}
	
	override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.backgroundView?.layer.masksToBounds = true
        tableView.backgroundView?.backgroundColor = .white
            //Continue changing more properties...
    }
	
	override open func viewDidAppear(_ animated: Bool){
		super.viewWillAppear(animated)
		let attrs = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 240/255, green: 81/255, blue: 105/255, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 20)!]
		self.navigationController?.navigationBar.titleTextAttributes = attrs
		self.navigationController?.navigationBar.barTintColor = .white
	}

	open func setup(repository: FPNCountryRepository) {
		self.repository = repository
	}

	private func initSearchBarController() {
		searchController.searchResultsUpdater = self
		searchController.delegate = self

		if #available(iOS 9.1, *) {
			searchController.obscuresBackgroundDuringPresentation = false
		} else {
			// Fallback on earlier versions
		}

		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = false
		} else {
			searchController.dimsBackgroundDuringPresentation = false
			searchController.hidesNavigationBarDuringPresentation = true
			searchController.definesPresentationContext = true

			//				searchController.searchBar.sizeToFit()
			//searchController.searchBar.tintColor = .white
            		searchController.searchBar.barTintColor = .white
			searchController.searchBar.backgroundColor = .white
			tableView.tableHeaderView = searchController.searchBar
			tableView.backgroundColor = .white
			tableView.tableHeaderView?.backgroundColor
			self.navigationController?.navigationBar.barTintColor = .white
			tableView.backgroundView?.backgroundColor = .white
		}
		definesPresentationContext = true
	}
	
	@objc func goingBack(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }

	private func getItem(at indexPath: IndexPath) -> FPNCountry {
		if searchController.isActive && results != nil && results!.count > 0 {
			return results![indexPath.row]
		} else {
			return repository!.countries[indexPath.row]
		}
	}

	override open func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive {
			if let count = searchController.searchBar.text?.count, count > 0 {
				return results?.count ?? 0
			}
		}
		return repository?.countries.count ?? 0
	}

	override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		let country = getItem(at: indexPath)

		cell.imageView?.image = country.flag
		cell.textLabel?.text = country.name
		cell.textLabel?.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        	cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 20)
		cell.backgroundColor = .white
		cell.contentView.backgroundColor = .clear

		if showCountryPhoneCode {
			cell.detailTextLabel?.text = country.phoneCode
			cell.detailTextLabel?.textColor = .gray
			cell.detailTextLabel?.font = UIFont(name: "Poppins-SemiBold", size: 15)
		}

		return cell
	}

	override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let country = getItem(at: indexPath)

		tableView.deselectRow(at: indexPath, animated: true)

		didSelect?(country)

		searchController.isActive = false
		searchController.searchBar.resignFirstResponder()
		dismiss(animated: true, completion: nil)
	}

	// UISearchResultsUpdating

	open func updateSearchResults(for searchController: UISearchController) {
		guard let countries = repository?.countries else { return }

		if countries.isEmpty {
			results?.removeAll()
			return
		} else if searchController.searchBar.text == "" {
			results?.removeAll()
			tableView.reloadData()
			return
		}

		if let searchText = searchController.searchBar.text, searchText.count > 0 {
			results = countries.filter({(item: FPNCountry) -> Bool in
				if item.name.lowercased().range(of: searchText.lowercased()) != nil {
					return true
				} else if item.code.rawValue.lowercased().range(of: searchText.lowercased()) != nil {
					return true
				} else if item.phoneCode.lowercased().range(of: searchText.lowercased()) != nil {
					return true
				}
				return false
			})
		}
		tableView.reloadData()
	}

	// UISearchControllerDelegate

	open func willDismissSearchController(_ searchController: UISearchController) {
		results?.removeAll()
	}
}
