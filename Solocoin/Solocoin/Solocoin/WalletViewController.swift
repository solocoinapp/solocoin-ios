//
//  WalletViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var errorMssg: UILabel!
    @IBOutlet weak var exclMark: UIImageView!
    @IBOutlet weak var headerStack: UIStackView!
    @IBOutlet weak var coins: UILabel!
    //all offers
    var offers: [[String:String]] = []
    var collectionView: UICollectionView!
    var notAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exclMark.isHidden = true
        errorMssg.isHighlighted = true
        // Do any additional setup after loading the view.
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCustomLayout())
        //collectionView.backgroundColor = .init(red: 92/255, green: 219/255, blue: 115/255, alpha: 1)
        //collectionView.backgroundColor = .init(red: 5/255, green: 56/255, blue: 107/255, alpha: 1)
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: "offerCell")
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coins.text = UserDefaults.standard.string(forKey: "wallet")
        obtainRewards {
            print("completed")
            collectionView.reloadData()
            print("count",offers.count)
        }
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.headerStack.bottomAnchor, constant: 10),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    func obtainRewards(completion: ()->()){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/rewards_sponsors")!
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
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        self.errorMssg.isHidden = true
                        self.exclMark.isHidden = true
                        print("r",json)
                        if let object = json as? [[String:AnyObject]]{
                            self.notAvailable = false
                            self.offers.removeAll(keepingCapacity: true)
                            for offer in object{
                                let nameOffer = offer["offer_name"] as! String
                                let companyName = offer["company_name"] as! String
                                let terms = offer["terms_and_conditions"] as! String
                                let coins = offer["coins"] as! Int
                                let copcode = offer["coupon_code"] as! String
                                let id = offer["id"] as! Int
                                self.offers.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)"])
                            }
                            print(self.offers)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }else{
                            self.errorMssg.text = "No offers are available at the moment"
                            self.errorMssg.adjustsFontSizeToFitWidth = true
                            self.errorMssg.isHidden = false
                            self.exclMark.isHidden = false
                            self.notAvailable = true
                        }
                    }else{
                        self.errorMssg.text = "Some error occurred..."
                        self.errorMssg.adjustsFontSizeToFitWidth = true
                        self.errorMssg.isHidden = false
                        self.exclMark.isHidden = false
                        }
                }
            }
        }
        }
        qtask.resume()
        completion()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("s",offers.count/2 + 1)
        if notAvailable{
            return 0
        }
        return offers.count/2 + 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //implement this later
        if offers.count%2 == 0{
            return 2
        }else{
            if section == offers.count/2{
                return 1
            }else{
                return 2
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as? OfferCollectionViewCell{
            if indexPath.section == 0{
                cell.id = indexPath.section+indexPath.row
            }else{
                cell.id = indexPath.section+indexPath.row + 1
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? OfferCollectionViewCell{
            setView(id: cell.id)
        }
    }
    
    
    func createCustomLayout() -> UICollectionViewLayout {
            
            let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
                let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitem: leadingItem, count: 1)
                
                let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.3))
                
                let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup])
      
                
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
                
                return section
            }
            return layout
        }
    
    func setView(id: Int){
        let offer = offers[id]
        UserDefaults.standard.set(offer, forKey: "offerDict")
        performSegue(withIdentifier: "toOffer", sender: nil)
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
