//
//  ScoreBoardViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/22/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var sampleLabel: UIButton!
    var collectionView: UICollectionView!
    var persons = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createRowLayout())
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.register(ScoreCollectionViewCell.self, forCellWithReuseIdentifier: "scoreCell")
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        obtainLeaderboard {
            print("obtained")
        }
    }
    
    func createRowLayout() -> UICollectionViewLayout {
        //2
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //3
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.08))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        //4
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //5
        let spacing = CGFloat(20)
        group.interItemSpacing = .fixed(spacing)
        section.interGroupSpacing = spacing
        
        //6
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.sampleLabel.bottomAnchor, constant: 10),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
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
                    self.collectionView.reloadData()
                }
               }else{
                   print("eaderError",error?.localizedDescription)
               }
           }
           qtask.resume()
           
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard self.persons.count != 0 else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoreCell", for: indexPath) as! ScoreCollectionViewCell
        cell.coinsLabel.text = "\(persons[indexPath.row]["wb"]!) coins"
        cell.countryImage.image = UIImage(named: persons[indexPath.row]["cc"]!.uppercased()) ?? UIImage(named: "Flipkart")!
        cell.countryLabel.text = persons[indexPath.row]["cc"]!.uppercased()
        cell.nameLabel.text = persons[indexPath.row]["name"]!
        cell.rankLabel.text = "#\(persons[indexPath.row]["rank"]!)"
        return cell
        
    }
    @IBAction func clicked(_ sender: Any) {
        print(self.persons.count)
        collectionView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
