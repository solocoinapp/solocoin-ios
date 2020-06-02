//
//  HomePage1.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/26/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

class HomePage1: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - IBOUTLETS

    @IBOutlet weak var distancing_time: UILabel!
    
    @IBOutlet var languageOptions: [UIButton]!

    @IBOutlet weak var dailyWeekly: UISegmentedControl!
    
    //MARK: Question/Answer

    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var answer1: UIButton!
    
    @IBOutlet weak var answer2: UIButton!
    
    @IBOutlet weak var answer3: UIButton!
    
    @IBOutlet weak var answer4: UIButton!
    
    //MARK: - DATA
    
    var answerButtons: [UIButton]!
    
    var dailyCorrectAnswer: UIButton!
    
    var weeklyCorrectAnswer: UIButton!
    
    let manager = CLLocationManager()
    
    var dailyQuestion = ""
    var weeklyQuestion = ""
    var dailyOption: [String] = []
    var weeklyOption: [String] = []
    var answers: [[String:String]] = []
    var weeklyAnswers: [[String:String]] = []
    var uuid = ""
    var id_token = ""
    var idDaily = 0
    var idWeekly = 1
    
    //MARK: - FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 900, repeats: true) { timer in
            print("again")
            let url = URL(string: "https://solocoin.herokuapp.com/api/v1/sessions/ping")!
            var request = URLRequest(url: url)
            // Specify HTTP Method to use
            request.httpMethod = "POST"
            //sepcifying header
            let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
            print("a",authtoken)
            request.addValue(authtoken, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //let nowloc = UserDefaults.standard.object(forKey: "nowloc") as! CLLocation
            let nowloc = publicVars.newloc
            let homeloc = publicVars.homeloc
            let diff = self.getBearingBetweenTwoPoints1(point1: nowloc, point2: homeloc)
            if diff > 20{
                let content = ["session":["type":"away"]]
                let jsonEncoder = JSONEncoder()
                if let jsonData = try? jsonEncoder.encode(content),
                    let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    request.httpBody = jsonData
                    let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if error == nil{
                            if let response = response as? HTTPURLResponse {
                                print("loc Response HTTP Status code: \(response.statusCode)")
                                if let data = data{
                                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                        print("location resp",json)
                                    }
                                }
                            }
                        }else{
                            print("no internet connection or smthgn lol, handle this with popup")
                        }
                    }
                    qtask.resume()
                    print("less")
                }
            }else{
                let content = ["session":["type":"home"]]
                let jsonEncoder = JSONEncoder()
                if let jsonData = try? jsonEncoder.encode(content),
                    let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    request.httpBody = jsonData
                    let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if error == nil{
                            if let response = response as? HTTPURLResponse {
                                print("loc Response HTTP Status code: \(response.statusCode)")
                                if let data = data{
                                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                        print("location resp",json)
                                    }
                                }
                            }
                        }
                    }
                    qtask.resume()
                    print("more")
                }
            }
            
            
        }
        
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestLocation()
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            // Handle error
            return;
            }
            self.id_token = idToken!
            UserDefaults.standard.set(self.id_token,forKey: "idtoken")
        }
        uuid=UserDefaults.standard.string(forKey: "uuid")!
        
        answerButtons = [answer1, answer2, answer3, answer4]

        answerLayouts(answer: answer1)
        answerLayouts(answer: answer2)
        answerLayouts(answer: answer3)
        answerLayouts(answer: answer4)
        
        answer1.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
        answer2.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
        answer3.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
        answer4.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
        
        dailyCorrectAnswer = answer1
        weeklyCorrectAnswer = answer2
        
        dailyWeekly.selectedSegmentIndex = 0
        
        let font = UIFont.systemFont(ofSize: 23)
        dailyWeekly.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        userUpdate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //get from api
        obtainDaily()
        obtainWeekly()
        //obtainLeaderBoard()
        obtainProfileInfo()
        //obtainRewards()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            UserDefaults.standard.set("\(location.coordinate.latitude)", forKey: "lat")
            UserDefaults.standard.set("\(location.coordinate.longitude)", forKey: "lng")
            let newloc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //UserDefaults.standard.set(newloc, forKey: "nowloc")
            publicVars.newloc = newloc
            print("Found user's location: \(location)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func userUpdate(){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/user/update")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        //sepcifying header
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        print("a",authtoken)
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let content = ["user":["name": UserDefaults.standard.string(forKey: "username"),"mobile":UserDefaults.standard.string(forKey: "phone"),"lat":UserDefaults.standard.string(forKey: "lat"),"lang":UserDefaults.standard.string(forKey: "long")]]
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(content),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            request.httpBody = jsonData
            let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    if let response = response as? HTTPURLResponse {
                    print("loc Response HTTP Status code: \(response.statusCode)")
                    }
                }
            }
            qtask.resume()
        }
        
    }
    
    func obtainWeekly(){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/questions/weekly")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Bearer \(UserDefaults.standard.string(forKey: "authtoken")!)"
        print("a",authtoken)
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        print("j",json)
                        if let object = json as? [String:AnyObject]{
                            let ans = object["answers"] as! [[String:AnyObject]]
                            var indx=0
                            for ques in ans{
                                let answer = ques["name"] as! String
                                let id = ques["id"] as! Int
                                print("correct",ques["correct"] as? Int)
                                if ques["correct"] as? Int == 1{
                                    print("yup")
                                    self.weeklyCorrectAnswer = self.answerButtons[indx]
                                }
                                let temp = ["name":answer,"id": "\(id)"]
                                self.weeklyAnswers.append(temp)
                            }
                            self.weeklyQuestion = object["name"] as! String
                            self.idWeekly = object["id"] as! Int
                            
                        }
                        }
                    }
                }
            }else{
                print("error",error?.localizedDescription)
            }
        }
        qtask.resume()
    }
    
    func obtainDaily(){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/questions/daily")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Bearer \(UserDefaults.standard.string(forKey: "authtoken")!)"
        print("a",authtoken)
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        print("j",json)
                        if let object = json as? [String:AnyObject]{
                            let ans = object["answers"] as! [[String:AnyObject]]
                            var indx=0
                            for ques in ans{
                                let answer = ques["name"] as! String
                                let id = ques["id"] as! Int
                                print("correct",ques["correct"] as? Int)
                                if ques["correct"] as? Int == 1{
                                    print("yup")
                                    self.dailyCorrectAnswer = self.answerButtons[indx]
                                }
                                let temp = ["name":answer,"id":"\(id)"]
                                self.answers.append(temp)
                                indx+=1
                            }
                            self.dailyQuestion = object["name"] as! String
                            self.idDaily = object["id"] as! Int
                            DispatchQueue.main.async {
                                self.question.text = self.dailyQuestion
                                self.answer1.setTitle(self.answers[0]["name"], for: .normal)
                                self.answer2.setTitle(self.answers[1]["name"], for: .normal)
                                self.answer3.setTitle(self.answers[2]["name"], for: .normal)
                                self.answer4.setTitle(self.answers[3]["name"], for: .normal)
                                
                                self.answerLayouts(answer: self.answer1)
                                self.answerLayouts(answer: self.answer2)
                                self.answerLayouts(answer: self.answer3)
                                self.answerLayouts(answer: self.answer4)
                            }
                            
                        }
                        }
                    }
                }
            }else{
                print("error",error?.localizedDescription)
            }
        }
        qtask.resume()
    }
    
    func obtainProfileInfo(){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/user/profile")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Bearer \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        print("j",json)
                        if let object = json as? [String:AnyObject]{
                            let name = object["name"] as! String
                            UserDefaults.standard.set(name,forKey: "name")
                            let pic = object["profile_picture_url"] as! String
                            UserDefaults.standard.set(pic,forKey: "pic")
                            let wallet_balance = object["wallet_balance"] as! String
                            UserDefaults.standard.set(wallet_balance,forKey: "wallet")
                            let home_duration_in_seconds = object["home_duration_in_seconds"] as! Int
                            UserDefaults.standard.set(home_duration_in_seconds,forKey: "time")
                            let duration = Int(home_duration_in_seconds)
                            let hours = duration/3600
                            let minutes = (duration%3600)/60
                            let message = "\(hours)h : \(minutes)m"
                            DispatchQueue.main.async {
                                self.distancing_time.text = message
                            }
                        }
                        }
                    }
                }
            }else{
                print("error",error?.localizedDescription)
            }
        }
        qtask.resume()
        
    }
    
    /*func obtainLeaderBoard(){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/leaderboard")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Bearer \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        print("L",json)
                        }
                    }
                }
            }
        }
        }*/
    
    
    
    
    func setCorrectAnswer() {
    answerButtons.forEach {
        // Reset the border on each button
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        // Reset the tag on each button
        $0.tag = 0
    }
        answerButtons[1].tag = 1
    }
    
    
    func answerLayouts(answer: UIButton) {
        answer.layer.borderColor = UIColor.systemGray4.cgColor
        answer.layer.borderWidth = 1.0
        answer.layer.cornerRadius = 5.0
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func questionChanged(_ sender: Any) {
        
        if dailyWeekly.selectedSegmentIndex == 0 {
            /*question.text = "What is the best way to minimize the risk of coronavirus?"
            answer1.setTitle("  A. Social Distancing", for: .normal)
            answer2.setTitle("  B. Meeting small, regular groups", for: .normal)
            answer3.setTitle("  C. Continue as usual", for: .normal)
            answer4.setTitle("  D. No clue", for: .normal)*/
            
            question.text = dailyQuestion
            answer1.setTitle(answers[0]["name"], for: .normal)
            answer2.setTitle(answers[1]["name"], for: .normal)
            answer3.setTitle(answers[2]["name"], for: .normal)
            answer4.setTitle(answers[3]["name"], for: .normal)
            
            answerLayouts(answer: answer1)
            answerLayouts(answer: answer2)
            answerLayouts(answer: answer3)
            answerLayouts(answer: answer4)
        }
        
        if dailyWeekly.selectedSegmentIndex == 1 {
            /*question.text = "How long should I wash my hands?"
            answer1.setTitle("  A. Around 5 seconds with soap", for: .normal)
            answer2.setTitle("  B. Around 20 seconds with soap", for: .normal)
            answer3.setTitle("  C. For 15 seconds without soap", for: .normal)
            answer4.setTitle("  D. I shouldn't - it wastes water", for: .normal)*/
            
            question.text = dailyQuestion
            answer1.setTitle(weeklyAnswers[0]["name"], for: .normal)
            answer2.setTitle(weeklyAnswers[1]["name"], for: .normal)
            answer3.setTitle(weeklyAnswers[2]["name"], for: .normal)
            answer4.setTitle(weeklyAnswers[3]["name"], for: .normal)
            
            answerLayouts(answer: answer1)
            answerLayouts(answer: answer2)
            answerLayouts(answer: answer3)
            answerLayouts(answer: answer4)
        
        }
    }
    
    @IBAction func languagePressed(_ sender: UIButton) {
        languageOptions.forEach { (button ) in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func optionPressed(_ sender: UIButton){
        
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/user_questions_answers")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        //sepcifying header
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var questionid = 0
        var answerid = ""
        if dailyWeekly.selectedSegmentIndex == 0{
            questionid = self.idDaily
            answerid = answers[answerButtons.firstIndex(of: sender)!]["id"]!
            if sender == dailyCorrectAnswer{
                print("correct")
            }else{
                print("incorrect")
            }
        }else{
            questionid = self.idWeekly
            answerid = weeklyAnswers[answerButtons.firstIndex(of: sender)!]["id"]!
            if sender == weeklyCorrectAnswer{
                print("correct")
            }else{
                print("incorrect")
            }
        }
        let content = [
            "question_id": questionid,
            "answer_id": Int(answerid)!
            ]
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(content),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            request.httpBody = jsonData
            let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if error == nil{
                        // Read HTTP Response Status code
                        if let response = response as? HTTPURLResponse {
                            print("Response HTTP Status code: \(response.statusCode)")
                            if let data = data{
                                if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                    print("r",json)
                                }
                        }
                    }
                }
            }
            qtask.resume()
        }
        
        
        
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }

}
