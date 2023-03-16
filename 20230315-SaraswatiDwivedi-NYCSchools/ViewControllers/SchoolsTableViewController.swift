//
//  SchoolsTableViewController.swift
//  20230315-SaraswatiDwivedi-NYCSchools
//
//  Created by saraswati.dwivedi on 3/15/23.
//

import UIKit
private let reuseIdentifier = "schoolCell"
private let PAGELIMIT = 20

class SchoolsTableViewController: UITableViewController {
    
    @Published  var schoolArray:[School]=[]
    private var apiService : APIService!
    private var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiService =  APIService()
         self.loadData()
    }
    
    func loadData() {
        Task.init {
            do {
              
                schoolArray = try await apiService.getSchoolsList(offset:self.offset,limit:PAGELIMIT)
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schoolArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
         // create a new cell if needed or reuse an old one
         let cell:SchoolCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! SchoolCell
         
         // set the text from the data model
        cell.schoolNameLabel?.text = schoolArray[indexPath.row].school_name
         
         return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70.0
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SchoolDetailViewController") as!  SchoolDetailViewController
        detailVC.dbn = schoolArray[indexPath.row].dbn
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
