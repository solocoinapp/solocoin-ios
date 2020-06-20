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
    @IBOutlet weak var participate: UILabel!
    
    @IBOutlet weak var errorMssg: UILabel!
    
    @IBOutlet weak var exclMark: UIImageView!
    
    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var inviteHeader: UIView!
    
    @IBOutlet weak var distancing_time: UILabel!
    
    //@IBOutlet var languageOptions: [UIButton]!

    @IBOutlet weak var dailyWeekly: UISegmentedControl!
    
    //MARK: Question/Answer

    @IBOutlet weak var question: UILabel!
    
    /*@IBOutlet weak var answer1: UIButton!
    
    @IBOutlet weak var answer2: UIButton!
    
    @IBOutlet weak var answer3: UIButton!
    
    @IBOutlet weak var answer4: UIButton!*/
    
    @IBOutlet weak var answer1: UILabel!
    
    @IBOutlet weak var answer2: UILabel!
    
    @IBOutlet weak var answer3: UILabel!
    
    @IBOutlet weak var answer4: UILabel!
    
    //MARK: - DATA
    
    //var answerButtons: [UIButton]!
    var answerButtons: [UILabel]!
    var gestures: [UITapGestureRecognizer]!
    //var dailyCorrectAnswer: UIButton!
    var dailyCorrectAnswer: UILabel!
    //var weeklyCorrectAnswer: UIButton!
    var weeklyCorrectAnswer: UILabel!
    
    let manager = CLLocationManager()
    
    var errorWeekly = false
    var erroDaily = false
    
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
    
    //blur
    var blurredEffectView :UIVisualEffectView!
   
    
    //MARK: - FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newuser uncheck
        UserDefaults.standard.set("yay", forKey: "check")
        
        //blur it out
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
        
        //set error handlers
        answer1.adjustsFontSizeToFitWidth = true
        answer2.adjustsFontSizeToFitWidth = true
        answer3.adjustsFontSizeToFitWidth = true
        answer4.adjustsFontSizeToFitWidth = true
        
        exclMark.isHidden = true
        errorMssg.isHidden = true
        setErorrMssg()
        questionView.cornerRadius = questionView.frame.width/25
        dailyWeekly.layer.cornerRadius = questionView.frame.width/25
        questionView.shadowColor = .gray
        questionView.shadowRadius = 8
        questionView.shadowOffset = CGSize(width: 0, height: 2.0)
        //questionView.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        questionView.borderWidth = 2
        questionView.borderColor = .init(red: 205/255, green: 210/255, blue: 218/255, alpha: 1)
        //participate.cornerRadius = 30
        participate.layer.cornerRadius = participate.frame.width/23
        participate.layer.masksToBounds = true
        inviteHeader.layer.cornerRadius = inviteHeader.frame.width/15
        inviteHeader.borderWidth = 5
        inviteHeader
            .borderColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        
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
            let diff = self.getBearingBetweenTwoPoints(point1: homeloc, point2: nowloc)
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
                    print("less",diff)
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
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(optionPressed(_:)))
        answer1.addGestureRecognizer(tap1)
        answer1.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(optionPressed(_:)))
        answer2.addGestureRecognizer(tap2)
        answer2.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(optionPressed(_:)))
        answer3.addGestureRecognizer(tap3)
        answer3.isUserInteractionEnabled = true
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(optionPressed(_:)))
        answer4.addGestureRecognizer(tap4)
        answer4.isUserInteractionEnabled = true
        gestures = [tap1,tap2,tap3,tap4]

        /*answer1.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
        answer2.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
        answer3.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
        answer4.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)*/
        
        //dailyCorrectAnswer = answer1
        //weeklyCorrectAnswer = answer2
        
        dailyWeekly.selectedSegmentIndex = 0
        
        //let font = UIFont.systemFont(ofSize: 23)
        let font = UIFont(name: "Poppins-SemiBold", size: 23)
       // let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)]
        dailyWeekly.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)], for: .normal)
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
    
    func setErorrMssg(){
        exclMark.translatesAutoresizingMaskIntoConstraints = false
        errorMssg.translatesAutoresizingMaskIntoConstraints = false
        
        //exclMark
        NSLayoutConstraint.activate([
            //self.exclMark.topAnchor.constraint(equalTo: self.dailyWeekly.bottomAnchor, constant: 30),
            self.exclMark.heightAnchor.constraint(equalToConstant: self.questionView.frame.height/4),
            self.exclMark.widthAnchor.constraint(equalToConstant: self.questionView.frame.width/4),
            self.exclMark.centerXAnchor.constraint(equalTo: self.questionView.centerXAnchor),
            self.exclMark.centerYAnchor.constraint(equalTo: self.questionView.centerYAnchor)
            //self.exclMark.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            self.errorMssg.topAnchor.constraint(equalTo: self.exclMark.bottomAnchor, constant: 10),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            //self.exclMark.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.errorMssg.leftAnchor.constraint(equalTo: self.questionView.leftAnchor),
            self.errorMssg.rightAnchor.constraint(equalTo: self.questionView.rightAnchor)
        ])
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
        let content = ["user":["name": UserDefaults.standard.string(forKey: "username")!,"mobile":UserDefaults.standard.string(forKey: "phone")!,"lat":"\(publicVars.homeloc.coordinate.latitude)",
            "lang":"\(publicVars.homeloc.coordinate.longitude)"]]//UserDefaults.standard.string(forKey: "long")]]
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
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        print("a",authtoken)
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("weeky Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        self.errorWeekly = false
                        DispatchQueue.main.async {
                            self.question.isHidden = false
                            self.answer1.isHidden = false
                            self.answer2.isHidden = false
                            self.answer3.isHidden = false
                            self.answer4.isHidden = false
                            self.exclMark.isHidden = true
                            self.errorMssg.isHidden = true
                        }
                        print("w",json)
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
                                indx+=1
                            }
                            self.weeklyQuestion = object["name"] as! String
                            self.idWeekly = object["id"] as! Int
                            
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.question.isHidden = true
                            self.answer1.isHidden = true
                            self.answer2.isHidden = true
                            self.answer3.isHidden = true
                            self.answer4.isHidden = true
                            self.exclMark.isHidden = false
                            self.errorMssg.isHidden = false
                            self.setErorrMssg()
                            if self.errorMssg.text != "You've Answered Todays Questions!"{
                                self.errorMssg.text = "You've Answered this Weeks Questions!"
                                self.errorMssg.adjustsFontSizeToFitWidth = true
                            }
                            self.errorWeekly = true
                        }
                        }
                    }
                }
            }else{
                print("error",error?.localizedDescription)
                DispatchQueue.main.async {
                    self.question.isHidden = true
                    self.answer1.isHidden = true
                    self.answer2.isHidden = true
                    self.answer3.isHidden = true
                    self.answer4.isHidden = true
                    self.exclMark.isHidden = false
                    self.errorMssg.isHidden = false
                    self.setErorrMssg()
                    self.errorMssg.adjustsFontSizeToFitWidth = true
                    self.errorMssg.text = "Some error ocurred...."
                    self.errorWeekly = true
                }
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
                    print("daily Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        self.erroDaily = false
                        DispatchQueue.main.async {
                            self.question.isHidden = false
                            self.answer1.isHidden = false
                            self.answer2.isHidden = false
                            self.answer3.isHidden = false
                            self.answer4.isHidden = false
                            self.exclMark.isHidden = true
                            self.errorMssg.isHidden = true
                        }
                        print("d",json)
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
                                self.question.text = "Q. \(self.dailyQuestion)"
                                self.answer1.text = " A. \(self.answers[0]["name"]!)"
                                self.answer2.text = " B. \(self.answers[1]["name"]!)"
                                self.answer3.text = " C. \(self.answers[2]["name"]!)"
                                self.answer4.text = " D. \(self.answers[3]["name"]!)"
                                
                                self.answerLayouts(answer: self.answer1)
                                self.answerLayouts(answer: self.answer2)
                                self.answerLayouts(answer: self.answer3)
                                self.answerLayouts(answer: self.answer4)
                            }
                            
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.question.isHidden = true
                            self.answer1.isHidden = true
                            self.answer2.isHidden = true
                            self.answer3.isHidden = true
                            self.answer4.isHidden = true
                            self.exclMark.isHidden = false
                            self.errorMssg.isHidden = false
                            self.setErorrMssg()
                            self.errorMssg.text = "You've Answered Todays Questions!"
                            self.errorMssg.adjustsFontSizeToFitWidth = true
                            //self.exclMark.image = UIImage(named: "ic_landing_2")
                            //self.exclMark.contentMode = .scaleAspectFill
                            self.erroDaily = true
                        }
                        }
                    }
                }
            }else{
                print("error",error?.localizedDescription)
                DispatchQueue.main.async {
                    self.question.isHidden = true
                    self.answer1.isHidden = true
                    self.answer2.isHidden = true
                    self.answer3.isHidden = true
                    self.answer4.isHidden = true
                    self.exclMark.isHidden = false
                    self.errorMssg.isHidden = false
                    self.setErorrMssg()
                    self.errorMssg.text = "Some error occurred...."
                    self.errorMssg.adjustsFontSizeToFitWidth = true
                    self.erroDaily = true
                }
            }
            DispatchQueue.main.async{
                self.blurredEffectView.removeFromSuperview()
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
                            if let wallet_balance = object["wallet_balance"] as? String{
                                UserDefaults.standard.set("\(wallet_balance)",forKey: "wallet")
                            }else if let wallet_balance = object["wallet_balance"] as? Int{
                                UserDefaults.standard.set("\(wallet_balance)",forKey: "wallet")
                            }
                            let home_duration_in_seconds = object["home_duration_in_seconds"] as! Int
                            UserDefaults.standard.set(home_duration_in_seconds,forKey: "time")
                            let duration = Int(home_duration_in_seconds)
                            if duration<86400{
                                let hours = duration/3600
                                let minutes = (duration%3600)/60
                                let message = "\(hours)h : \(minutes)m"
                                DispatchQueue.main.async {
                                    self.distancing_time.text = message
                                }
                            }else{
                                let days = duration/86400
                                let hours = (duration%86400)/3600
                                let minutes = (duration%3600)/60
                                let message = "\(days)d \(hours)h \(minutes)m"
                                DispatchQueue.main.async {
                                    self.distancing_time.text = message
                                }
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
    
    
    func answerLayouts(answer: UILabel) {
        answer.layer.borderColor = UIColor.systemGray4.cgColor
        answer.layer.borderWidth = 1.0
        answer.layer.cornerRadius = 5.0
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func questionChanged(_ sender: Any) {
        guard erroDaily == false && errorWeekly == false else {
            print("error in segemtn")
            if dailyWeekly.selectedSegmentIndex == 0 {
                self.errorMssg.text = "You've Answered Todays Questions!"
            }else{
                self.errorMssg.text = "You've Answered this Weeks Questions!"
            }
            return
        }
            question.isHidden = false
            answer1.isHidden = false
            answer2.isHidden = false
            answer3.isHidden = false
            answer4.isHidden = false
            exclMark.isHidden = true
            errorMssg.isHidden = true
        if dailyWeekly.selectedSegmentIndex == 0 {
            /*question.text = "What is the best way to minimize the risk of coronavirus?"
            answer1.setTitle("  A. Social Distancing", for: .normal)
            answer2.setTitle("  B. Meeting small, regular groups", for: .normal)
            answer3.setTitle("  C. Continue as usual", for: .normal)
            answer4.setTitle("  D. No clue", for: .normal)*/
            
            question.text = "Q \(dailyQuestion)"
            answer1.text = "  A \(answers[0]["name"] ?? "cudnt get ans")"
            answer2.text = "  B \(answers[1]["name"] ?? "cudnt get ans")"
            answer3.text = "  C \(answers[2]["name"] ?? "cudnt get ans")"
            answer4.text = "  D \(answers[3]["name"] ?? "cudnt get ans")"
            
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
            
            question.text = "Q \(weeklyQuestion)"
            answer1.text = "  A \(weeklyAnswers[0]["name"] ?? "cudnt get ans")"
            answer2.text = "  B \(weeklyAnswers[1]["name"] ?? "cudnt get ans")"
            answer3.text = "  C \(weeklyAnswers[2]["name"] ?? "cudnt get ans")"
            answer4.text = "  D \(weeklyAnswers[3]["name"] ?? "cudnt get ans")"
            
            answerLayouts(answer: answer1)
            answerLayouts(answer: answer2)
            answerLayouts(answer: answer3)
            answerLayouts(answer: answer4)
        
        }
    }
    
   /* @IBAction func languagePressed(_ sender: UIButton) {
        languageOptions.forEach { (button ) in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }*/
    @objc func optionPressed(_ sender: UITapGestureRecognizer){
        
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
            answerid = answers[gestures.firstIndex(of: sender)!]["id"]!//answers[answerButtons.firstIndex(of: sender)!]["id"]!
            if sender == dailyCorrectAnswer{
                print("correct")
                answerButtons[gestures.firstIndex(of: sender)!].borderColor = .green
            }else{
                print("incorrect")
                answerButtons[gestures.firstIndex(of: sender)!].borderColor = .red
            }
        }else{
            questionid = self.idWeekly
            answerid = weeklyAnswers[gestures.firstIndex(of: sender)!]["id"]!
            if sender == weeklyCorrectAnswer{
                print("correct")
                answerButtons[gestures.firstIndex(of: sender)!].borderColor = .green
            }else{
                print("incorrect")
                answerButtons[gestures.firstIndex(of: sender)!].borderColor = .red
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
                            if response.statusCode == 201{
                                print("correct Answer sent!")
                            }else{
                                DispatchQueue.main.async {
                                    self.question.isHidden = true
                                    self.answer1.isHidden = true
                                    self.answer2.isHidden = true
                                    self.answer3.isHidden = true
                                    self.answer4.isHidden = true
                                    self.exclMark.isHidden = false
                                    self.errorMssg.isHidden = false
                                    self.setErorrMssg()
                                    self.errorMssg.text = "You have already Answered this Q!"
                                }
                                
                            }
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

    /*func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }*/
    /*func XXRadiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / M_PI
    }

    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        // Returns a float with the angle between the two points
        let x = point1.coordinate.longitude - point2.coordinate.longitude
        let y = point1.coordinate.latitude - point2.coordinate.latitude

        return fmod(XXRadiansToDegrees(radians: atan2(y, x)), 360.0) + 90.0
    }
*/
    /*func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        // home coordinate
        let uLat: Double = point1.coordinate.latitude
        let uLng: Double = point1.coordinate.longitude
        // new coordinate
        let sLat: Double = point2.coordinate.latitude
        let sLon: Double = point2.coordinate.latitude
        
        let radius: Double = 6371000 // Meters
        let phi_1 = degreesToRadians(degrees: uLat)
        let phi_2 = degreesToRadians(degrees: sLat)
        
        let delta_phi = degreesToRadians(degrees: sLat - uLat)
        let delta_lambda = degreesToRadians(degrees: sLon-uLng)
        
        let a = sin(delta_phi/2.0)*sin(delta_phi/2.0) + cos(phi_1)*cos(phi_2) + sin(delta_lambda/2.0)*sin(delta_lambda/2.0)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let meters = radius*c
        
        return meters
    }*/
    
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        let r = 6371.0  //avg radius of earth inkm
        let dLat = degreesToRadians(degrees: point1.coordinate.latitude-point2.coordinate.latitude)
        let dLng = degreesToRadians(degrees: point1.coordinate.longitude-point2.coordinate.longitude)
        
        let a = sin(dLat/2.0)*sin(dLng/2.0)
        let rest = (cos(degreesToRadians(degrees: point1.coordinate.latitude))*cos(degreesToRadians(degrees: point2.coordinate.longitude))*sin(dLng/2)*sin(dLng/2))
        let total = a+rest
        let c = 2*atan2(sqrt(total), sqrt(1-total))
        
        return (r*c*1000) // in meters
        
    }
    
}
