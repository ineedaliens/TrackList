//
//  TrackListTVCell.swift
//  TrackList
//
//  Created by Евгений on 20.12.2020.
//

import UIKit

class TrackListTVCell: UITableViewCell {
    @IBOutlet weak var imagesOfView: UIImageView! {
        didSet {
            imagesOfView.layer.cornerRadius = 32.5
            imagesOfView.contentMode = .scaleAspectFill
            imageView?.clipsToBounds = true
        }
    }
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
