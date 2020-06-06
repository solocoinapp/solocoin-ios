//
//  LeaderBoardViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var milestone = [[String:String]]()
    var context = CIContext(options: nil)
    var currentLevel = 0
    var collectionView: UICollectionView!
    
    @IBOutlet weak var leaderBoardHeader: UILabel!
    let levels = [
        ["0":"Amazon"],
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
    var currentLevels:[[String:String]] = []
    
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
            self.currentLevel = levels.max()!-1
            //self.currentLevel -= 1
            print("level",self.currentLevel)
            for indx in 0...self.currentLevel{
                let badge = self.levels[indx]
                self.currentLevels.append(badge)
            }
            DispatchQueue.main.async {
                self.putImages(levels: self.currentLevels)
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func putImages(levels: [[String:String]]){
        print("putting",levels)
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
            self.collectionView.topAnchor.constraint(equalTo: self.leaderBoardHeader.bottomAnchor, constant: 30),
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
                cell.badgeImageView.backgroundColor = .lightGray
                cell.badgeImageView.image = UIImage(named: self.levels[(indexPath.section*2)+indexPath.row+1]["\((indexPath.section*2)+indexPath.row+1)"]!)
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

}
 
