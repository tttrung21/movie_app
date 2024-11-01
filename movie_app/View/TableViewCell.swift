
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            }
    func configure(movie: Result, genre: String){
        nameLabel.text = movie.title
        ratingLabel.text = String(format: "%.2f",movie.voteAverage)
        yearLabel.text = movie.releaseDate != nil ? configTime(time: movie.releaseDate!) : ""
        if(movie.posterPath != nil)
        {
            getImg(path: movie.posterPath!) { imgView in
                if let imgView = imgView {
                    self.img.image = imgView.image
//                    self.img.layer.cornerRadius = 30
//                    self.img.clipsToBounds = true
                } else {
                    print("Failed to load image.")
                }
            }
        }
        if(movie.genreIDS != nil)
        {
            genreLabel.text = genre
        }
    }
}
