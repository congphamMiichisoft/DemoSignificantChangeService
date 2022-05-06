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
    var listFilter: [LocationModel] = []
    var isFilter: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configTableView()
        configData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Significant", style: .plain, target: self, action: #selector(filterLocation))
    }
    
    @objc func filterLocation(){
        isFilter = !isFilter
        tableView.reloadData()
        
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
            listFilter = listLocation.filter({$0.distanceMove > 500})
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
        return isFilter ? listFilter.count : listLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = isFilter ? listFilter : listLocation
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let loc = list[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        let stt = list.count - 1 - indexPath.row
        cell.textLabel?.text = "\(stt)\n Lat: \(loc.lat) \n Lon: \(loc.lon) \n Distance: \(round(loc.distanceMove)) \n Speed: \(loc.speed) \n Time: \(loc.time.toString())"
        if loc.distanceMove > 500 {
            cell.backgroundColor = .red
        }else {
            cell.backgroundColor = .white
        }
        return cell
    }
}

