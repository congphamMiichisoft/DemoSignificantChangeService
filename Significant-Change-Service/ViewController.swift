//
//  ViewController.swift
//  Significant-Change-Service
//
//  Created by Phạm Công on 05/05/2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var locationLable: UILabel!
    lazy var tableView: UITableView =  {
        let tableView = UITableView(frame: view.frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let refreshIndicator = UIRefreshControl()
    var listLocation: [LocationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configTableView()
        configData()
    }
    func configTableView(){
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshIndicator.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshIndicator.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshIndicator)
        
    }
    @objc func refresh(){
        refreshIndicator.beginRefreshing()
        configData()
    }
    
    func configData(){
        if let listLocation = RealmManagerUltil.shared.getListLocation(){
            self.listLocation = listLocation
            tableView.reloadData()
            refreshIndicator.endRefreshing()
        }
    }
    


}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let loc = listLocation[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        let stt = listLocation.count - 1 - indexPath.row
        cell.textLabel?.text = "\(stt)\n Lat: \(loc.lat) \n Lon: \(loc.lon) \n Distance: \(round(loc.distanceMove)) \n Speed: \(loc.speed) \n Time: \(loc.time.toString())"
        return cell
    }
}

