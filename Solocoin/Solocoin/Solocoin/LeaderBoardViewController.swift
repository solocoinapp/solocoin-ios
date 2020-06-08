//
//  LeaderBoardViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//remember to change self.currentLevel-1, add infant and make those changes once u put infant level in badges

import UIKit

class LeaderBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var milestone = [[String:String]]()
    var context = CIContext(options: nil)
    var currentLevel = 0
    var collectionView: UICollectionView!
    
    @IBOutlet weak var coinsLeft: UILabel!
    @IBOutlet weak var badgesUnlockedNo: UILabel!
    @IBOutlet weak var crnLevel: UILabel!
    @IBOutlet weak var Level3: UILabel!
    @IBOutlet weak var Level2: UILabel!
    @IBOutlet weak var Level1: UILabel!
    @IBOutlet weak var levelProgress: UIProgressView!
    @IBOutlet weak var leaderBoardHeader: UILabel!
    @IBOutlet weak var leaderBoardSec: UIImageView!
    let levels = [["0":"Amazon"],
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
    ["11":"Artboard11"],
    ["12":"Artboard12"],
    ["13":"Artboard13"]]
    
    let levelNames = [["Alpha Warrior",1000],["Beta Warrior",2500],["Omega Warrior",5000],["Chief Warrior",10000],["Ultimate Warrior",25000],["Supreme Warrior",50000],["Master",100000],["Grand Master",250000],["Ultimate Master",500000],["Supreme Master",1000000],["Universe God",5000000],["Mutliverse God",2500000]]
    let levelCoins:[Int] = [1000,2300,5000,10000,25000,50000,100000,250000,500000,1000000,2500000,5000000]
    var currentLevels:[[String:String]] = []
    var totalCoinsEarned = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCustomLayout())
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.register(BadgeCollectionViewCell.self, forCellWithReuseIdentifier: "badgeCell")
        configureCollectionView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //get from ap
        //obtainLeaderBoard()
        obtainBadges { (levels) in
            //print(levels,"lrv")
            self.currentLevel = levels.max()!
            self.currentLevel -= 1
            print("level",self.currentLevel)
            for indx in 0...self.currentLevel{
                let badge = self.levels[indx]
                self.currentLevels.append(badge)
            }
            DispatchQueue.main.async {
                //self.putImages(levels: self.currentLevels)
                if self.currentLevel == 12{
                    self.coinsLeft.text = "Congratulations! Levels Complete!"
                }else{
                    self.coinsLeft.text = "\(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned) coins to move to the next level!"
                }
                self.crnLevel.text = "Level \(self.currentLevel)"
                self.badgesUnlockedNo.text = String(self.currentLevel+1)
                self.setLevelProgress {
                    self.finalizeProgressbar()
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    /*func putImages(levels: [[String:String]]){
        print("putting",levels)
    }*/
    
    func setLevelProgress(completion:()->()){
        self.levelProgress.setProgress(0, animated: false)
        print("coins",self.levelCoins[self.currentLevel-1])
        if self.currentLevel == 1{
            let diff = 1-((Float(self.levelCoins[0]-self.totalCoinsEarned))/Float(self.levelCoins[0]))
            let progress = Float(1/4)+(Float(diff)/Float(4))
            self.levelProgress.setProgress(progress, animated: true)
            self.Level2.textColor = .white
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
                self.Level2.textColor = .black
                self.Level1.textColor = .black
                self.Level3.textColor = .black
            }else if self.currentLevel%3 == 0 || self.currentLevel%3 == 1{
                let xtra = Float(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned)/(Float(self.levelCoins[self.currentLevel-1]-self.levelCoins[self.currentLevel-2])/2.0)
                let toFill = Float(self.currentLevel)*0.25 + (1.0-xtra)/4.0
                self.levelProgress.setProgress(toFill, animated: true)
                if self.currentLevel%3 == 0{
                    self.Level1.text = "Level \(self.currentLevel-1)"
                    self.Level2.text = "Level \(self.currentLevel)"
                    self.Level3.text = "Level \(self.currentLevel+1)"
                    self.Level2.textColor = .black
                    self.Level1.textColor = .black
                    self.Level3.textColor = .black
                }else{
                    self.Level1.text = "Level \(self.currentLevel+1)"
                    self.Level2.text = "Level \(self.currentLevel+2)"
                    self.Level3.text = "Level \(self.currentLevel+3)"
                    self.Level2.textColor = .white
                    self.Level1.textColor = .black
                    self.Level3.textColor = .white
                }
            }else{
                let xtra = Float(self.levelCoins[self.currentLevel-1]-self.totalCoinsEarned)/Float(self.levelCoins[self.currentLevel-1]-self.levelCoins[self.currentLevel-2])
                let toFill = Float(self.currentLevel)*0.25 + (1.0-xtra)/4.0
                self.levelProgress.setProgress(toFill, animated: true)
                self.Level1.text = "Level \(self.currentLevel-1)"
                self.Level2.text = "Level \(self.currentLevel)"
                self.Level3.text = "Level \(self.currentLevel+1)"
                self.Level2.textColor = .black
                self.Level1.textColor = .black
                self.Level3.textColor = .white
            }
        }
        completion()
    }
    func finalizeProgressbar(){
        //function to show empty progressBar if filled and not in final Level
        //Might need to modify this according to its working
        guard self.currentLevel != 12 else {return}
        if self.levelProgress.progress == Float(1){
            self.levelProgress.setProgress(0, animated: false)
            self.Level1.text = "Level \(self.currentLevel+1)"
            self.Level2.text = "Level \(self.currentLevel+2)"
            self.Level3.text = "Level \(self.currentLevel+3)"
            self.Level2.textColor = .white
            self.Level1.textColor = .white
            self.Level3.textColor = .white
        }
    }
    
    
    func obtainBadges(completion:@escaping ([Int]) -> ()){
        
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
                                    levels.append(level)
                                    self.milestone.append(["level":"\(level)","name":name,"oneliner":oneline])
                                }
                                completion(levels)
                            }
                        }
                        }
                    }
                    
                }
            }
            else{
                print("eroor",error?.localizedDescription)
            }
        }
        qtask.resume()
        
    }
    
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.leaderBoardSec.bottomAnchor, constant: 30),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    func createCustomLayout() -> UICollectionViewLayout {
          
          let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

              let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
              leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
              
              let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
              let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitem: leadingItem, count: 1)
              
              let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.55))
              
              let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup])
    
              
              let section = NSCollectionLayoutSection(group: containerGroup)
              section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
              section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
              
              return section
          }
          return layout
      }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (levels.count-1)/2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //implement this later
        if levels.count%2 == 0{
            return 2
        }else{
            if section == levels.count/2{
                return 1
            }else{
                return 2
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCell", for: indexPath) as? BadgeCollectionViewCell{
            if self.currentLevels.count != 0{
                cell.badgeImageView.backgroundColor = .init(red: 239/255, green: 238/255, blue: 241/255, alpha: 1)
                guard let badgeImage = UIImage(named: self.levels[(indexPath.section*2)+indexPath.row+1]["\((indexPath.section*2)+indexPath.row+1)"]!) else {
                    print("no image")
                    return UICollectionViewCell()
                }
                let newImage = self.resizeImage(image: badgeImage, targetSize: CGSize(width: badgeImage.size.width*3, height: badgeImage.size.height*3))
                cell.badgeImageView.image = newImage
                /*cell.badgeImageView.image = UIImage(named: self.levels[(indexPath.section*2)+indexPath.row+1]["\((indexPath.section*2)+indexPath.row+1)"]!)*/
                print((indexPath.section*2)+indexPath.row+1,(self.currentLevels.count))
                if ((indexPath.section*2)+indexPath.row+1) >= (self.currentLevels.count-1){
                    print(indexPath.section,indexPath.row,self.currentLevels.count)
                    cell.blurEffect()
                }
            }
            cell.levelName.text = self.levelNames[(indexPath.section*2)+indexPath.row][0] as! String 
            cell.level.text = "Level \((indexPath.section*2)+indexPath.row+2)"
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BadgeCollectionViewCell{
            setView(level: (indexPath.section*2)+indexPath.row+1,image: self.levels[(indexPath.section*2)+indexPath.row+1]["\((indexPath.section*2)+indexPath.row+1)"] ?? "Amazon")
        }
    }
    
    
    func setView(level: Int,image: String){
        UserDefaults.standard.set(self.levelNames[level-1][0], forKey: "badgeName")
        UserDefaults.standard.set("Level \(level+1)", forKey: "level")
        UserDefaults.standard.set(image, forKey: "badgeImage")
        performSegue(withIdentifier: "shareBadge", sender: nil)
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
    
    /*func obtainLeaderBoard(){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/leaderboard")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //let content = ["notification":["token":]]
        let jsonEncoder = JSONEncoder()
               if let jsonData = try? jsonEncoder.encode(content), let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                request.httpBody = jsonData
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
                    }else{
                        print("error",error?.localizedDescription)
                    }
                }
                qtask.resume()
        }
        
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
 
