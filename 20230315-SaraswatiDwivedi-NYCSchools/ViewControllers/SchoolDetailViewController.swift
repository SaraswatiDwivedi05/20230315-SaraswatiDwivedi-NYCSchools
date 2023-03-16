//
//  SchoolDetailViewController.swift
//  20230315-SaraswatiDwivedi-NYCSchools
//
//  Created by saraswati.dwivedi on 3/15/23.
//

import UIKit

class SchoolDetailViewController: UIViewController {
    var dbn : String!="02M260"
    private var apiService : APIService!
    @Published  var schoolData:[School] = []
    @Published  var schoolSATData:[SchoolSAT] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var testTakerLabel: UILabel!
    @IBOutlet weak var mathScoreLabel: UILabel!
    @IBOutlet weak var readingScoreLabel: UILabel!
    @IBOutlet weak var writingScoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiService =  APIService()
        self.loadData()
    }
    
    func loadData() {
        Task.init {
            do {
                schoolData = try await apiService.getSchoolDetail(dbn: dbn)
                schoolSATData = try await apiService.getSchoolSATResults(dbn: dbn)
                fillData()
            } catch {
                print(error)
            }
        }
    }

    func fillData() {
        if !schoolData.isEmpty {
           titleLabel.text=schoolData[0].school_name
            addressLabel.text=schoolData[0].location
            websiteLabel.text=schoolData[0].website
            emailLabel.text=schoolData[0].school_email
            phoneLabel.text=schoolData[0].phone_number
            gradeLabel.text=schoolData[0].finalgrades
            descriptionLabel.text = schoolData[0].overview_paragraph
            
//            guard let number = URL(string: "tel://" + schoolData[0].phone_number!) else { return }
//            UIApplication.shared.open(number)
        }
        
        if !schoolSATData.isEmpty {
            testTakerLabel.text=schoolSATData[0].num_of_sat_test_takers
            mathScoreLabel.text=schoolSATData[0].sat_math_avg_score
            readingScoreLabel.text=schoolSATData[0].sat_critical_reading_avg_score
            writingScoreLabel.text=schoolSATData[0].sat_writing_avg_score
        }
    }
}

