//
//  ACPushWindow.swift
//  Flickr
//
//  Created by User on 28.10.15.
//  Copyright © 2015 qswitch. All rights reserved.
//

import UIKit

class ACPushWindow: UIViewController
{
    @IBOutlet weak var originalPhoto: UIImageView!
    @IBOutlet weak var photoAuthor: UILabel!
    weak var postToDisplay : ACPost!
    var star : UIImageView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        originalPhoto.pin_setImageFromURL(postToDisplay.originalPhotoURL!) //Вставляем оригинальную фото
        photoAuthor.text = postToDisplay.postTitle
        
        
        let gestureRecognizer = UITapGestureRecognizer (target: self, action: "addToFavourites") //включаем объект перехвата касаний экрана
        gestureRecognizer.numberOfTapsRequired = 2 // Задаем количество касаний
        
        originalPhoto.userInteractionEnabled = true // Включаем считывание касаний экрана
        originalPhoto.addGestureRecognizer(gestureRecognizer)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}

// Передаем в ACPost данные о том, что картинка попала в избранное

extension ACPushWindow
{
    func addToFavourites () -> Void
    {
        postToDisplay.isBookmarked = true
        print("tap")
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil) //Система вызова удаленных процедур у объектов. Выбрасываем в эфир нотификацию "reloadTable" 
        showStarAnimated() // Вызываем фукнцию анимации
        
    }
    
    private func showStarAnimated () //Анимация появляющейся звезды
    {
        star = UIImageView (image: UIImage ( named : "star")) //завод объекта звездочки из исходного кода (аналог сториборда)
        star?.frame = CGRectMake(0.0, 0.0, 10.0, 10.0) // Ставим фрейм в координатной системе. Начало сетки экрана айфона - левый верхний угол.
        
        star?.center = self.originalPhoto.center // Ставим звездочку по центру экрана
        star?.alpha = 0.0 // Задаем начальную альфу звезды равной нулю
        
        self.originalPhoto.addSubview(star!) // Добавляем программно элемент саму звездочку
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in // это нельщзя сделать из сториборды. Это самые простые анимации. БЫвают coreAnimation и coreGraphics. Это блок. Первый аргумент - это длительность(флоат), Второй это блок самих анимаций. Анимации делаются так: до блока - начальные значения, в блоке - конечные значения анимации. Первая анимация растягивает звезду в размере
            
            self.star?.alpha = 0.5 // Первая анимация выкручивает альфу в 0.5
            self.star?.transform = CGAffineTransformMakeScale(40.0, 40.0) // Устанавливаем максимальный размер в который увеливается картинка. Свойство transfom позволяет применить транформацию. Эта трансформация не менет расстояние между двумя точками. Она растягивает не объект, а его базис.
            
            }) { (completed) -> Void in
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in // Вторая анимация убирает альфу в ноль
                    
                    self.star?.alpha = 0.0 // Вторая анимация убирает альфу в ноль
                    
                    }, completion: { (completed) -> Void in
                        
                        self.star?.removeFromSuperview() // Убираем звезду с супервью. Очищаем память.
                        self.star = nil
                })
        }
    }
    
}
