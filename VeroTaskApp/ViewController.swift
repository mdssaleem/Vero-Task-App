//
//  ViewController.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 28/05/24.
//

import UIKit
import RappleProgressHUD
import SQLite3
import Alamofire



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    var offline = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let refreshControl = UIRefreshControl()
    var task_JsonData_offline:[VeroModelClassOffline] = []
    var task_JsonData = [VeroModelClass]()
    var originalTasks: [VeroModelClass] = []
    
    var tasks: [VeroModelClassOffline] = []
    var databaseManager:DBHelper = DBHelper()
    var offlineData:[VeroModelClassOffline] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Enter you text to search"
        self.tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .red
        tableView.refreshControl = refreshControl
        if  Connectivity.isConnectedToInternet {
            self.getAccessToken()
        }else{
            offlineData = databaseManager.read()
            task_JsonData_offline = offlineData
            tableView.reloadData()
        }
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didTapSearchButton))
        self.navigationItem.leftBarButtonItem = searchButton
        navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
        
    }
    
    @objc func didTapSearchButton() {
        // Handle the search button tap
        print("Search button tapped")
        
        // Example: Present a search bar or navigate to a search view controller
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @objc func refreshData() {
        // Simulate network request or data refresh
        
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.getAccessToken()
                    self.refreshControl.endRefreshing()
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    ToastView.show(message: "\nNo Internet connection!\n", inView: self.view)
                    self.refreshControl.endRefreshing()
                }
            }
            
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Connectivity.isConnectedToInternet {
            return task_JsonData.count
        }else{
            return offlineData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.selectionStyle = .none
        
        cell.colorView?.frame = CGRect(x: 10, y: 10, width: cell.contentView.frame.size.width-20, height: cell.contentView.frame.size.height-20)
        cell.colorFillView?.frame = CGRect(x: cell.contentView.frame.size.width-60, y: (cell.contentView.frame.size.height-50)/2, width: 30, height: 30)
        cell.lblTask?.frame = CGRect(x: 8, y: 8, width: cell.contentView.frame.size.width-50, height: 15)
        cell.lblTitle?.frame = CGRect(x: 8, y: 30, width: cell.contentView.frame.size.width-50, height: 15)
        cell.lblDesc?.frame = CGRect(x: 8, y: 55, width: cell.contentView.frame.size.width-70, height: 30)
        cell.colorFillView?.layer.cornerRadius = 5
        cell.colorFillView?.layer.borderWidth = 0.6
        cell.colorFillView?.layer.borderColor = UIColor.darkGray.cgColor
        
        if Connectivity.isConnectedToInternet{
            let task = task_JsonData[indexPath.row]
            cell.lblTask?.text = task.task
            cell.lblTitle?.text = task.title
            cell.colorFillView?.backgroundColor = UIColor(hexString: task.colorCode!)
            
            if task.description == ""{
                cell.lblDesc?.text =  "NA"
            }else{
                cell.lblDesc?.text = task.description
                cell.lblDesc?.numberOfLines = 2
            }
        }else{
            let task = offlineData[indexPath.row]
            cell.lblTask?.text = task.taskString
            cell.lblTitle?.text = task.nameString
            cell.colorFillView?.backgroundColor = UIColor(hexString: task.imgUrlString)
            
            if task.descriptionString == ""{
                cell.lblDesc?.text =  "NA"
            }else{
                cell.lblDesc?.text = task.descriptionString
                cell.lblDesc?.numberOfLines = 2
            }
        }
        
        
        cell.colorView?.backgroundColor = UIColor.white
        cell.colorView?.layer.cornerRadius = 15
        cell.colorView?.applyShadow()
        cell.colorFillView?.applyShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Connectivity.isConnectedToInternet{
            let task = task_JsonData[indexPath.row]
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            let fullString = "Parent Task ID : \(task.parentTaskID!)\n\nDescription : \(task.description!)\n\nTask : \(task.task!)\n\nTitle : \(task.title!)\n\nColor Code : \(task.colorCode!)"
            detailView.descString = fullString
            self.navigationController?.pushViewController(detailView, animated: true)
            
        }else{
            let task = offlineData[indexPath.row]
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            let fullString = "Parent Task ID : \n\nDescription : \(task.descriptionString)\n\nTask : \(task.taskString)\n\nTitle : \(task.nameString)\n\nColor Code : \(task.imgUrlString)"
            detailView.descString = fullString
            self.navigationController?.pushViewController(detailView, animated: true)
            
        }
        
    }
    
    // UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter tasks based on search text
        if Connectivity.isConnectedToInternet{
            task_JsonData = searchText.isEmpty ? originalTasks : originalTasks.filter { $0.title!.localizedCaseInsensitiveContains(searchText) || $0.description!.localizedCaseInsensitiveContains(searchText) ||
                $0.colorCode!.localizedCaseInsensitiveContains(searchText) ||
                $0.task!.localizedCaseInsensitiveContains(searchText) }
            tableView.reloadData()
        }else{
                self.offlineData = searchText.isEmpty ? self.task_JsonData_offline : self.task_JsonData_offline.filter { $0.nameString.localizedCaseInsensitiveContains(searchText) || $0.descriptionString.localizedCaseInsensitiveContains(searchText) ||
                    $0.imgUrlString.localizedCaseInsensitiveContains(searchText) ||
                    $0.taskString.localizedCaseInsensitiveContains(searchText) }
                self.tableView.reloadData()
                

            
        }
    }
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //=========================API Calling Here==========================================
    
    
    
    func getAccessToken() -> (Void) {
        let parameterDict =  [
            "username":NetWorkingConstants.username,
            "password":NetWorkingConstants.password
        ]
        RappleActivityIndicatorView.startAnimating()
        APIManagerClass.get_Token_Data(information: parameterDict) { access_token in
            
            if let token = access_token, !token.isEmpty {
                print(token)
                self.get_Task_Data(access_token: token)
                
            }
        }
        
    }
    
    func get_Task_Data(access_token:String?) -> (Void) {
        
        
        APIManagerClass.get_Task_Data(token: access_token) { jsonData in
            
            if jsonData!.count > 0{
                ToastView.show(message: "\nData fetched successfully!\n", inView: self.view)
                self.databaseManager.deleteAllTasks()
                self.task_JsonData = jsonData!
                self.originalTasks = self.task_JsonData
                
                
                for taskData in self.task_JsonData{
                    self.databaseManager.insert(id: 0, name: taskData.title ?? "", overview: taskData.description ?? "", image: taskData.colorCode ?? "", task: taskData.task ?? "")
                    self.offlineData = self.databaseManager.read()
                }
                self.task_JsonData_offline = self.offlineData
                RappleActivityIndicatorView.stopAnimation()
                self.tableView.reloadData()
                
            }else{
                let alert = UIAlertController(title: "Alert!", message: "Something went wrong, Please Pull to refresh", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                    print("action pressed")
                }))
                self.present(alert, animated: true)
                RappleActivityIndicatorView.stopAnimation()
                
            }
        }
    }
    
    
    
}


