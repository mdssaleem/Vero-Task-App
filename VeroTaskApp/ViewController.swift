//
//  ViewController.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 28/05/24.
//

import UIKit
import RappleProgressHUD



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let refreshControl = UIRefreshControl()
    
    var task_JsonData = [VeroModelClass]()
    var originalTasks: [VeroModelClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Enter you text here"
        self.tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .red
        tableView.refreshControl = refreshControl
        self.getAccessToken()
               
        let searchButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didTapSearchButton))
        self.navigationItem.leftBarButtonItem = searchButton
        navigationController?.navigationBar.tintColor = UIColor.black

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           
            self.getAccessToken()
            
            // End the refreshing
            self.refreshControl.endRefreshing()
        }
    }

          
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task_JsonData.count
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
        let task = task_JsonData[indexPath.row]
        cell.lblTask?.text = task.task
        cell.lblTitle?.text = task.title
        
                if task.description == ""{
                    cell.lblDesc?.text =  "NA"
                }else{
                    cell.lblDesc?.text = task.description
                    cell.lblDesc?.numberOfLines = 2
                }
        cell.colorFillView?.backgroundColor = UIColor(hexString: task.colorCode!)
        cell.colorView?.backgroundColor = UIColor.white//(hexString: task.colorCode!)
        cell.colorView?.layer.cornerRadius = 15
        cell.colorView?.applyShadow()
        cell.colorFillView?.applyShadow()

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = task_JsonData[indexPath.row]
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let fullString = "Parent Task ID : \(task.parentTaskID!)\n\nDescription : \(task.description!)\n\nTask : \(task.task!)\n\nTitle : \(task.title!)\n\nColor Code : \(task.colorCode!)"
        detailView.descString = fullString
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    // UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter tasks based on search text
        task_JsonData = searchText.isEmpty ? originalTasks : originalTasks.filter { $0.title!.localizedCaseInsensitiveContains(searchText) || $0.description!.localizedCaseInsensitiveContains(searchText) ||
            $0.colorCode!.localizedCaseInsensitiveContains(searchText) ||
            $0.task!.localizedCaseInsensitiveContains(searchText) }
        tableView.reloadData()
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
                self.task_JsonData = jsonData!
                self.originalTasks = self.task_JsonData
                self.tableView.reloadData()
                RappleActivityIndicatorView.stopAnimation()
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

