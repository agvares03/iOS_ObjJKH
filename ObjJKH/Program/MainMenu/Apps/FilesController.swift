//
//  FilesController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 02.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics

protocol FilesDelegate {
    func imagePressed(_ sender: UITapGestureRecognizer)
}

class FilesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilesDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    open var data_: [Comments] = []
    public var colorNav: Bool = false
    private var data: [Fotos] = []
    public var fromNew: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().setObjectValue("FilesController", forKey: "last_UI_action")
        let objs = (CoreDataManager.instance.fetchedResultsController(entityName: "Fotos", keysForSort: ["name"], ascending: true) as? NSFetchedResultsController<Fotos>)
        try? objs?.performFetch()
        objs?.fetchedObjects?.forEach { obj in
            data_.forEach {
                if $0.text?.contains(obj.name ?? "") ?? false {
                    self.data.append(obj)
                }
            }
        }
        
        collection.dataSource = self
        collection.delegate   = self
        
        navigationController?.navigationBar.tintColor = myColors.btnColor.uiColor()
        if fromNew{
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = myColors.btnColor.uiColor()
            navigationController?.navigationBar.tintColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilesImageCell", for: indexPath) as! FilesImageCell
        cell.display(data[indexPath.row], delegate: self)
        cell.delegate2 = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 256.0)
    }
    
    func imagePressed(_ sender: UITapGestureRecognizer) {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        let imageView = sender.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
        if imageView.image != nil && imageView.image != UIImage(named: "icon_file"){
            self.link = imageView.accessibilityLabel ?? ""
            self.pdf = false
            self.performSegue(withIdentifier: "openURL", sender: self)
//            let k = Double((imageView.image?.size.height)!) / Double((imageView.image?.size.width)!)
//            let l = Double((imageView.image?.size.width)!) / Double((imageView.image?.size.height)!)
//            if k > l{
//                newImageView.frame.size.height = self.view.frame.size.width * CGFloat(k)
//            }else{
//                newImageView.frame.size.height = self.view.frame.size.width / CGFloat(l)
//            }
//            newImageView.frame.size.width = self.view.frame.size.width
//            let y = (UIScreen.main.bounds.size.height - newImageView.frame.size.height) / 2
//            newImageView.frame = CGRect(x: 0, y: y, width: newImageView.frame.size.width, height: newImageView.frame.size.height)
//            newImageView.backgroundColor = .black
//            newImageView.contentMode = .scaleToFill
//            newImageView.isUserInteractionEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
//            view.addGestureRecognizer(tap)
//            view.addSubview(newImageView)
//            self.view.addSubview(view)
//            self.navigationController?.isNavigationBarHidden = true
//            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.link = imageView.accessibilityLabel ?? ""
            self.pdf = true
            self.performSegue(withIdentifier: "openURL", sender: self)
        }
    }
    var link = ""
    var pdf = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openURL" {
            let payController = segue.destination as! openSaldoController
            payController.urlLink = self.link
            payController.pdf = self.pdf
            payController.colorNav = colorNav
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

final class FilesImageCell: UICollectionViewCell {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    private var delegate: FilesDelegate?
    public var delegate2: UIViewController?
    
    func display(_ item: Fotos, delegate: FilesDelegate?) {
        title.text = item.name
        date.text  = item.date
        self.delegate = delegate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePressed(_:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)
        
        loader.isHidden = false
        loader.startAnimating()
        let url = Server.SERVER + Server.DOWNLOAD_PIC + "id=" + (String(item.id).stringByAddingPercentEncodingForRFC3986() ?? "")
        if !imgs.keys.contains(item.name ?? "") {
            if (item.name?.contains(".pdf"))!{
                let img = UIImage(named: "icon_file")
                imgs[item.name!] = img
                image.image = img
                image.tintColor = myColors.btnColor.uiColor()
                image.accessibilityLabel = url
                loader.stopAnimating()
                loader.isHidden = true
            }else{
                var request = URLRequest(url: URL(string: Server.SERVER + Server.DOWNLOAD_PIC + "id=" + (String(item.id).stringByAddingPercentEncodingForRFC3986() ?? ""))!)
                request.httpMethod = "GET"
                
                URLSession.shared.dataTask(with: request) {
                    data, error, responce in
                    
                    guard data != nil else { return }
                    DispatchQueue.main.async { [weak self] in
                        if UIImage(data: data!) != nil{
                            let img = UIImage(data: data!)
                            imgs[item.name!] = img
                            self?.image.accessibilityLabel = url
                            self?.image.image = img
                            self?.image.tintColor = .clear
                            self?.loader.stopAnimating()
                            self?.loader.isHidden = true
                        }
                    }
                    
                    }.resume()
            }
        } else {
            if (item.name?.contains(".pdf"))!{
                image.image = imgs[item.name ?? ""]
                image.tintColor = myColors.btnColor.uiColor()
                image.accessibilityLabel = url
            }else{
                image.image = imgs[item.name ?? ""]
                image.accessibilityLabel = url
                image.tintColor = .clear
            }
        }
    }
    
    @objc private func imagePressed(_ sender: UITapGestureRecognizer) {
        delegate?.imagePressed(sender)
    }
    
}

private var imgs: [String:UIImage] = [:]
