//
//  MPInterviewUITests.swift
//  MPInterviewUITests
//
//  Created by Marcos Luiz on 29/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import XCTest

class MPInterviewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        app.launchArguments.append("--uitesting")
    }
    
    func testShowCreditCardWidgetInHome(){
        app.launch()
        
        // titulo ok
        XCTAssertTrue(app.staticTexts["Olá Fulano!"].waitForExistence(timeout: 1))
        
        // widget meu cartão na tela
        XCTAssertTrue(app.staticTexts["Meu cartão"].waitForExistence(timeout: 1))
        
        // widget conta/estrato na tela
        XCTAssertTrue(app.staticTexts["Meu saldo"].waitForExistence(timeout: 1))
                             
        
    }
    
    func testShowCreditCardScreenAndGoBack(){
        
        app.launch()
        
        // eperar o botão de detalhes do cartão e clicar
        XCTAssertTrue(app.buttons["Ver detalhes"].waitForExistence(timeout: 1))
        let showDetailCardButton = app.buttons["Ver detalhes"]
        showDetailCardButton.tap()
            
        // title é Cartão
        XCTAssertTrue(app.navigationBars["Cartão"].waitForExistence(timeout: 1))
        
        // verifica informações na tela
        XCTAssertTrue(app.staticTexts["Teste Fulano Ciclano"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["Limite disponível: R$ 3.000,00"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["Limite total: R$ 5.000,00"].waitForExistence(timeout: 1))
        
        // volta para a home
        app.navigationBars.buttons["Back"].tap()
        
        // verifica se voltou
        XCTAssertTrue(app.staticTexts["Olá Fulano!"].waitForExistence(timeout: 1))
        
        
    }
      
    // este testo vai falhar por conta de um erro ortográfico retornado pela api
    func testShowStatementScreenAndGoBack(){
        
        app.launch()
        
        // eperar o botão de detalhes do cartão e clicar
        XCTAssertTrue(app.buttons["Ver extrato"].waitForExistence(timeout: 1))
        let showDetailCardButton = app.buttons["Ver extrato"]
        showDetailCardButton.tap()
            
        // title é Cartão
        XCTAssertTrue(app.navigationBars["Extrato"].waitForExistence(timeout: 1))
         
        //
        XCTAssertTrue(app.staticTexts["Saldo disponível"].waitForExistence(timeout: 1)) // este teste esta vindo errado da api portanto vai dar erro
        
        // verifica informações na tela
        XCTAssertTrue(app.staticTexts["Transferência enviada"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["- R$ 500,00"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["Teste fulano ciclano"].waitForExistence(timeout: 1))
        
        //
        XCTAssertTrue(app.staticTexts["Transferência recebida"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["+ R$ 2000,00"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.staticTexts["Movile Pay"].waitForExistence(timeout: 1))
        
        // volta para a home
        app.navigationBars.buttons["Back"].tap()
        
        // verifica se voltou
        XCTAssertTrue(app.staticTexts["Olá Fulano!"].waitForExistence(timeout: 1))
                
    }


}
