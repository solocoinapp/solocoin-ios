//
//  ScoreView.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/23/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit


class ScoreView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var leaderLabel = UILabel()
    var scoreCollection: UICollectionView!
    var persons = [[String: String]]()
    var personRank = [String:String]()
    var rankMain = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scoreMake()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        scoreMake()
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    func scoreMake(){
        leaderLabel.text = "Leaderboard"
        leaderLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
        leaderLabel.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        addSubview(leaderLabel)
        leaderLabel.textAlignment = .center
        leaderLabel.translatesAutoresizingMaskIntoConstraints = false
        leaderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        leaderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 8).isActive = true
        leaderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        leaderLabel.heightAnchor.constraint(equalToConstant: frame.width/9).isActive = true
        addSubview(leaderLabel)
        scoreCollection = UICollectionView(frame: .zero, collectionViewLayout: createRowLayout())
        self.scoreCollection.dataSource = self
        self.scoreCollection.delegate = self
        self.scoreCollection.backgroundColor = .clear
        self.scoreCollection.register(ScoreCollectionViewCell.self, forCellWithReuseIdentifier: "scoreCell")
        obtainLeaderboard {
            print("found it")
        }
        configureCollectionView()
    }
    
    func configureCollectionView() {
        scoreCollection.indicatorStyle = .white
        scoreCollection.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scoreCollection)
        NSLayoutConstraint.activate([
            self.scoreCollection.topAnchor.constraint(equalTo: leaderLabel.bottomAnchor, constant: 8),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            self.scoreCollection.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.scoreCollection.leftAnchor.constraint(equalTo: leftAnchor),
            self.scoreCollection.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.persons.count == 0{
            return 0
        }
        let rank = self.personRank["rank"]!
        if Int(rank)! <= 5{
            self.rankMain = Int(rank)!
            return 5
        }else{
            self.rankMain = 6
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard self.persons.count != 0 else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoreCell", for: indexPath) as! ScoreCollectionViewCell
        if self.rankMain-1 == indexPath.row{
            cell.coinsLabel.text = "\(self.personRank["wb"]!) coins"
            cell.countryImage.image = UIImage(named: personRank["cc"]!.uppercased()) ?? UIImage(named: "Flipkart")!
            cell.countryLabel.text = personRank["cc"]!.uppercased()
            cell.nameLabel.text = personRank["name"]!
            cell.rankLabel.text = "#\(personRank["rank"]!)"
            cell.backgroundColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            cell.rankLabel.textColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
            cell.countryLabel.textColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
            cell.nameLabel.textColor = .white
            cell.coinsLabel.textColor = .white
        }else{
            cell.coinsLabel.text = "\(persons[indexPath.row]["wb"]!) coins"
            cell.countryImage.image = UIImage(named: persons[indexPath.row]["cc"]!.uppercased()) ?? UIImage(named: "Flipkart")!
            cell.countryLabel.text = persons[indexPath.row]["cc"]!.uppercased()
            cell.nameLabel.text = persons[indexPath.row]["name"]!
            cell.rankLabel.text = "#\(persons[indexPath.row]["rank"]!)"
        }
        return cell
        
    }
    
    func obtainLeaderboard(completion:@escaping () -> ()){
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
                    if response.statusCode == 200{
                        if let data = data{
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                            print("B",json)
                            if let object = json as? [String:AnyObject]{
                                guard let userInfo = object["user"] as? [String:Any] else {
                                    print("sdskfhnskfasfnkasfa")
                                    return
                                }
                                let id = userInfo["id"] as! Int
                                let name = userInfo["name"] as! String
                                let cc = userInfo["country_code"] as? String ?? "US"
                                let wb = userInfo["wallet_balance"] as? Int ?? 0
                                let rank = userInfo["wb_rank"] as! Int
                                self.personRank = ["id":"\(id)","name":name,"cc":cc,"wb":"\(wb)","rank":"\(rank)"]
                             guard let leaderBoard = object["top_users"] as? [[String: Any]] else {return}
                             for person in leaderBoard{
                                 let id = person["id"] as! Int
                                 let name = person["name"] as! String
                                 let cc = person["country_code"] as? String ?? "US"
                                 let wb = person["wallet_balance"] as? Int ?? 0
                                 let rank = person["wb_rank"] as! Int
                                 self.persons.append(["id":"\(id)","name":name,"cc":cc,"wb":"\(wb)","rank":"\(rank)"])
                             }
                             completion()
                            }
                        }
                        }
                    }
                    
                }
             DispatchQueue.main.async {
                 print(self.persons)
                 self.scoreCollection.reloadData()
             }
            }else{
                print("eaderError",error?.localizedDescription)
            }
        }
        qtask.resume()
        
    }
    
    func createRowLayout() -> UICollectionViewLayout {
        //2
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        
        //3
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.15))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        //4
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //5
        let spacing = CGFloat(3)
        group.interItemSpacing = .fixed(spacing)
        section.interGroupSpacing = spacing
        
        //6
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
