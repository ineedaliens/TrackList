//
//  TrackListTVC.swift
//  TrackList
//
//  Created by Евгений on 20.12.2020.
//

import UIKit
import RealmSwift
import SwiftEntryKit

class TrackListTVC: UITableViewController {
    
    private var tracklist: Results<TrackList>!
    var tracklistHandler: ((TrackList) -> Void?)!
    override func viewDidLoad() {
        super.viewDidLoad()
        tracklist = realm.objects(TrackList.self)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracklist.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackListTVCell
        
        cell.artistLabel.text = self.tracklist[indexPath.row].artist
        cell.albumLabel.text = self.tracklist[indexPath.row].album
        cell.songLabel.text = self.tracklist[indexPath.row].song
        cell.imagesOfView.image = UIImage(data: self.tracklist[indexPath.row].cover!)
        
        
        
        return cell
    }
    
    
    func setupAtributes() -> EKAttributes {
        var attributes  = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 100.0/255.0, alpha: 0.3), dark: UIColor(white: 50.0/255.0, alpha: 0.3))) // затемнение экрана
        attributes.entryBackground = .color(color: .standardBackground)
        attributes.roundCorners = .all(radius: 25)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.7, spring: .init(damping: 1, initialVelocity: 0)), scale: .init(from: 1.05, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        
        attributes.exitAnimation = .init(translate: .init(duration: 0.2))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.verticalOffset = 10
        attributes.roundCorners = .all(radius: CGFloat(13.0))
        return attributes
    }
    
    func setupMessagePopUp() -> EKPopUpMessage {
        let indexPath = tableView.indexPathForSelectedRow
        
        let image = UIImage(data: tracklist[indexPath!.row].cover!)
        
        let tittle = "\(self.tracklist[indexPath!.row].artist)"
        let description = "\(self.tracklist[indexPath!.row].album!)"
        
        let themeImage = EKPopUpMessage.ThemeImage(image: EKProperty.ImageContent(image: image!, size: CGSize(width: 100, height: 100)))
        
        let titleLabel = EKProperty.LabelContent(text: tittle , style: .init(font: .systemFont(ofSize: 24), color: .black, alignment: .center))
        
        let descriptionLabel = EKProperty.LabelContent(text: description, style: .init(font: .systemFont(ofSize: 16), color: .black, alignment: .center))
        
        let button = EKProperty.ButtonContent(label: .init(text: "OK", style: .init(font: UIFont.systemFont(ofSize: 16), color: .black)), backgroundColor: .init(UIColor.systemBlue), highlightedBackgroundColor: .clear)
        
        let message = EKPopUpMessage(themeImage: themeImage, title: titleLabel, description: descriptionLabel, button: button, action: {
            SwiftEntryKit.dismiss()
        })
        
            return message
    }
    
    
    func showPopUp() {
        SwiftEntryKit.display(entry: popUpView(with: setupMessagePopUp()), using: setupAtributes())
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPopUp()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tracklist = self.tracklist[indexPath.row]
        let delete = UIContextualAction(style: .normal, title: "Удалить", handler: {_,_,_  in
            StorageManager.deleteObject(tracklist: tracklist)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        let viewLink = UIContextualAction(style: .normal, title: "Сайт", handler: {_,_,_  in
//            self.performSegue(withIdentifier: "viewLink", sender: self)
            self.tracklistHandler?(tracklist)
            let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewLink") as! PopUpWebVC
            self.addChild(popUpVC)
            popUpVC.view.frame = self.view.frame
            self.view.addSubview(popUpVC.view)
            popUpVC.didMove(toParent: self)
        })
        let swipe = UISwipeActionsConfiguration(actions: [delete, viewLink])
        
        viewLink.backgroundColor = .lightGray
        delete.backgroundColor = .red
        
        return swipe
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "More" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let dvc = segue.destination as! MoreTVC
//                dvc.currentTrackList = tracklist[indexPath.row]
//            }
//        }
//    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let tracklistVC = segue.source as? AddNewTVC else { return }
        tracklistVC.saveTrackList()
        
        tableView.reloadData()
    }
    
    @IBAction func cancelToMainTVC(segue: UIStoryboardSegue) {
        
    }
    
}

