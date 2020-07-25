//
//  LeaderBoardTempVC.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/14/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import SDWebImage
import CRRefresh
import Reachability

class LeaderBoardVC: UIViewController{
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
        refreshControl.backgroundColor = UIColor.clear
        
        return refreshControl
    }()
    
    var milestone = [[String:String]]()
    var context = CIContext(options: nil)
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    enum Section {
        case main
    }
    //var collectionView: UICollectionView!
    
    //stacks
    
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack1: UIStackView!
    //
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var headerSec: UILabel!
    //var topStuff = CollectionReusableViewHeader()
    //let touchCell = UITapGestureRecognizer()
    var chosenCell = BadgeCollectionViewCell()
    var circle3 = UIImageView()
    var circle2 = UIImageView()
    var circle1 = UIImageView()
    var coinsLeft = UILabel()
    var bigCoinsLeft = UILabel()
    var badgesUnlockedNo = UILabel()
    var crnLevel = UILabel()
    var Level3 = UILabel()
    var Level2 = UILabel()
    var Level1 = UILabel()
    var levelProgress = UIProgressView()
    let headLink = "https://solocoin.herokuapp.com"
   // var leaderBoardHeader = UILabel()
    var leaderBoardSec = UIImageView()
    var levels = [["0":"defaultBadge"],
    ["1":"Artboard1"],
    ["2":"Artboard2"],
    ["3":"Artboard3"],
    ["4":"Artboard4"],
    ["5":"Artboard5"],
    ["6":"Artboard6"],
    ["7":"Artboard7"],
    ["8":"Artboard8"],
    ["9":"Artboard9"],
    ["10":"Artboard10"],
    ["11":"Artboard12"],
    ["12":"Artboard11"],
    ["13":"Artboard13"]]
    let levelNames = [["Alpha Warrior",1000],["Beta Warrior",2500],["Omega Warrior",5000],["Chief Warrior",10000],["Ultimate Warrior",25000],["Supreme Warrior",50000],["Master",100000],["Grand Master",250000],["Ultimate Master",500000],["Supreme Master",1000000],["Universe God",5000000],["Mutliverse God",2500000]]
    let levelCoins:[Int] = [1000,2300,5000,10000,25000,50000,100000,250000,500000,1000000,2500000,5000000]
    var currentLevels:[[String:String]] = []
    
    
    //main vars
    var levelInfo = [[String:Any]]()
    var currentLevel = 0
    var totalCoinsEarned = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //touchCell.addTarget(self, action: #selector(cellSelected(_:)))
        //mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCustomLayout())
        NetworkManager.isUnreachable { (_) in
            self.performSegue(withIdentifier: "errorPage", sender: nil)
        }
        self.mainCollectionView.delegate = self
        self.mainCollectionView.backgroundColor = .clear
        self.mainCollectionView.addSubview(self.refreshControl)
        //self.mainCollectionView.dataSource = self
        self.mainCollectionView.register(BadgeCollectionViewCell.self, forCellWithReuseIdentifier: "badgeCell")
        mainCollectionView.collectionViewLayout = createRowLayout()
        configureDataSource()
        //print(CollectionReusableViewHeader.topStuff.reuseIdentifier1 ?? "kk")
        //self.mainCollectionView.register(CollectionReusableViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "infoHeader")
        //configureCollectionView()
        obtainBadges {
            self.sortBadges {
                for i in 0..<self.levelInfo.count{
                    print("totalconi",self.totalCoinsEarned)
                    if (self.levelInfo[i]["points"] as! Int) > self.totalCoinsEarned{
                        if i==0{
                            self.currentLevel = 1
                            DispatchQueue.main.async {
                                self.badgesUnlockedNo.text = "  1"
                            }
                            break
                        }
                        self.currentLevel = (self.levelInfo[i]["level"] as! Int)-1
                        DispatchQueue.main.async {
                            if ((self.levelInfo[i]["level"] as! Int)-1)%10 != 0{
                                self.badgesUnlockedNo.text = " \((self.levelInfo[i]["level"] as! Int)-1)"
                            }else{
                                self.badgesUnlockedNo.text = " \((self.levelInfo[i]["level"] as! Int)-1)"
                            }
                            
                        }
                        break
                    }
                }
                DispatchQueue.main.async {
                    //self.putImages(levels: self.currentLevels)
                    if self.currentLevel == 13{
                        self.coinsLeft.text = "Congratulations!"
                        self.bigCoinsLeft.text = "You've finished all levels!"
                    }else{
                        self.coinsLeft.text = "\(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned) coins away!"
                        self.bigCoinsLeft.text = "\(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned) coins to move to the next level!"
                    }
                    self.crnLevel.text = "Level \(self.currentLevel)"
                    self.setLevelProgress {
                        print("done progress")
                        //self.finalizeProgressbar()
                    }
                    self.mainCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.isUnreachable { (_) in
            self.performSegue(withIdentifier: "errorPage", sender: nil)
        }
    }
    
    
    /*func putImages(levels: [[String:String]]){
        print("putting",levels)
    }*/
    
    @objc func cellSelected(_ gesture: UITapGestureRecognizer){
        let cellPosition = gesture.location(in: self.view)
        
    }
    
    func setLevelProgress(completion:()->()){
        self.levelProgress.setProgress(0, animated: false)
        print("coins",self.levelCoins[self.currentLevel-1])
        /*if self.currentLevel == 1{
            let diff = 1-((Float(self.levelCoins[0]-self.totalCoinsEarned))/Float(self.levelCoins[0]))
            let progress = Float(1/4)+(Float(diff)/Float(4))
            self.levelProgress.setProgress(0.25+progress, animated: true)
            self.Level2.textColor = .white
            self.Level3.textColor = .white
            self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            self.circle2.tintColor = .white
            self.circle3.tintColor = .white
        }else if self.currentLevel == 13{
            //print("sdsD")
            self.levelProgress.setProgress(1.0, animated: true)
        }else{
            if self.currentLevel/3 == 0{
                let xtra = Float(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned)/Float(self.levelCoins[self.currentLevel-1]-self.levelCoins[self.currentLevel-2])
                let toFill = Float(self.currentLevel)*0.25 + (1.0-xtra)/4.0
                self.levelProgress.setProgress(toFill, animated: true)
                self.Level1.text = "Level \(self.currentLevel-1)"
                self.Level2.text = "Level \(self.currentLevel)"
                self.Level3.text = "Level \(self.currentLevel+1)"
                self.Level2.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level3.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle2.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle3.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            }else if self.currentLevel%3 == 0 || self.currentLevel%3 == 1{
                let xtra = Float(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned)/(Float(self.levelCoins[self.currentLevel-1]-self.levelCoins[self.currentLevel-2])/2.0)
                let toFill = Float(self.currentLevel)*0.25 + (1.0-xtra)/4.0
                self.levelProgress.setProgress(toFill, animated: true)
                if self.currentLevel%3 == 0{
                    self.Level1.text = "Level \(self.currentLevel-1)"
                    self.Level2.text = "Level \(self.currentLevel)"
                    self.Level3.text = "Level \(self.currentLevel+1)"
                    self.Level2.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.Level3.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.circle3.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.circle2.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                }else{
                    self.Level1.text = "Level \(self.currentLevel+1)"
                    self.Level2.text = "Level \(self.currentLevel+2)"
                    self.Level3.text = "Level \(self.currentLevel+3)"
                    self.Level2.textColor = .white
                    self.circle2.tintColor = .white
                    self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.Level3.textColor = .white
                    self.circle3.tintColor = .white
                }
            }else{
                let xtra = Float(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned)/Float(self.levelCoins[self.currentLevel-1]-self.levelCoins[self.currentLevel-2])
                let toFill = Float(self.currentLevel)*0.25 + (1.0-xtra)/4.0
                self.levelProgress.setProgress(toFill, animated: true)
                self.Level1.text = "Level \(self.currentLevel-1)"
                self.Level2.text = "Level \(self.currentLevel)"
                self.Level3.text = "Level \(self.currentLevel+1)"
                self.Level2.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle2.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level3.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle3.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            }
        }*/
        if self.currentLevel != self.levelInfo.count{
            //let left = Float((self.levelInfo[self.currentLevel]["points"] as! Int)-self.totalCoinsEarned)/Float((self.levelInfo[self.currentLevel]["points"] as! Int)-(self.levelInfo[self.currentLevel-1]["points"] as! Int))
            let left = Float((self.totalCoinsEarned-self.levelInfo[self.currentLevel-1]["points"] as! Int))/Float((self.levelInfo[self.currentLevel]["points"] as! Int)-(self.levelInfo[self.currentLevel-1]["points"] as! Int))
            if self.currentLevel == 1{
                let toFill = (left/4.0)
                self.levelProgress.setProgress(toFill, animated: true)
                //self.levelProgress.setProgress(1.0, animated: true)
                self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle2.tintColor = .white
                self.circle3.tintColor = .white
                self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level2.textColor = .white
                self.Level3.textColor = .white
                self.Level1.text = "Level \(self.currentLevel)"
                self.Level2.text = "Level \(self.currentLevel+1)"
                self.Level3.text = "Level \(self.currentLevel+2)"
            }
            else if self.currentLevel%3==1{
                let toFill = 0.25+(left/4.0)
                self.levelProgress.setProgress(toFill, animated: true)
                //self.levelProgress.setProgress(1.0, animated: true)
                self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle2.tintColor = .white
                self.circle3.tintColor = .white
                self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level2.textColor = .white
                self.Level3.textColor = .white
                self.Level1.text = "Level \(self.currentLevel)"
                self.Level2.text = "Level \(self.currentLevel+1)"
                self.Level3.text = "Level \(self.currentLevel+2)"
            }else if self.currentLevel%3 == 2{
                let toFill = 0.5+(left/4.0)
                self.levelProgress.setProgress(toFill, animated: true)
                self.levelProgress.setProgress(1.0, animated: true)
                self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle2.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.circle3.tintColor = .white
                self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level2.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                self.Level3.textColor = .white
                self.Level1.text = "Level \(self.currentLevel-1)"
                self.Level2.text = "Level \(self.currentLevel-2)"
                self.Level3.text = "Level \(self.currentLevel+1)"
            }else{
                if ((self.levelInfo[self.currentLevel]["points"] as! Int)-self.totalCoinsEarned) > (((self.levelInfo[self.currentLevel]["points"] as! Int)-(self.levelInfo[self.currentLevel-1]["points"] as! Int))/2){
                    let diff = ((self.levelInfo[self.currentLevel]["points"] as! Int)-self.totalCoinsEarned) - (((self.levelInfo[self.currentLevel]["points"] as! Int)-(self.levelInfo[self.currentLevel-1]["points"] as! Int))/2)
                    let left = Float(diff)/Float((((self.levelInfo[self.currentLevel]["points"] as! Int)-(self.levelInfo[self.currentLevel-1]["points"] as! Int))/2))
                    let toFill = left/4.0
                    self.levelProgress.setProgress(toFill,animated: true)
                    self.circle1.tintColor = .white
                    self.circle2.tintColor = .white
                    self.circle3.tintColor = .white
                    self.Level1.textColor = .white
                    self.Level2.textColor = .white
                    self.Level3.textColor = .white
                    self.Level1.text = "Level \(self.currentLevel+1)"
                    self.Level2.text = "Level \(self.currentLevel+2)"
                    self.Level3.text = "Level \(self.currentLevel+3)"
                    
                }else{
                    let toFill = 0.75+(left/8.0)
                    self.levelProgress.setProgress(toFill, animated: true)
                    self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.circle2.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.circle3.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.Level2.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.Level3.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
                    self.Level1.text = "Level \(self.currentLevel-2)"
                    self.Level2.text = "Level \(self.currentLevel-1)"
                    self.Level3.text = "Level \(self.currentLevel)"
                }
            }
        }else{
            self.levelProgress.setProgress(1.0, animated: true)
            self.circle1.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            self.circle2.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            self.circle3.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            self.Level1.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            self.Level2.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            self.Level3.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            self.Level1.text = "Level \(self.currentLevel-2)"
            self.Level2.text = "Level \(self.currentLevel-1)"
            self.Level3.text = "Level \(self.currentLevel)"
        }
        
        completion()
    }
    /*func finalizeProgressbar(){
        //function to show empty progressBar if filled and not in final Level
        //Might need to modify this according to its working
        guard self.currentLevel != self.levelInfo.count else {return}
        if self.levelProgress.progress == Float(1){
            self.levelProgress.setProgress(0, animated: false)
            self.Level1.text = "Level \(self.currentLevel+1)"
            self.Level2.text = "Level \(self.currentLevel+2)"
            self.Level3.text = "Level \(self.currentLevel+3)"
            self.Level2.textColor = .white
            self.circle2.tintColor = .white
            self.Level1.textColor = .white
            self.circle1.tintColor = .white
            self.Level3.textColor = .white
            self.circle3.tintColor = .white
            let left = Float((self.levelInfo[self.currentLevel]["points"] as! Int)-self.totalCoinsEarned)/Float((self.levelInfo[self.currentLevel]["points"] as! Int)-(self.levelInfo[self.currentLevel-1]["points"] as! Int))
        }
    }*/
    
    func obtainBadges(completion:@escaping () -> ()){
        self.levelInfo.removeAll()
        var levels = [Int]()
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/user/badges")!
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
                    if response.statusCode == 200{
                        if let data = data{
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                            print("B",json)
                            if let object = json as? [String:AnyObject]{
                                let coins_earned = object["total_earned_coins"] as! Int
                                self.totalCoinsEarned = coins_earned
                                let badgesEarned = object["badges"] as! [[String:AnyObject]]
                                for badge in badgesEarned{
                                    let level = badge["level"] as! Int
                                    let name = badge["name"] as! String
                                    let oneline = badge["one_liner"] as! String
                                    let min_coins = badge["min_points"] as! Int
                                    if let img = badge["badge_image_url"] as? NSNull{
                                        self.levelInfo.append(["level":level,"points":min_coins,"name":name,"oneline":oneline,"imgurl":"null"])
                                    }else{
                                        let imgurl = badge["badge_image_url"] as! String
                                        self.levelInfo.append(["level":level,"points":min_coins,"name":name,"oneline":oneline,"imgurl":imgurl])
                                    }
                                }
                                completion()
                            }
                        }
                        }
                    }
                    
                }
            }else{
                print("eroor",error?.localizedDescription)
                self.performSegue(withIdentifier: "errorPage", sender: nil)
            }
        }
        qtask.resume()
        
    }
    
    
    
    func setView(level: Int,image: String,enabling: Bool){
        if enabling{
            UserDefaults.standard.set(self.levelInfo[level-1]["name"] as! String, forKey: "badgeName")
            UserDefaults.standard.set("Level \(level)", forKey: "level")
            UserDefaults.standard.set(image, forKey: "badgeImage")
            performSegue(withIdentifier: "shareBadge", sender: nil)
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func createRowLayout() -> UICollectionViewLayout {
        //2
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
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(511))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        //4
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
    
    func sortBadges(completion:()->()){
        while true{
            if levelInfo.count != 0 {
                break
            }
            print("no")
        }
        for i in 0..<levelInfo.count {
          for j in 1..<levelInfo.count - i {
            if (levelInfo[j]["level"]! as! Int) < (levelInfo[j-1]["level"]! as! Int){
                let tmp = self.levelInfo[j-1]
                self.levelInfo[j-1] = self.levelInfo[j]
                self.levelInfo[j] = tmp
            }
          }
        }
        completion()
    }
    
    private func configureDataSource() {
        print("dict",self.levelInfo)
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: self.mainCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            print("indx",indexPath.section,indexPath.row)
            if ((indexPath.section*2)+indexPath.row)==14{
                return UICollectionViewCell()
            }
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCell", for: indexPath) as? BadgeCollectionViewCell{
                if self.levelInfo.count != 0{
                    cell.badgeImageView.backgroundColor = .init(red: 239/255, green: 238/255, blue: 241/255, alpha: 1)
                    switch ((indexPath.section*2)+indexPath.row){
                    case 0:
                        let badgeImage = self.levels[(indexPath.section*2)+indexPath.row]["\((indexPath.section*2)+indexPath.row)"]!
                        print(badgeImage)
                        cell.badgeImageView.image = UIImage(named: badgeImage)
                    default:
                        let url = self.headLink+(self.levelInfo[(indexPath.section*2)+indexPath.row]["imgurl"] as! String)
                        self.levels[(indexPath.section*2)+indexPath.row]["\((indexPath.section*2)+indexPath.row)"] = url
                        cell.badgeImageView.sd_setImage(with: URL(string: url)) { (badgeImage, error, cache, urlGiven) in
                            print("\(urlGiven)")
                            if error == nil{
                                print("success")
                            }else{
                                print("error in image",error?.localizedDescription)
                            }
                        }
                    }
                    cell.clickEnabled = false
                    if ((indexPath.section*2)+indexPath.row+1)>self.currentLevel{
                        //print("plpl",indexPath.section,indexPath.row,self.currentLevel)
                        print((indexPath.section*2)+indexPath.row+1,self.currentLevel)
                        cell.blurEffect(status: true)
                        cell.clickEnabled = false
                    }else{
                        cell.blurEffect(status: false)
                        cell.clickEnabled = true
                        print(indexPath.section,indexPath.row,"oui")
                    }
                }else{
                    cell.badgeImageView.backgroundColor = .init(red: 239/255, green: 238/255, blue: 241/255, alpha: 1)
                    guard let badgeImage = UIImage(named:"defaultBadge") as? UIImage else {
                        print("no image")
                        return UICollectionViewCell()
                    }
                    cell.badgeImageView.image = badgeImage
                    cell.clickEnabled = false
                }
                if self.levelInfo.count == 0{
                    cell.levelName.text = ""
                    cell.level.text = ""
                }else{
                    cell.levelName.text = self.levelInfo[(indexPath.section*2)+indexPath.row]["name"] as! String
                    cell.level.text = "Level \((indexPath.section*2)+indexPath.row+1)"
                }
                return cell
            }
                
            return UICollectionViewCell()
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
                        withReuseIdentifier: CollectionReusableViewHeader.identifier,
                        for: indexPath) as? CollectionReusableViewHeader else { fatalError("Cannot create new supplementary") }
                    
                    // Populate the view with our data.
                    //header.titleLabel.text = "I am a header"
                    headerView.badgesUnlockedNo.adjustsFontSizeToFitWidth = true
                    headerView.coinsLeft.adjustsFontSizeToFitWidth = true
                    headerView.crnLevel.adjustsFontSizeToFitWidth = true
                    headerView.bigCoinsLeft.adjustsFontSizeToFitWidth = true
                    headerView.Level2.adjustsFontSizeToFitWidth = true
                    headerView.Level1.adjustsFontSizeToFitWidth = true
                    headerView.Level3.adjustsFontSizeToFitWidth = true
                    headerView.awardsUnlocked.adjustsFontSizeToFitWidth = true
                    
                    headerView.badgesHeading.adjustsFontSizeToFitWidth = true
                    //changes:
                    /*headerView.emptyProgress.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                    headerView.filledProgressBar.mask = headerView.emptyProgress*/
                    self.badgesUnlockedNo = headerView.badgesUnlockedNo
                    //headerView.badgesUnlockedNo.adjustsFontSizeToFitWidth = true
                    self.circle1 = headerView.circle1
                    self.circle2 = headerView.circle2
                    self.circle3 = headerView.circle3
                    self.coinsLeft = headerView.coinsLeft
                    self.bigCoinsLeft = headerView.bigCoinsLeft
                    self.crnLevel = headerView.crnLevel
                    //self.leaderBoardHeader = headerView.leaderBoardHeader
                    self.leaderBoardSec = headerView.leaderBoardSec
                    self.Level1 = headerView.Level1
                    self.Level2 = headerView.Level2
                    self.Level3 = headerView.Level3
                    self.levelProgress = headerView.levelProgress
                    return headerView
                }
                
                // Return the view.
                fatalError("failed to get supplementary view")
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<13))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.mainCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension LeaderBoardVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BadgeCollectionViewCell{
            var n=0
            var count=0
            let x = "1234567890"
            for chr in cell.level.text!{
                if x.contains(chr) {
                    if count==0{
                        n += Int(String(chr))!
                        count+=1
                    }else{
                        n = n*10 + Int(String(chr))!
                    }
                }
            }
            setView(level: n, image: self.levels[n-1]["\(n-1)"]!,enabling: cell.clickEnabled)
        }
    }
}

