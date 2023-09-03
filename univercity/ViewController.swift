//
//  ViewController.swift
//  univercity
//
//  Created by Akerke on 02.09.2023.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController  {
    
    var universities: [University] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
      setupScene()
        makeConstraints()
       
    }


}

private extension ViewController {
    func setupScene() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        func fetchData() {
            
            let url = "http://universities.hipolabs.com/search?country=United+States"
            
            Alamofire.request(url, method: .get).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let universitiesData = data as? [[String: Any]] {
                        self.universities = universitiesData.compactMap { universityData in
                            return University(name: universityData["name"] as? String ?? "",
                                              country: universityData["country"] as? String ?? "")
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
    }
    
    extension ViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return universities.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell", for: indexPath) as! UniversityTableViewCell
            let university = universities[indexPath.row]
            cell.nameLabel.text = university.name
            cell.countryLabel.text = university.country
            return cell
        }
        
        
    }

