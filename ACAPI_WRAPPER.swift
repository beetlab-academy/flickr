//
//  ACAPI_WRAPPER.swift
//  Flickr
//
//  Created by User on 29.09.15.
//  Copyright © 2015 qswitch. All rights reserved.
//

import Foundation

//задаем константы
let kBaseURL = "https://api.flickr.com/services/rest/"
let kAllPhotosEndPoint = "flickr.interestingness.getList"
let kAllPhotosInt = "flickr.photos.getSizes"
let kApiKey = "7e06580ecebf8565cc46e3beff87abde"

class ACAPI_WRAPPER: NSObject
{
    // parameters - аргумент - словарь <имя аргумента - значение агрумента> endpoint - начало ссылки - тот скрипт на фликре к которому мы обращемеся. На выходе готовая ссылка в формате https://www.flickr.com/<endpoint>?<имя аргумента из словаря=значение аргумента>&<имя аргумента из словаря=значение аргумента>....
    private class func composeHTTPRequestWithParameters (parameters : NSDictionary? , endpoint : String ) -> NSURLRequest
    {
        var urlString = kBaseURL + endpoint + "?" //Формируем начало ссылки
        
        let keysArray = parameters?.allKeys //Берем все ключи из словаря и засовываем в массив keysArray
        
        for ( var i = 0 ; i < keysArray?.count ; i++) // Цикл
        {

            let key = keysArray![i] as! String //Получаем i-ый ключ из массива
            let value = parameters!.objectForKey(key) as! String //Получаем значение из массива по ключу

            if ( i < keysArray!.count - 1) // Проверяем, дошли до конца массива или нет
            {
                urlString = urlString + key + "=" + value + "&" //Формируем запрос по частям если не конец
            }
            else
            {
                urlString = urlString + key + "=" + value // Добавляем в запрос последнее значение (без &)
            }
        }
        
        print("url string : \(urlString)") // Печатаем полученный запрос для проверки
        
        let url = NSURL (string: urlString) // Приводим сформированный запрос к формату NSURL (оборачиваем к класс NSURL)
        
        return NSMutableURLRequest (URL: url!) //Возвращаем объект запросf в интернет (mutable - можем менять)
        
    }
    
    class func getAllInterestingPhotos ( pageNumber : Int , photosPerPage : Int , success : ( jsonResponse : JSON) -> Void , failure : () -> Void)
    {
        let parameteresDictionary = NSMutableDictionary ()
        parameteresDictionary.setObject(kAllPhotosEndPoint, forKey : "method")
        parameteresDictionary.setObject(kApiKey, forKey: "api_key")
        parameteresDictionary.setObject("\(photosPerPage)", forKey: "per_page")
        parameteresDictionary.setObject("\(pageNumber)", forKey: "page")
        parameteresDictionary.setObject("json", forKey: "format")
        parameteresDictionary.setObject("1", forKey: "nojsoncallback")
        
        let request = composeHTTPRequestWithParameters(parameteresDictionary, endpoint: "") //request - получили объект классса NSURLRequest
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data , responce , error) -> Void in
            
            // в этот БЛОК приходи ответ из интернета. data - объект класса NSData - байты из интернета. responce - объект класса NSURLResponce (содержит статус ошибки, статус сообщения и пр.). error - объект ошибки класса NSError (содержит код ошибки).
            genericCompletionHandler(data , response: responce , ErrorType: error , success : success , failure : failure)
            
        } //task  - объект типа NSURLSessionDataTask
        
        task.resume() // начало запроса в интернет ( отправка запроса в интернет )

    }
    
    class func getAllPhototsPostWithID ( photoID : String , success : ( jsonResponse : JSON) -> Void , failure : () -> Void) -> NSURLSessionDataTask
    {
        let parameteresDictionary = NSMutableDictionary()
        parameteresDictionary.setObject(kAllPhotosInt, forKey : "method")
        parameteresDictionary.setObject(kApiKey, forKey: "api_key")
        parameteresDictionary.setObject("\(photoID)", forKey: "photo_id")
        parameteresDictionary.setObject("json", forKey: "format")
        parameteresDictionary.setObject("1", forKey: "nojsoncallback")
        
        let request = composeHTTPRequestWithParameters(parameteresDictionary, endpoint: "")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data , responce , error) -> Void in
        
            genericCompletionHandler(data , response: responce , ErrorType: error , success : success , failure : failure)

        }
        
        task.resume()
        
        return task // Возвращаем task для того чтобы была возможность отменить загрузку

    }

    
    // data - объект класса NSData (байты из интернета).
    // responce - объект класса NSURLResponce (содержит статус ошибки, статус сообщения и пр.). 
    // error - объект ошибки класса NSError (содержит код ошибки).
    
    class func genericCompletionHandler ( data : NSData? , response : NSURLResponse?, ErrorType : NSError? , success : ( jsonResponse : JSON) -> Void , failure : () -> Void)
    {
        if ( data != nil) // Если данные не пустые
        {
            let jsonResponse = JSON ( data: data!, options: NSJSONReadingOptions(), error: nil ) // конвертируем пришедшие данные из формата NSData в формат JSON для дальнейшего парсинга
            print("internet answer : json response: \(jsonResponse)") // Печатаем  результаты запроса для проверки
            success ( jsonResponse: jsonResponse) // Возвращаем результаты в success block
        }
        else
        {
            failure()
        }
    }
}
