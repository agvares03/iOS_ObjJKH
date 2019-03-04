//
//  Server.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import Foundation

class Server {
    
    // Адрес сервера выберем в зависимости от текущего таргета
    #if isOur_Obj_Home
        static let SERVER          = "http://uk-gkh.org/nashobsdom/"
    #elseif isChist_Dom
        static let SERVER          = "http://uk-gkh.org/chist_dom/"
    #elseif isMupRCMytishi
        static let SERVER          = "http://uk-gkh.org/muprcmytishi/"
    #elseif isDJ
        static let SERVER          = "http://uk-gkh.org/dgservicnew/"
    #elseif isUKKomfort
        static let SERVER          = "http://uk-gkh.org/komfortnew/"
    #elseif isStolitsa
        static let SERVER          = "http://uk-gkh.org/stolitsa/"
    #elseif isKomeks
        static let SERVER          = "http://uk-gkh.org/komeks/"
    #elseif isKlimovsk12
        static let SERVER          = "http://uk-gkh.org/klimovsk12/"
    #elseif isPocket
        static let SERVER          = "http://uk-gkh.org/otherUK/"
    #elseif isReutKomfort
        static let SERVER          = "http://uk-gkh.org/ukrk/"
    #elseif isUKGarant
        static let SERVER          = "http://uk-gkh.org/ukgarant/"
    #else
        static let SERVER          = "http://uk-gkh.org/newjkh/"
    #endif
    
    static let SEND_SUPPORT        = "SendEmailMessage.ashx?"            // Получение настроек для приложения
    
    static let NEW_PASS_LS         = "MobileAPI/SetPersonalAccountPassword.ashx?" //Новый пароль для лиц. счета
    static let GET_MOBILE_MENU     = "GetMobileMenu.ashx?"            // Получение настроек для приложения
    static let ENTER_DJ            = "MobileAPI/AuthenticateAccountDJ.ashx?"   // Авторизация пользователя (ДомЖилСервис)
    static let ENTER               = "AutenticateUserAndroid.ashx?"  // Авторизация пользователя
    static let ENTER_MOBILE        = "MobileAPI/AuthenticateAccount.ashx?"  // Авторизация пользователя
    static let SEND_ID_GOOGLE      = "RegisterClientDevice.ashx?"    // Передача ид устройства для уведомлений
    static let FORGOT              = "remember.ashx?"                // Забыли пароль
    static let GET_APPS_COMM       = "GetRequestWithMessages.ashx?"  // Получить заявки с комментариями
    static let GET_NEWS            = "GetAnnouncements.ashx?"        // Новости
    static let GET_QUESTIONS       = "GetQuestions.ashx?"            // Получение списка опросов
    static let GET_METERS          = "GetMeterValues.ashx?"          // Получить показания по счетчикам
    static let GET_METERS_MUP      = "GetMeterValuesEverydayMode.ashx?" // Получить показания для Мытищ
    static let ADD_METER           = "AddMeterValue.ashx?"           // Добавить показание по счетчику
    static let GET_BILLS_SERVICES  = "GetBillServices.ashx?"         // Получить данные ОСВ (взаиморасчеты)
    static let GET_BILLS_FILE      = "GetBills.ashx?"   // Получить квитанции
    static let GET_BILLS_SERVICES_FULL  = "GetBillServicesFull.ashx?"         // Получить данные ОСВ (взаиморасчеты)
    static let GET_DEBT_ACCOUNT    = "GetDebtByAccount.ashx?"        // Получить задолженности для ДомЖилСервис
    static let GET_LINK_STOLITSA   = "common/pay/EplatPay.aspx?"     // Ссылка на платеж (Столица)
    static let GET_LINK            = "PayOnline.ashx?"               // Ссылка на платеж
    static let GET_PAYMENTS        = "GetPayments.ashx?"             // Получить историю платежей
    static let GET_COMM_ID         = "GetMessages.ashx?"             // Получение комментариев по одной заявке
    static let SEND_COMM           = "chatAddMessage.ashx?"          // Добавить комментарий по заявке
    static let ADD_FILE            = "AddFileToRequest.ashx?"        // Загрузка файла на сервер
    static let GET_REQUEST_TYPES   = "DataExport.ashx?"              // Получение списка типов для заявок
    static let ADD_APP             = "AddRequest_Android.ashx?"      // Создание заявки
    static let GET_WEB_CAMERAS     = "GetHousesWebCams.ashx?"        // Получения списка веб-камер
    static let SAVE_ANSWER         = "SaveUserAnswers_iOS.ashx?"     // Сохранение ответа
    static let CLOSE_APP           = "chatCloseReq.ashx?"            // Закрытие заявки
    static let DOWNLOAD_PIC        = "DownloadRequestFile.ashx?"     // Загрузить пиктограмму файла
    
    static let GET_APP             = "LockRequest.ashx?"             // Принять заявку (консультант)
    static let SEND_COMM_CONS      = "AddConsultantMessage.ashx?"    // Добавить комментарий (консультант) по заявке
    static let CH_CONS             = "ChangeConsultant.ashx?"        // Перевести другому консультанту
    static let GET_CONS            = "getconsultants.ashx?"          // Получить список консультантов
    static let OK_APP              = "PerformRequest.ashx?"          // Выполнить заявку (консультант)
    static let CLOSE_APP_CONS      = "CloseRequestConsultant.ashx?"  // Закрыть заявку (консультант)
    
    // Новая регистрация
    static let REGISTRATION_NEW    = "RegisterAccount.ashx?"         // Новая регистрация
    static let VALIDATE_SMS        = "ValidateCheckCode.ashx?"       // Отправка смс-кода на проверку
    static let SEND_NEW_PASS       = "SetAccountPassword.ashx?"      // Отправка нового пароля
    static let SEND_CHECK_PASS     = "SendCheckCode.ashx?"           // Повторная отправка
    static let GET_STREETS         = "GetHouseStreets.ashx?"         // Подтянуть улицы
    static let GET_NUMBERS_HOUSE   = "GetHouses.ashx?"               // Подтянуть номер домов
    static let GET_HOUSE_DATA      = "GetHouseData.ashx?"            // Подтянуть квартиры по дому
    static let ADD_IDENT_TO_ACCOUNT = "AddIdentToAccount.ashx?"      // Добавить лицевой счет в аккаунт
    static let GET_IDENTS_ACC      = "GetAccountIdents.ashx?"        // Получить лиц. счета по аккаунту
    static let DEL_IDENT_ACC       = "DeleteIdentFromAccount.ashx?"  // Удалить лиц. счет из аккаунта
    static let SET_EMAIL_ACC       = "SetAccountEmail.ashx?"         // Сохранить e-mail 
    
    static let GET_ADDITIONAL_SERVICES = "GetAdditionalServices.ashx?" // Получить дополнительные услуги

    static let MOBILE_API_PATH     = "MobileAPI/"
    
    // Отправка ид для оповещений
    public func send_id_app(id_account: String, token: String) {
        let urlPath = Server.SERVER + Server.SEND_ID_GOOGLE +
            "cid=" + id_account +
            "&did=" + token +
            "&os=" + "iOS" +
            "&version=" + UIDevice.current.systemVersion +
            "&model=" + UIDevice.current.model +
            "&isMobAcc=1"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                              completionHandler: {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    return
                                                }
                                                
                                                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                                                print("token (add) = \(String(describing: responseString))")
                                                
        })
        task.resume()
    }
    
}
