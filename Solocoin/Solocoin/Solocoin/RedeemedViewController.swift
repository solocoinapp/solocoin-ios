//
//  RedeemedViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 8/2/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class RedeemedViewController: UIViewController {
    var collectionView: UICollectionView!
    var allRedeemed = [[String:Any]]()
    @IBOutlet weak var topbar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCustomLayout())
        //collectionView.backgroundColor = .init(red: 92/255, green: 219/255, blue: 115/255, alpha: 1)
        //collectionView.backgroundColor = .init(red: 5/255, green: 56/255, blue: 107/255, alpha: 1)
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: "offerCell")
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.obtainProfileInfo {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func createCustomLayout() -> UICollectionViewLayout {
    print("called")
    let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

              let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
              leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
              
              let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
              let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitem: leadingItem, count: 1)
              
              let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.3))
              
              let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup])
    
              
              let section = NSCollectionLayoutSection(group: containerGroup)
              section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
              section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
              
              return section
          }
          return layout
    /*if currrentCateg.count%2==0{
        print("even")
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                  let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                  leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                  
                  let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
                  let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitem: leadingItem, count: 1)
                  
                  let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.3))
                  
                  let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup])
        
                  
                  let section = NSCollectionLayoutSection(group: containerGroup)
                  section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                  section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
                  
                  return section
              }
              return layout
    }*/
    /*print("hmm ye")
    let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        if section == self.numberOfSections(in: self.collectionView)-1{
            print("ye")
           let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                      leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                      
            let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
                      let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitem: leadingItem, count: 1)
                      
                      let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.3))
                      
                      let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup])
            
                      
                      let section = NSCollectionLayoutSection(group: containerGroup)
                      section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                      section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
                      
                      return section
        }else{
            print("nope")
            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                      leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                      
                      let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
                      let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitem: leadingItem, count: 1)
                      
                      let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.3))
                      
                      let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup])
            
                      
                      let section = NSCollectionLayoutSection(group: containerGroup)
                      section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                      section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
                      
                      return section
        }
          }*/
          return layout
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topbar.bottomAnchor, constant: 10),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
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
                            if let redeemed = object["redeemed_rewards"] as? [[String:Any]]{
                                self.allRedeemed = redeemed
                                print("pui,",self.allRedeemed)
                            }else{
                                print("havent redeemed anything")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goBacklol(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension RedeemedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.allRedeemed.count == 0{
            return 0
        }else if self.allRedeemed.count.isMultiple(of: 2){
            return self.allRedeemed.count/2
        }else{
            return self.allRedeemed.count/2 + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.allRedeemed.count.isMultiple(of: 2){
            return 2
        }else{
            if section == self.allRedeemed.count/2{
                return 1
            }else{
                return 2
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as? OfferCollectionViewCell{
            if self.allRedeemed.count != 0{
                let name = self.allRedeemed[(2*indexPath.section)+indexPath.row]["offer_name"] as! String
                let couponCode = self.allRedeemed[(2*indexPath.section)+indexPath.row]["coupon_code"] as! String
                cell.altText.text = name
                cell.cashText.text = couponCode
                cell.altText.adjustsFontSizeToFitWidth = true
                cell.cashText.adjustsFontSizeToFitWidth = true
                cell.removeImage()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
}
