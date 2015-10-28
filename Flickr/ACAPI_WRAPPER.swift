//
//  ACAPI_WRAPPER.swift
//  Flickr
//
//  Created by MacAdmin on 29.09.15.
//  Copyright (c) 2015 Beet Lab. All rights reserved.
//

import Foundation

let kBaseURL = "https://www.flickr.com/services/rest/"
let kAllPhotosEndpoint = "flickr.interestingness.getList"
let kAllPhotoSizes = "flickr.photos.getSizes"
let kApiKey = "3988023e15f45c8d4ef5590261b1dc53"


class ACAPI_WRAPPER: NSObject
{
    // parametera - аргумент - словарь < имя аргумента - значение аргумента > endpoint - начало ссылки - тот скрипт на фликре, к которому обращаемся. На выходе - готовая ссылка в формате https://www.flickr.com/endpoint?имя аргумент=значение аргумента&имя аргумента=значение аргумента...
    private class func composeHTTPRequestWithParameters (parameters : NSDictionary? , endpoint : String ) -> NSURLRequest
    {
        var urlString = kBaseURL + endpoint + "?"
        
        let keysArray = parameters?.allKeys // Берем все ключи из словаря, засовываем в массив
        
        for ( var i = 0 ; i < keysArray?.count ; i++ )
        {
            let key = keysArray![i] as! String // Получаем из массива ключ
            let value = parameters!.objectForKey(key) as! String // Берем значение
            
            if ( i <  keysArray!.count - 1 )
            {
                urlString = urlString + key + "=" + value + "&" // Формируем запрос
            }
            else
            {
                urlString = urlString + key + "=" + value
            }
        }
        
        print("url string : \(urlString)")
        
        let url = NSURL ( string:  urlString )
        
        return NSMutableURLRequest (URL: url!) // Возвращаем объект запроса в интернет
    }
    
    
    
    class func getAllInterstingPhotos ( pageNumber : Int , photosPerPage : Int , success : ( jsonResponce : JSON ) -> Void , failure : ()-> Void )
    {
        let parameteresDictionary = NSMutableDictionary ()
        parameteresDictionary.setObject(kAllPhotosEndpoint, forKey: "method")
        parameteresDictionary.setObject(kApiKey, forKey: "api_key")
        parameteresDictionary.setObject("\(photosPerPage)", forKey: "per_page")
        parameteresDictionary.setObject("\(pageNumber)", forKey: "page")
        parameteresDictionary.setObject("json", forKey: "format")
        parameteresDictionary.setObject("1", forKey: "nojsoncallback")
        
        let request = composeHTTPRequestWithParameters(parameteresDictionary, endpoint: "")
        
        /* request - получили объект класса NSURLRequest */
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            /* В этот блок пришел ответ - data - объект класса NSData - байты, response - объект класса NSURLResponse, error - объект ошибки NSError */
            genericCompletetionHandler(data, response: response, error: error, success: success , failure: failure)
        }
        /* task - объект типа NSURLSessionDataTask */
        
        task.resume()
    }
    
    class func getAllPhotosOfPostWithID ( photoID : String , success : ( jsonResponce : JSON ) -> Void , failure : ()-> Void  ) -> NSURLSessionDataTask
    {
        let paramsDictionary = NSMutableDictionary ()
        paramsDictionary.setObject(photoID, forKey: "photo_id")
        paramsDictionary.setObject("json", forKey: "format")
        paramsDictionary.setObject("1", forKey: "nojsoncallback")
        paramsDictionary.setObject(kAllPhotoSizes, forKey: "method")
        paramsDictionary.setObject(kApiKey, forKey: "api_key")
        
        let request = composeHTTPRequestWithParameters(paramsDictionary, endpoint: "")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            genericCompletetionHandler(data, response: response, error: error , success: success , failure: failure)
            
        }
        
        task.resume()
        
        return task
        
    }
    
    /*
    data - объект класса NSData, байты из интернета
    response - несет стаутс код
    error - сообщение об ошибке
    */
    class func genericCompletetionHandler ( data : NSData? , response : NSURLResponse? , error : NSError? ,  success : ( jsonResponce : JSON ) -> Void , failure : ()-> Void  )
    {
        if ( data != nil )
        {
            let jsonResponce = JSON ( data: data!, options: NSJSONReadingOptions(), error: nil )
            /* конверсия NSData в JSON для дальнейшего парсинга */
            print("internet answer : \(jsonResponce)")
            /* возвращаем результат в success block */
            success ( jsonResponce: jsonResponce )
        }
        else
        {
            failure()
        }
    }
    
}
