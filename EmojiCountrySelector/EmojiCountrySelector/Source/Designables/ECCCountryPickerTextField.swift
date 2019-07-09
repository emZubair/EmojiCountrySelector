//
//  ECCCountryPickerTextField.swift
//  EmojiCountryCode
//
//  Created by zubair on 7/5/19.
//  Copyright © 2019 zubair. All rights reserved.
//

import UIKit

public protocol ECCCountryPickerDelegate:class {
    func didSelectCountry(country: Country)
}

@IBDesignable public class ECCCountryPickerTextField: UITextField {
    
    fileprivate var countries = [Country]()
    weak fileprivate var pickerDelegate: ECCCountryPickerDelegate?
    weak fileprivate var containverViewController:UIViewController?
    
    let screenSize = UIScreen.main.bounds
    public let pickerView = UIPickerView()
    
    override public func awakeFromNib() {
        populateCountryList()
        setupPicker()
        createToolbar()
        inputView = pickerView
        text = selectedCountry?.countryFlagAndCode()
    }
    
    public func set(picker delegate:ECCCountryPickerDelegate, from viewController:UIViewController) {
        pickerDelegate = delegate
        containverViewController = viewController
    }
    
    private var selectedCountry : Country? {
        didSet {
            guard let country = selectedCountry else { return }
            text = country.countryFlagAndCode()
            pickerDelegate?.didSelectCountry(country: country)
        }
    }
    
    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
    
    @objc func searchCountry() {
        let tableviewController = ECCTableViewController(countries: countries,textColor: textColor!, font: font! ,delegate: self)
        containverViewController?.present(tableviewController, animated: true)
        self.resignFirstResponder()
    }
    
    private func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search,target: self, action: #selector(ECCCountryPickerTextField.searchCountry))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,target: self, action: #selector(ECCCountryPickerTextField.dismissKeyboard))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([searchButton, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputAccessoryView = toolBar
        toolBar.tintColor = tintColor
    }
    
    func setupPicker() {
        
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        
        if let currentRegion = Locale.current.regionCode {
            selectedCountry = Country(isoCode: currentRegion)
        }
    }
    
    private func populateCountryList() {
        let list = Locale.isoRegionCodes.map { isoCode in
            return Country(isoCode: isoCode)
        }
        // Removing Regions that don't have phone codes i.e Antarctica, Aland Islands
        countries = list.filter { $0.phoneCode != ""}
        countries.sort(by: {$0.name < $1.name})
        let empty = Country(isoCode: "")
        countries.insert(empty, at: 0)
    }
    
    func didSelectCountry(country: Country) {
        selectedCountry = country
    }
}

extension ECCCountryPickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectCountry(country: countries[row])
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.text = countries[row].countryFlagAndName()
        return label
    }
}


extension ECCCountryPickerTextField: ECCTableViewControllerDelegate {
    func didSelectCountry(country: Country, in tableviewController: UITableViewController) {
        selectedCountry = country
    }
}
