//
//  WalletViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import SDWebImage

class CellClass:UITableViewCell{
    
}

class WalletViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
        refreshControl.backgroundColor = UIColor.clear
        
        return refreshControl
    }()
    let gradientLayer = CAGradientLayer()
    @IBOutlet weak var headerBar: UIView!
    @IBOutlet weak var categoriesSegment: UISegmentedControl!
    @IBOutlet weak var errorMssg: UILabel!
    @IBOutlet weak var exclMark: UIImageView!
    @IBOutlet weak var headerStack: UIStackView!
    @IBOutlet weak var coins: UILabel!
    
    @IBOutlet weak var chooseBtn: DropDownButton!
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = DropDownButton()
    //
    var catSet = Set<String>()
    var categories = [String]()
    var offersWithCateg = [String:[[String:String]]]()
    var currrentCateg = [[String:String]]()
    //all offers
    var offers: [[String:String]] = []
    var collectionView: UICollectionView!
    var notAvailable = false
    let headLink = "https://solocoin.herokuapp.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        exclMark.isHidden = true
        errorMssg.isHighlighted = true
        chooseBtn.titleLabel?.text = ""
        chooseBtn.titleLabel?.textAlignment = .left
        chooseBtn.imageView?.image = UIImage(systemName: "arrowtriangle.down.fill")!
        tableView.backgroundColor = .white
        //change this maybe
        categoriesSegment.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCustomLayout())
        //collectionView.backgroundColor = .init(red: 92/255, green: 219/255, blue: 115/255, alpha: 1)
        //collectionView.backgroundColor = .init(red: 5/255, green: 56/255, blue: 107/255, alpha: 1)
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: "offerCell")
        configureCollectionView()
        tableView.register(CellClass.self, forCellReuseIdentifier: "dataCell")
        //configureCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gradientLayer.frame = self.headerBar.bounds
        gradientLayer.colors = [UIColor.init(red: 194/255, green: 57/255, blue: 90/255, alpha: 1).cgColor, UIColor.init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1).cgColor]
        self.headerBar.layer.insertSublayer(gradientLayer, at: 0)
        coins.text = UserDefaults.standard.string(forKey: "wallet")
        obtainRewards {
            print("completed")
            collectionView.reloadData()
            print("count",offers.count)
        }
    }
    
    func addTransparentView(frame :CGRect){
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y+frame.height+5, width: frame.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y+frame.height+5, width: frame.width, height: CGFloat(self.categories.count*50))
        }, completion: nil)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.removeTransparentView))
        transparentView.addGestureRecognizer(tapGest)
    }
    
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.chooseBtn.bottomAnchor, constant: 0),
            //self.collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.3),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    func configureCategories(){
        print("segment")
        categoriesSegment.removeAllSegments()
        for segment in 0..<categories.count{
            categoriesSegment.insertSegment(withTitle: self.categories[segment], at: segment, animated: true)
        }
        self.categoriesSegment.selectedSegmentIndex = 0
        let font = UIFont(name: "Poppins-SemiBold", size: 23)
        categoriesSegment.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)], for: .normal)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    /*func obtainRewards(completion: ()->()){
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
                        DispatchQueue.main.async {
                            self.errorMssg.isHidden = true
                            self.exclMark.isHidden = true
                        }
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
                                let imgurl = offer["brand_logo_url"] as! String
                                let amount = offer["offer_amount"] as! String
                                if let categ = offer["category"] as? NSNull{
                                    self.offers.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":"General","amount":amount])
                                }else{
                                    let category = offer["category"]!["name"] as! String
                                    self.offers.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":category,"amount":amount])
                                }
                                
                            }
                            print(self.offers)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.collectionView.collectionViewLayout = self.createCustomLayout()
                            }
                        }else{
                            self.errorMssg.text = "No offers are available at the moment"
                            self.errorMssg.adjustsFontSizeToFitWidth = true
                            self.errorMssg.isHidden = false
                            self.exclMark.isHidden = false
                            self.notAvailable = true
                        }
                    }else{
                        self.errorMssg.text = "Some error occurred.."
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
    }*/
    
    func obtainRewards(completion: ()->()){
        self.offers.removeAll()
        self.currrentCateg.removeAll()
        self.offersWithCateg.removeAll()
        self.categories.removeAll()
        self.catSet.removeAll()
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
                        DispatchQueue.main.async {
                            self.errorMssg.isHidden = true
                            self.exclMark.isHidden = true
                        }
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
                                let imgurl = offer["brand_logo_url"] as! String
                                let amount = offer["offer_amount"] as! String
                                if let categ = offer["category"] as? NSNull{
                                    self.offers.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":"General","amount":amount])
                                    if self.catSet.contains("General"){
                                        let offer = ["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":"General","amount":amount]
                                        var existing = self.offersWithCateg["General"]!
                                        existing.append(offer)
                                        self.offersWithCateg.updateValue(existing, forKey: "General")
                                        print("eixisn",self.offersWithCateg["General"]!)
                                    }else{
                                        self.catSet.insert("General")
                                        self.categories.append("General")
                                        self.offersWithCateg.updateValue([["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":"General","amount":amount]], forKey: "General")
                                        /*self.offersWithCateg["General"]?.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":"General","amount":amount])*/
                                    }
                                }else{
                                    let category = offer["category"]!["name"] as! String
                                    self.offers.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":category,"amount":amount])
                                    if self.catSet.contains(category){
                                        let offer = ["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":category,"amount":amount]
                                        var existing = self.offersWithCateg[category]!
                                        existing.append(offer)
                                        self.offersWithCateg.updateValue(existing, forKey: category)
                                    }else{
                                        self.catSet.insert(category)
                                        self.categories.append(category)
                                        self.offersWithCateg.updateValue([["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":category,"amount":amount]], forKey: category)
                                        /*self.offersWithCateg[category]?.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode,"id":"\(id)","imgurl":imgurl,"category":category,"amount":amount])*/
                                    }
                                }
                                
                            }
                            print(self.offers)
                            DispatchQueue.main.async {
                                guard self.categories.count != 0 else {return}
                                self.chooseBtn.backgroundColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
                                self.chooseBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                                self.chooseBtn.setTitle("\(self.categories[0])", for: .normal)
                                //self.chooseBtn.titleLabel?.text = self.categories[0]
                                self.currrentCateg = self.offersWithCateg[self.categories[0]]!
                                self.tableView.reloadData()
                                self.collectionView.reloadData()
                                self.collectionView.collectionViewLayout = self.createCustomLayout()
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.errorMssg.text = "No offers are available at the moment"
                                self.errorMssg.adjustsFontSizeToFitWidth = true
                                self.errorMssg.isHidden = false
                                self.exclMark.isHidden = false
                                self.notAvailable = true
                            }
                        }
                    }else{
                        DispatchQueue.main.async{
                            self.errorMssg.text = "Some error occurred.."
                            self.errorMssg.adjustsFontSizeToFitWidth = true
                            self.errorMssg.isHidden = false
                            self.exclMark.isHidden = false
                        }
                        
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
        if self.currrentCateg.count == 0{
            print("nil current")
            return 0
        }
        if self.currrentCateg.count%2==0{
            return self.currrentCateg.count/2
        }
        return self.currrentCateg.count/2 + 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //implement this later
        if currrentCateg.count == 0{
            self.errorMssg.text = "No offers are available at the moment"
            self.errorMssg.adjustsFontSizeToFitWidth = true
            self.errorMssg.isHidden = false
            self.exclMark.isHidden = false
            self.notAvailable = true
            return 0
        }else if  self.currrentCateg.count%2 == 0{
            print("oui,oui")
            return 2
        }else{
            if section ==  self.currrentCateg.count/2{
                return 1
            }else{
                return 2
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as? OfferCollectionViewCell{
            if indexPath.section == 0{
                cell.id = self.currrentCateg[(2*indexPath.section)+indexPath.row]["id"]!//indexPath.section+indexPath.row
                switch self.currrentCateg[(2*indexPath.section)+indexPath.row]["imgurl"]!{
                case "":
                    print("no link")
                    cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                    cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                    cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                    //let sample = UIImage(named: "sampleComp")!
                    //cell.addImage(comp: sample)
                    cell.removeImage()
                    
                case "null":
                    cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                    cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                    cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                    //let sample = UIImage(named: "sampleComp")!
                    //cell.addImage(comp: sample)
                    cell.removeImage()
                default:
                    cell.offerImageView.sd_setImage(with: URL(string: self.headLink+self.currrentCateg[(2*indexPath.section)+indexPath.row]["imgurl"]!)) { (image, error, cache, urlGiven) in
                        if error != nil{
                            print("success wallet")
                            cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                            cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                            cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                            cell.removeImage()
                        }else{
                            cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                            cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                            cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                            cell.addImage(comp: image!)
                            print("wallet",error?.localizedDescription)
                        }
                    }
                }
            }else{
                cell.id = self.currrentCateg[(2*indexPath.section)+indexPath.row]["id"]!//indexPath.section+indexPath.row
                switch self.currrentCateg[(2*indexPath.section)+indexPath.row]["imgurl"]!{
                case "":
                    print("no link")
                        //cell.offerImageView.image = UIImage(named: "Flipkart")!
                        cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                        cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                        cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                        cell.removeImage()
                case "null":
                    cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                    cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                    cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                    cell.removeImage()
                default:
                    cell.offerImageView.sd_setImage(with: URL(string: self.headLink+self.currrentCateg[(2*indexPath.section)+indexPath.row]["imgurl"]!)) { (image, error, cache, urlGiven) in
                        if error != nil{
                            print("success wallet")
                            cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                            cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                            cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                            cell.removeImage()
                        }else{
                            cell.altText.text = self.currrentCateg[(2*indexPath.section)+indexPath.row]["company"]
                            cell.cashText.text = "₹ \(self.currrentCateg[(2*indexPath.section)+indexPath.row]["amount"]!)"
                            cell.coinsText.text = "\(self.currrentCateg[(2*indexPath.section)+indexPath.row]["coins"]!) coins"
                            cell.addImage(comp: image!)
                            print("wallet",error?.localizedDescription)
                        }
                    }
                }
                cell.id = self.currrentCateg[(2*indexPath.section)+indexPath.row]["id"]!
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? OfferCollectionViewCell{
            setView(id: (2*indexPath.section)+indexPath.row)
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
    
    func setView(id: Int){
        let offer = currrentCateg[id]
        UserDefaults.standard.set(offer, forKey: "offerDict")
        performSegue(withIdentifier: "toOffer", sender: nil)
    }
    
    @IBAction func categChanged(_ sender: Any) {
        let categ = self.categories[self.categoriesSegment.selectedSegmentIndex]
        self.currrentCateg = self.offersWithCateg[categ]!
        self.collectionView.collectionViewLayout = createCustomLayout()
        self.collectionView.reloadData()
        
    }
    
    @IBAction func selectCateg(_ sender: Any) {
        selectedButton = chooseBtn
        addTransparentView(frame: chooseBtn.frame)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
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

extension WalletViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as! CellClass
        if categories.count == 0{
            return UITableViewCell()
        }else{
            cell.backgroundColor = .white
            cell.contentView.backgroundColor = .clear
            cell.textLabel?.text = "\(self.categories[indexPath.row])"
            cell.textLabel?.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
            cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
            let selectedView = UIView(frame: cell.frame)
            selectedView.backgroundColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
            cell.selectedBackgroundView = selectedView
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseBtn.setTitle("\(self.categories[indexPath.row])", for: .normal)
        chooseBtn.titleLabel?.textAlignment = .left
        chooseBtn.imageView?.image = UIImage(systemName: "arrowtriangle.down.fill")!
        //self.chooseBtn.titleLabel?.text = self.categories[indexPath.row]
        self.currrentCateg = self.offersWithCateg[self.categories[indexPath.row]]!
        self.collectionView.collectionViewLayout = self.createCustomLayout()
        self.collectionView.reloadData()
        self.removeTransparentView()
    }
}
