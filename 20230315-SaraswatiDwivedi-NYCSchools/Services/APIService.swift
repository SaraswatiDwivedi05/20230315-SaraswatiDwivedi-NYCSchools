//
//  APIService.swift
//  20230315-SaraswatiDwivedi-NYCSchools
//
//  Created by saraswati.dwivedi on 3/15/23.
//

import Foundation

class APIService :  NSObject {
    
    private let baseURLString = "https://data.cityofnewyork.us/resource/"

    func apiToGetSchoolsList(completion : @escaping ([School]) -> ()){
        let sourcesURL = URL(string:baseURLString + "s3k6-pzi2.json?$select=dbn,school_name")!
            URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
                if let data = data {
                    
                    let jsonDecoder = JSONDecoder()
                    
                    let schoolArray = try! jsonDecoder.decode([School].self, from: data)
                        completion(schoolArray)
                }
            }.resume()
        }
    
    
    func getSchoolsList(offset:Int,limit:Int) async throws->[School] {
//        guard let url =  URL(string:baseURLString + "s3k6-pzi2.json?$limit=\(limit)&$offset=\(offset)&$select=dbn,school_name") else { fatalError("Missing URL") }
        guard let url =  URL(string:baseURLString + "s3k6-pzi2.json?$select=dbn,school_name") else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedSchoolList = try JSONDecoder().decode([School].self, from: data)
//        print("Async decodedSchoolList", decodedSchoolList)
        return decodedSchoolList;
    }
    
    func getSchoolDetail(dbn:String) async throws->[School] {
        let urlString=baseURLString+"s3k6-pzi2.json?$where=dbn=\"\(dbn)\"&$select=dbn,school_name,overview_paragraph,location,phone_number,school_email,website,subway,bus,finalgrades,total_students,start_time,end_time,addtl_info1,psal_sports_boys,psal_sports_girls,psal_sports_coed,graduation_rate,attendance_rate,pct_stu_safe,pct_stu_enough_variety,college_career_rate,school_accessibility_description,city"
        
        let newURl = urlString.addingPercentEncoding(withAllowedCharacters:  .urlQueryAllowed)!
        
        guard let url =  URL(string:newURl) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedSchoolData = try JSONDecoder().decode([School].self, from: data)
//        print("Async decodedSchoolData", decodedSchoolData)
        return decodedSchoolData ;
    }
    
    func getSchoolSATResults(dbn:String) async throws->[SchoolSAT] {
        let urlString=baseURLString+"f9bf-2cp4.json?$where=dbn=\"\(dbn)\""
        
        let newURl = urlString.addingPercentEncoding(withAllowedCharacters:  .urlQueryAllowed)!
        
        guard let url =  URL(string:newURl) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            let decodedSchoolData = try JSONDecoder().decode([SchoolSAT].self, from: data)
//        print("Async decodedSchoolData", decodedSchoolData)
        return decodedSchoolData ;
    }
}
