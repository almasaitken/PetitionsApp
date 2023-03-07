//
//  ViewController.swift
//  Project7_reedo
//
//  Created by Almas Aitken on 06.01.2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetition))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearFilter))
        
        title = "US Petitions"
        
        performSelector(inBackground: #selector(fetchData), with: nil)
        
    }
    
    @objc func fetchData() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let petitionsData = try? Data(contentsOf: url) {
                convertToJson(petitionsData)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func searchPetition() {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Find", style: .default) {
            [weak ac, weak self] _ in
            guard let searchWord = ac?.textFields?[0].text else { return }
            self?.performSelector(inBackground: #selector(self?.filter), with: searchWord)
        })
        present(ac, animated: true)
    }
    
    @objc func filter(_ word: String) {
        let lowercased = word.lowercased()
        filteredPetitions.removeAll(keepingCapacity: true)
        for petition in petitions {
            if petition.title.lowercased().contains(lowercased) || petition.body.lowercased().contains(lowercased) {
                filteredPetitions.append(petition)
            }
        }
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func clearFilter() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    func convertToJson(_ data: Data) {
        let decoder = JSONDecoder()
        if let json = try? decoder.decode(Petitions.self, from: data) {
            petitions = json.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            return
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Unable to retrieve data from the source", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
        cell.textLabel?.text = filteredPetitions[indexPath.row].title
        cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.petition = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
