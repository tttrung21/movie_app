//
//  Shared.swift
//  movie_app
//
//  Created by Trung on 30/10/24.
//

import UIKit

func getImg(path: String, completion: @escaping (UIImageView?) -> Void) {
    let url = URL(string: "https://image.tmdb.org/t/p/w342\(path)")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error downloading image: \(String(describing: error))")
            completion(nil)
            return
        }
        
        DispatchQueue.main.async {
            let imgView = UIImageView()
            imgView.image = UIImage(data: data)
            completion(imgView)
        }
    }
    task.resume()
}
func configTime(time:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let date = dateFormatter.date(from: time) {
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let yearString = yearFormatter.string(from: date)
        return yearString
    } else {
        print("Invalid date format")
        return time
    }
}
