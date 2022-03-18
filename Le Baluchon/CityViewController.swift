//
//  CityViewController.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 12/03/2022.
//

import Foundation

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var cities: [City] = []
    var filteredCities: [City] = []
    var buttonTag: Int?
    
    var cityTextIsEmpty: Bool {
        guard searchBar.text?.isEmpty != true else {
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layer.cornerRadius = 5.0
        tableView.separatorColor = UIColor.lightGray
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        
        cities = City.cities()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    @objc func searchRecords(_ textField: UITextField) {
        searchCity(textField.text!)
        tableView.reloadData()
    }
    
    
    private func searchCity(_ textField: String) {
        if textField.count != 0 {
            tableView.isHidden = false
        filteredCities = cities.filter { (city: City) -> Bool in
            return  city.name.lowercased().contains(textField.lowercased())
        }}
        tableView.reloadData()
    }

}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city: City
        city = filteredCities[indexPath.row]

        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        if let text = searchBar.text {
            if buttonTag == 1 {
                MyCities.myCity = text
            } else {
                MyCities.myTravelCity = text
            }
            
            self.dismiss(animated: true)
        }
    }
    
    
}

extension CityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
}
