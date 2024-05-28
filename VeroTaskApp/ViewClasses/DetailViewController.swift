//
//  DetailViewController.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 28/05/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblTask:UILabel?
    var descString:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTask?.text = descString
        lblTask?.numberOfLines = 0
        lblTask?.sizeToFit()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
