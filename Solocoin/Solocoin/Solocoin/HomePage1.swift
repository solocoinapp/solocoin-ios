//
//  HomePage1.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/26/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//remember to change nope lat and nope lang for prod

import UIKit
import FirebaseAuth
import CoreLocation
import UserNotifications
import SDWebImage
import SkeletonView
//import GLScratchCard

class HomePage1: UIViewController, CLLocationManagerDelegate, GLScratchCardDelegate {
    
    
    
    
    //MARK: - IBOUTLETS
    /*@IBOutlet weak*/ var participate: UILabel!
    
    /*@IBOutlet weak*/ var errorMssg: UILabel!
    
    /*@IBOutlet weak*/ var exclMark: UIImageView!
    
    /*@IBOutlet weak*/ var questionView: UIView!
    
    /*@IBOutlet weak*/ var inviteHeader: UIView!
    
    /*@IBOutlet weak*/ var distancing_time: UILabel!
    var distancingMsg = ""
    
    ///*@IBOutlet*/ var languageOptions: [UIButton]!

    /*@IBOutlet weak*/ var dailyWeekly: UISegmentedControl!
    
    //MARK: Question/Answer

    /*@IBOutlet weak*/ var question: UILabel!
    
    /*/*@IBOutlet*/ weak var answer1: UIButton!
    
    /*@IBOutlet*/ weak var answer2: UIButton!
    
    /*@IBOutlet*/ weak var answer3: UIButton!
    
    /*@IBOutlet*/ weak var answer4: UIButton!*/
    
    /*@IBOutlet weak*/ var answer1: UILabel!
    
    /*@IBOutlet weak*/ var answer2: UILabel!
    
    /*@IBOutlet weak*/ var answer3: UILabel!
    
    /*@IBOutlet weak*/ var answer4: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
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
    
    var a = 0
   
    //scratchcards
    var scratchList = [[String:Any]]()
    var controller = GLScratchCardController()
    
    var currentScratch = [String: Any]()
    
    //MARK: - FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newuser uncheck
        self.collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
         //collectionView.dataSource = self
        //self.collectionView.dataSource = self
        self.collectionView.register(scratchCollectionViewCell.self, forCellWithReuseIdentifier: "scratchCell")
        self.collectionView.register(PlaceHolderScratchCardCollectionViewCell.self, forCellWithReuseIdentifier: "noScratch")
        self.collectionView.collectionViewLayout = createCustomLayout()
        self.configureDataSource()
        configureCollectionView()
        
        self.navigationController?.isNavigationBarHidden = true
        UserDefaults.standard.set("yay", forKey: "check")
        getScratch{
            print("done")
            DispatchQueue.main.async {
                print("sds")
                
                self.blurredEffectView.removeFromSuperview()
                self.collectionView.collectionViewLayout = self.createCustomLayout()
                self.collectionView.reloadData()
                //self.collectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
                //self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                //self.configureDataSource()
            }
            
        }
        //blur it out
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
        
        //set error handlers
        /*answer1.adjustsFontSizeToFitWidth = true
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
            .borderColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)*/
        
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
            if self.a==0{
                if diff > 20{
                    let content = ["session":["type":"away"]]
                    print("sess",content)
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
                    print("sess",content)
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
                self.a+=1
            }else{
                if UIApplication.shared.applicationState == .active{
                    if diff > 20{
                        let content = ["session":["type":"away"]]
                        print("sess",content)
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
                        print("sess",content)
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
                }else{
                    self.showNotification(title: "Solocoin Check-In", message: "Please click on the notification to confirm your presence")
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
        
        /*answerButtons = [answer1, answer2, answer3, answer4]

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
        
        dailyWeekly.selectedSegmentIndex = 0*/
        
        //collectionView Stuff
        //collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCustomLayout())
        //self.collectionView.delegate = self
        
        //configureDataSource()
        
        //let font = UIFont.systemFont(ofSize: 23)
        /*let font = UIFont(name: "Poppins-SemiBold", size: 23)
       // let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)]
        dailyWeekly.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)], for: .normal)*/
        
        obtainProfileInfo{
            print("profile done")
            self.userUpdate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //get from api
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = false
        }
        //obtainDaily()
        //obtainWeekly()
        
        //obtainLeaderBoard()
        //obtainRewards()
    }
    
    
    func configureCollectionView() {
        print("configure empty")
        /*collectionView.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(collectionView)
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.participate.bottomAnchor, constant: 10),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])*/
    }
    
    
    func createCustomLayout() -> UICollectionViewLayout {
        
        if self.scratchList.count == 0{
            print("noe")
            let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                      let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                      leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                      
                let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.08))
                      let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitem: leadingItem, count: 1)
                      
                      let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.3))
                      
                      let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup])
            
                      
                      /*let section = NSCollectionLayoutSection(group: containerGroup)
                      section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)*/
                     let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(642))
                     let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                     
                     let section = NSCollectionLayoutSection(group: leadingGroup)
                     section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                     section.boundarySupplementaryItems = [sectionHeader]
                     
                     //5
                     let spacing = CGFloat(20)
                     leadingGroup.interItemSpacing = .fixed(spacing)
                     section.interGroupSpacing = spacing
                      
                      return section
                  }
                  return layout
        }else{
            print("many availabel")
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //3
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item, count: 2)
            //group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            //4
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(642))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [sectionHeader]
            
            //5
            let spacing = CGFloat(20)
            group.interItemSpacing = .fixed(spacing)
            section.interGroupSpacing = spacing
            
            //6
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
       return UICollectionViewLayout()
    }
    
    func sendUpdate(){
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
            print("sess",content)
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
        a=0
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
    
    func getScratch(completion:@escaping () -> ()){
        self.scratchList.removeAll()
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/rewards_sponsors/scratch_cards")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if response.statusCode == 200{
                        if let data = data{
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                            print("B",json)
                            if let object = json as? [[String:AnyObject]]{
                                for card in object{
                                    let id = card["id"] as! Int
                                    let name = card["offer_name"] as! String
                                    let amount = card["offer_amount"] as? Int ?? 0
                                    let company = card["company_name"] as! String
                                    let tandc = card["terms_and_conditions"] as! String
                                    let coins = card["coins"] as? Int ?? 0
                                    let code = card["coupon_code"] as? String ?? "nil"
                                    let logoUrl = card["brand_logo_url"] as! String
                                    let category = card["category"] as! [String: Any]
                                    let cat = category["name"] as! String
                                    self.scratchList.append(["id":"\(id)","company":company,"offer_name":name,"offer_amount":amount,"terms":tandc,"coins":coins,"coupon_code":code,"imgurl":logoUrl,"category":cat])
                                    /*null detection
                                     if let img = badge["badge_image_url"] as? NSNull{
                                        self.levelInfo.append(["level":level,"points":min_coins,"name":name,"oneline":oneline,"imgurl":"null"])
                                    }else{
                                        let imgurl = badge["badge_image_url"] as! String
                                        self.levelInfo.append(["level":level,"points":min_coins,"name":name,"oneline":oneline,"imgurl":imgurl])
                                    }*/
                                    
                            }
                            completion()
                        }
                        }
                    }
                    
                    }else{
                        print("scratch error")
                        /*print("eroor",error?.localizedDescription)
                        self.performSegue(withIdentifier: "errorPage", sender: nil)*/
                    }
            }else{
                print("scratch error")
            }
        }
        }
        qtask.resume()
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
                        print(" update loc Response HTTP Status code: \(response.statusCode)")
                    }
                }
            }
            qtask.resume()
        }else{
            print("no send")
        }
        
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
                                    //self.distancingMsg = message
                                }
                            }else{
                                let days = duration/86400
                                let hours = (duration%86400)/3600
                                let minutes = (duration%3600)/60
                                let message = "\(days)d \(hours)h \(minutes)m"
                                DispatchQueue.main.async {
                                    self.distancing_time.text = message
                                    //self.distancingMsg = message
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
    
    
    /*func obtainWeekly(){
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
    
    */
    
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
    
    private func configureDataSource() {
        print("scratch",self.scratchList.count)
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: self.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            guard self.scratchList.count != 0 else {
                print("mo scratch cards")
                guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "noScratch", for: indexPath) as? PlaceHolderScratchCardCollectionViewCell else{
                    print("no extra cell?")
                    return UICollectionViewCell()
                }
                cell.setup()
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scratchCell", for: indexPath) as? scratchCollectionViewCell else{
                print("no cell?")
                return UICollectionViewCell()
            }
            cell.setup()
                /*cell.scratchTemp.sd_setImage(with: URL(string: "https://solocoin.herokuapp.com/\(self.scratchList[indexPath.section*2 + indexPath.row]["imgurl"] as! String)")) { (image, error, cache, url) in
                    if error == nil{
                        print("got card image")
                    }else{
                        cell.scratchTemp.image = UIImage(named: "scratch")!
                        print("putting in default card image")
                        
                    }
                    /*cell.levelName.text = self.scratchList[indexPath.section*2 + indexPath.row]["company"] as! String
                    cell.level.text = "\(self.scratchList[indexPath.section*2 + indexPath.row]["coins"] as! Int)"*/
                }*/
            cell.scratchTemp.image = UIImage(named: "scratch")!
                return cell
        }
        
        dataSource?.supplementaryViewProvider = {
            (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath
            ) -> UICollectionReusableView? in
                
                // Get a supplementary view of the desired kind.
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: HomeCollectionReusableView.identifier,
                        for: indexPath) as? HomeCollectionReusableView else { fatalError("Cannot create new supplementary") }
                    
                    headerView.setup()
                    self.distancing_time = headerView.distancing_time
                    
                    /*self.answer1 = headerView.answer1
                    self.answer2 = headerView.answer2
                    self.answer3 = headerView.answer3
                    self.answer4 = headerView.answer4
                    self.question = headerView.question
                    self.dailyWeekly = headerView.dailyWeekly
                    self.questionView = headerView.questionView
                    self.distancing_time = headerView.distancing_time
                    self.exclMark = headerView.exclMark
                    self.errorMssg = headerView.errorMssg
                    self.participate = headerView.participate
                    self.weeklyAnswers = headerView.weeklyAnswers
                    self.answers = headerView.answers
                    self.answerButtons = headerView.answerButtons
                    self.gestures = headerView.gestures
                    self.dailyCorrectAnswer = headerView.dailyCorrectAnswer
                    self.weeklyCorrectAnswer = headerView.weeklyCorrectAnswer
                    //self.manager = headerView.manager
                    self.errorWeekly = headerView.errorWeekly
                    self.erroDaily = headerView.erroDaily
                    self.dailyQuestion = headerView.dailyQuestion
                    self.weeklyQuestion = headerView.weeklyQuestion
                    self.uuid = headerView.uuid
                    self.id_token = headerView.id_token
                    self.idDaily = headerView.idDaily
                    self.idWeekly = headerView.idWeekly*/
                    //self.blurredEffectView = headerView.blurredEffectView
                    
                   
                    //questionView.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
                    /*self.questionView.borderWidth = 2
                    self.questionView.borderColor = .init(red: 205/255, green: 210/255, blue: 218/255, alpha: 1)
                    //participate.cornerRadius = 30
                    self.participate.layer.cornerRadius = self.participate.frame.width/23
                    self.participate.layer.masksToBounds = true*/
                    //self.inviteHeader.layer.cornerRadius = self.inviteHeader.frame.width/15
                    //self.inviteHeader.borderWidth = 5
                    //self.inviteHeader.borderColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    
                   /*
                    // let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)]
                    self.answerButtons = [self.answer1, self.answer2, self.answer3, self.answer4]

                    self.answerLayouts(answer: self.answer1)
                    self.answerLayouts(answer: self.answer2)
                    self.answerLayouts(answer: self.answer3)
                    self.answerLayouts(answer: self.answer4)*/
                    
                    /*let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.optionPressed(_:)))
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
                    self.gestures = [tap1,tap2,tap3,tap4]*/

                    /*answer1.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
                    answer2.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
                    answer3.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)
                    answer4.addTarget(self, action: #selector(optionPressed(_:)), for: .touchUpInside)*/
                    
                    //dailyCorrectAnswer = answer1
                    //weeklyCorrectAnswer = answer2
                   
                    
                    return headerView
                }
                
                // Return the view.
                fatalError("failed to get supplementary view")
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        if self.scratchList.count == 0{
            snapshot.appendItems(Array(0..<1))
        }else{
            snapshot.appendItems(Array(0..<self.scratchList.count))
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
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
    
    /*@IBAction func questionChanged(_ sender: Any) {
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
    }*/
    
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
    
    func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        let request = UNNotificationRequest(identifier: "notif", content: content, trigger: nil)
        print("solocoin-noti")
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func didCloseButtonPressed(sender: UIButton) {
        controller.didCloseButtonPressed(sender: sender)
    }
    
    func didDoneButtonPressed(sender: UIButton) {
        UserDefaults.standard.set(self.currentScratch, forKey: "offerDict")
        self.performSegue(withIdentifier: "showScratch", sender: nil)
    }
    
    /*func scratchpercentageDidChange(value: Float) {
        print("scratching")
    }
    
    func didScratchStarted() {
        print("scratchStarted")
    }
    
    func didScratchEnded() {
        
        
    }
    */
    
}

extension HomePage1: UICollectionViewDelegate{
    
    /*func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.scratchList.count.isMultiple(of: 2){
            return self.scratchList.count/2
        }else{
            return (self.scratchList.count/2)+1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.scratchList.count.isMultiple(of: 2){
            return 2
        }else{
            if section == self.scratchList.count/2{
                return 1
            }else{
                return 2
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionReusableView.identifier, for: indexPath)
    }*/
    
    /*func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "scratchCell", for: indexPath) as? BadgeCollectionViewCell{
            cell.badgeImageView.sd_setImage(with: URL(string: "https://solocoin.herokuapp.com/\(self.scratchList[indexPath.section*2 + indexPath.row]["imgurl"] as! String)")) { (image, error, cache, url) in
                if error == nil{
                    print("got card image")
                }else{
                    print("putting in default card image")
                    
                }
                cell.levelName.text = self.scratchList[indexPath.row]["company"] as! String//self.scratchList[indexPath.section*2 + indexPath.row]["company"] as! String
                cell.level.text = "\(self.scratchList[indexPath.row]["coins"] as! Int)"//"\(self.scratchList[indexPath.section*2 + indexPath.row]["coins"] as! Int)"
            }
            return cell
        }else{
            print("boom")
        }
        return UICollectionViewCell()
    }*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.scratchList.count == 0{
            print("nocardsds")
        }else{
            /*let scratch = self.scratchList[2*indexPath.section + indexPath.row]
            UserDefaults.standard.set(scratch, forKey: "offerDict")
            self.performSegue(withIdentifier: "showScratch", sender: nil)*/
            let x = UIImageView()
            x.sd_setImage(with: URL(string: self.scratchList[2*indexPath.section + indexPath.row]["imgurl"] as! String)) { (image, error, cahce, url) in
                self.currentScratch = self.scratchList[2*indexPath.section + indexPath.row]
                if error == nil{
                    print("starting scratch")
                    /*self.controller.scratchCardView.doneButtonTitle = "Gift to a friend"
                    self.controller.scratchCardView.scratchCardTitle = "Earn up to ₹1,0000"
                    self.controller.scratchCardView.scratchCardSubTitle = "From Google Pay \nEarned for paying \nGokul"*/
                    
                    self.controller.scratchCardView.afterScratchDoneButtonTitle = "Details"
                    self.controller.scratchCardView.afterScratchTitle = "Congratulations"
                    self.controller.scratchCardView.afterScratchSubTitle = "₹ \(self.currentScratch["offer_amount"])"
                    //self.controller.scratchCardView.afterScratchSubTitle = "Expect payment within a week."
                    
                    self.controller.scratchCardView.addDelegate(delegate: self)
                    self.controller.scratchCardView.bottomLayerView = UIImageView(image: image!)
                    self.controller.scratchCardView.topLayerImage = UIImage(named:"scratch")!
                    
                    self.controller.scratchCardView.scratchCardImageView.lineWidth = 50
                    self.controller.scratchCardView.scratchCardImageView.lineType = .round
                    self.controller.presentScratchController()
                }else{
                    print("startin wo pic")
                    /*self.controller.scratchCardView.doneButtonTitle = "Gift to a friend"
                    self.controller.scratchCardView.scratchCardTitle = "Earn up to ₹1,0000"
                    self.controller.scratchCardView.scratchCardSubTitle = "From Google Pay \nEarned for paying \nGokul"*/
                    
                    self.controller.scratchCardView.afterScratchDoneButtonTitle = "Details"
                    self.controller.scratchCardView.afterScratchTitle = "Congratulations"
                    self.controller.scratchCardView.afterScratchSubTitle = "₹ \(self.currentScratch["offer_amount"] as! Int)"
                    
                    self.controller.scratchCardView.addDelegate(delegate: self)
                    self.controller.scratchCardView.bottomLayerView = UIImageView(image: UIImage(named: "ScratchCard")!)
                    self.controller.scratchCardView.topLayerImage = UIImage(named:"scratch")!
                    self.controller.scratchCardView.scratchCardImageView.lineWidth = 50
                    self.controller.scratchCardView.scratchCardImageView.lineType = .round
                    self.controller.presentScratchController()
                }
                
            }
            
            
            
        }
    }
    
}
