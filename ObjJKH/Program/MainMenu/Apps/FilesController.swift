//
//  FilesController.swift
//  ObjJKH
//
//  Created by Роман Тузин on 02.09.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import CoreData

protocol FilesDelegate {
    func imagePressed(_ sender: UITapGestureRecognizer)
}

class FilesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilesDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    open var data_: [Comments] = []
    private var data: [Fotos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let objs = (CoreDataManager.instance.fetchedResultsController(entityName: "Fotos", keysForSort: ["name"]) as? NSFetchedResultsController<Fotos>)
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilesImageCell", for: indexPath) as! FilesImageCell
        cell.display(data[indexPath.row], delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200.0)
    }
    
    func imagePressed(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
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
    
    func display(_ item: Fotos, delegate: FilesDelegate?) {
        title.text = item.name
        date.text  = item.date
        self.delegate = delegate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePressed(_:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tap)
        
        loader.isHidden = false
        loader.startAnimating()
        
        if !imgs.keys.contains(item.name ?? "") {
            
            var request = URLRequest(url: URL(string: Server.SERVER + Server.DOWNLOAD_PIC + "id=" + (String(item.id).stringByAddingPercentEncodingForRFC3986() ?? ""))!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) {
                data, error, responce in
                
                guard data != nil else { return }
                DispatchQueue.main.async { [weak self] in
                    
                    let img = UIImage(data: data!)
                    imgs[item.name!] = img
                    self?.image.image = img
                    self?.loader.stopAnimating()
                    self?.loader.isHidden = true
                }
                
                }.resume()
            
        } else {
            image.image = imgs[item.name ?? ""]
        }
    }
    
    @objc private func imagePressed(_ sender: UITapGestureRecognizer) {
        delegate?.imagePressed(sender)
    }
    
}

private var imgs: [String:UIImage] = [:]
