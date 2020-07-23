//
//  HomeCollectionReusableView.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 7/16/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth

class HomeCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "headerIde"
    
    @IBOutlet weak var participate: UILabel!
    
    @IBOutlet weak var errorMssg: UILabel!
    
    @IBOutlet weak var exclMark: UIImageView!
    
    @IBOutlet weak var questionView: UIView!
    
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
    
    @IBOutlet weak var scratcHeader: UILabel!
    
    
    //copy from here
    var answerButtons: [UILabel]!
    var gestures: [UITapGestureRecognizer]!
    var dailyCorrectAnswer: UILabel!
    var weeklyCorrectAnswer: UILabel!
    var dailyQuestion = ""
    var weeklyQuestion = ""
    var answers: [[String:String]] = []
    var weeklyAnswers: [[String:String]] = []
    var uuid = "" //uuid and id to be independednt from parentview
    var id_token = ""
    var idDaily = 0
    var idWeekly = 1
    var errorWeekly = false
    var erroDaily = false
    
    var blurredEffectView :UIVisualEffectView!
    
    func setup(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            // Handle error
            return;
            }
            self.id_token = idToken!
            UserDefaults.standard.set(self.id_token,forKey: "idtoken")
        }
        scratcHeader.adjustsFontSizeToFitWidth = true
        dailyWeekly.selectedSegmentTintColor = .white
        uuid=UserDefaults.standard.string(forKey: "uuid")!
        self.questionView.borderWidth = 2
        self.questionView.borderColor = .init(red: 205/255, green: 210/255, blue: 218/255, alpha: 1)
        //participate.cornerRadius = 30
        self.participate.layer.cornerRadius = self.participate.frame.width/23
        self.participate.layer.masksToBounds = true
       self.answerButtons = [self.answer1, self.answer2, self.answer3, self.answer4]
       self.answerLayouts(answer: self.answer1)
       self.answerLayouts(answer: self.answer2)
       self.answerLayouts(answer: self.answer3)
       self.answerLayouts(answer: self.answer4)
       let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
       self.answer1.addGestureRecognizer(tap1)
       self.answer1.isUserInteractionEnabled = true
       let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
       self.answer2.addGestureRecognizer(tap2)
       self.answer2.isUserInteractionEnabled = true
       let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
       self.answer3.addGestureRecognizer(tap3)
       self.answer3.isUserInteractionEnabled = true
       let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
       self.answer4.addGestureRecognizer(tap4)
       self.answer4.isUserInteractionEnabled = true
       self.gestures = [tap1,tap2,tap3,tap4]
       self.answer1.adjustsFontSizeToFitWidth = true
       self.answer2.adjustsFontSizeToFitWidth = true
       self.answer3.adjustsFontSizeToFitWidth = true
       self.answer4.adjustsFontSizeToFitWidth = true
       self.exclMark.isHidden = true
       self.errorMssg.isHidden = true
       self.questionView.cornerRadius = self.questionView.frame.width/25
       self.dailyWeekly.layer.cornerRadius = self.questionView.frame.width/25
       self.questionView.shadowColor = .gray
       self.questionView.shadowRadius = 8
       self.questionView.shadowOffset = CGSize(width: 0, height: 2.0)
       let blurEffect = UIBlurEffect(style: .extraLight)
       blurredEffectView = UIVisualEffectView(effect: blurEffect)
       blurredEffectView.frame = self.bounds
       self.addSubview(blurredEffectView)
       obtainDaily()
       obtainWeekly()
       let font = UIFont(name: "Poppins-SemiBold", size: 23)
                          self.dailyWeekly.selectedSegmentIndex = 0
                          self.dailyWeekly.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)], for: .normal)
    }
    
    func answerLayouts(answer: UILabel) {
        answer.layer.borderColor = UIColor.systemGray4.cgColor
        answer.layer.borderWidth = 1.0
        answer.layer.cornerRadius = 5.0
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
                            /*self.question.isHidden = true
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
                            }*/
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
                    self.exclMark.alpha = 0
                    self.errorMssg.isHidden = false
                    self.errorMssg.alpha = 0
                    self.setErorrMssg()
                    self.errorMssg.adjustsFontSizeToFitWidth = true
                    self.errorMssg.text = "Some error ocurred...."
                    UIView.animate(withDuration: 2) {
                        self.exclMark.alpha = 1
                        self.errorMssg.alpha = 1
                    }
                    
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
                        print("here aaa")
                        DispatchQueue.main.async {
                            self.question.isHidden = true
                            self.answer1.isHidden = true
                            self.answer2.isHidden = true
                            self.answer3.isHidden = true
                            self.answer4.isHidden = true
                            self.exclMark.isHidden = false
                            self.errorMssg.isHidden = false
                            self.setErorrMssg()
                            self.exclMark.alpha = 0
                            self.errorMssg.alpha = 0
                            self.errorMssg.text = "You've Answered Todays Questions!"
                            self.errorMssg.adjustsFontSizeToFitWidth = true
                            UIView.animate(withDuration: 2) {
                                self.exclMark.alpha = 1
                                self.errorMssg.alpha = 1
                            }
                            
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
                    self.exclMark.alpha = 0
                    self.errorMssg.alpha = 0
                    UIView.animate(withDuration: 2) {
                        self.exclMark.alpha = 1
                        self.errorMssg.alpha = 1
                        
                    }
                    
                    self.erroDaily = true
                }
            }
            DispatchQueue.main.async{
                self.blurredEffectView.removeFromSuperview()
            }
        }
        qtask.resume()
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
    
    @IBAction func questionChanged(_ sender: Any) {
        /*guard erroDaily == false && errorWeekly == false else {
            print(erroDaily,errorWeekly)
            print("error in segemtn")
            if dailyWeekly.selectedSegmentIndex == 0 {
                self.errorMssg.text = "You've Answered Todays Questions!"
            }else{
                self.errorMssg.text = "You've Answered this Weeks Questions!"
            }
            return
        }*/
            question.isHidden = false
            answer1.isHidden = false
            answer2.isHidden = false
            answer3.isHidden = false
            answer4.isHidden = false
            exclMark.isHidden = true
            errorMssg.isHidden = true
        if dailyWeekly.selectedSegmentIndex == 0 {
            guard erroDaily == false else {
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
                    self.exclMark.alpha = 0
                    self.errorMssg.alpha = 0
                    UIView.animate(withDuration: 2) {
                        self.exclMark.alpha = 1
                        self.errorMssg.alpha = 1
                        
                    }
                    
                    //self.exclMark.image = UIImage(named: "ic_landing_2")
                    //self.exclMark.contentMode = .scaleAspectFill
                }
                return
            }
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
            guard errorWeekly == false else {
               DispatchQueue.main.async {
                self.exclMark.alpha = 0
                self.errorMssg.alpha = 0
                self.question.isHidden = true
                self.answer1.isHidden = true
                self.answer2.isHidden = true
                self.answer3.isHidden = true
                self.answer4.isHidden = true
                self.exclMark.isHidden = false
                self.errorMssg.isHidden = false
                self.setErorrMssg()
                self.errorMssg.text = "You've Answered this Week's Questions!"
                self.errorMssg.adjustsFontSizeToFitWidth = true
                UIView.animate(withDuration: 2) {
                    self.exclMark.alpha = 1
                    self.errorMssg.alpha = 1
                    
                }
                   
                   //self.exclMark.image = UIImage(named: "ic_landing_2")
                   //self.exclMark.contentMode = .scaleAspectFill
                   self.erroDaily = true
               }
                return
            }
            self.question.isHidden = false
            self.answer1.isHidden = false
            self.answer2.isHidden = false
            self.answer3.isHidden = false
            self.answer4.isHidden = false
            self.exclMark.isHidden = true
            self.errorMssg.isHidden = true
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
                print("ansnn",answerid,gestures.firstIndex(of: sender)!)
                if answerButtons[gestures.firstIndex(of: sender)!] == dailyCorrectAnswer{
                    print("correct")
                    answerButtons[gestures.firstIndex(of: sender)!].borderColor = .green
                }else{
                    print("incorrect")
                    answerButtons[gestures.firstIndex(of: sender)!].borderColor = .red
                }
            }else{
                questionid = self.idWeekly
                answerid = weeklyAnswers[gestures.firstIndex(of: sender)!]["id"]!
                if answerButtons[gestures.firstIndex(of: sender)!] == weeklyCorrectAnswer{
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
                                        self.errorMssg.alpha = 0
                                        self.exclMark.alpha = 0
                                        self.setErorrMssg()
                                        self.errorMssg.text = "You have already Answered this Q!"
                                        UIView.animate(withDuration: 2) {
                                            self.errorMssg.alpha = 1
                                            self.exclMark.alpha = 1
                                        }
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
    
    
    /*var answerButtons: [UILabel]!
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
    
    var blurredEffectView :UIVisualEffectView!
    
    func setup(){
        self.answerButtons = [self.answer1, self.answer2, self.answer3, self.answer4]
        self.answerLayouts(answer: self.answer1)
        self.answerLayouts(answer: self.answer2)
        self.answerLayouts(answer: self.answer3)
        self.answerLayouts(answer: self.answer4)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
        self.answer1.addGestureRecognizer(tap1)
        self.answer1.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
        self.answer2.addGestureRecognizer(tap2)
        self.answer2.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
        self.answer3.addGestureRecognizer(tap3)
        self.answer3.isUserInteractionEnabled = true
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
        self.answer4.addGestureRecognizer(tap4)
        self.answer4.isUserInteractionEnabled = true
        self.gestures = [tap1,tap2,tap3,tap4]
        /*let blurEffect = UIBlurEffect(style: .extraLight)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        self.addSubview(blurredEffectView)*/
        obtainDaily()
        obtainWeekly()
        obtainProfileInfo{
            print("profile done")
            self.userUpdate()
        }
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
        let content = ["user":["name": publicVars.username,"mobile":UserDefaults.standard.string(forKey: "phone")!,"lat":"\(publicVars.homeloc.coordinate.latitude)",
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
        }else{
            print("no send")
        }
        
    }
    
    
    func answerLayouts(answer: UILabel) {
        answer.layer.borderColor = UIColor.systemGray4.cgColor
        answer.layer.borderWidth = 1.0
        answer.layer.cornerRadius = 5.0
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
                //self.blurredEffectView.removeFromSuperview()
            }
        }
        qtask.resume()
    }
    
    func obtainProfileInfo(completion:@escaping ()->()){
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
                            publicVars.username = name
                            UserDefaults.standard.set(name,forKey: "name")
                            let pic = object["profile_picture_url"] as! String
                            UserDefaults.standard.set(pic,forKey: "pic")
                            if let wallet_balance = object["wallet_balance"] as? String{
                                UserDefaults.standard.set("\(wallet_balance)",forKey: "wallet")
                            }else if let wallet_balance = object["wallet_balance"] as? Int{
                                UserDefaults.standard.set("\(wallet_balance)",forKey: "wallet")
                            }
                            /*guard let lat = object["lat"] as? NSString else{
                                print(object["lat"])
                                print("nope lat")
                                return
                            }
                            guard let lang = object["lng"] as? NSString else {
                                print("nope lang")
                               return
                            }*/
                            let lat = object["lat"] as? NSString ?? "37.785834"
                            let lang = object["lng"] as? NSString ?? "-122.406417"
                            let location = CLLocation(latitude: CLLocationDegrees(exactly: lat.doubleValue)!, longitude: CLLocationDegrees(exactly: lang.doubleValue)!)
                            publicVars.homeloc = location
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
            completion()
        }
        qtask.resume()
        
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
         
         
         
     }*/
    
}
