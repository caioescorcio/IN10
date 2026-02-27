*** Settings ***
Library    RequestsLibrary
Library    Collections
Test Setup    mon premier keyword    Hello World
Test Teardown    Log To Console    Fin du test
    

*** Test Cases ***

Chuck Norris
    Create Session    maSession    https://api.chucknorris.io
    ${resp}   GET On Session   maSession   /jokes/random   expected_status=200
    Log To Console    ${resp.json()}[value]

test blague
    Create Session    maSession    https://api.chucknorris.io  disable_warnings=1
    ${resp}   GET On Session   maSession   /jokes/categories   expected_status=200
    FOR   ${elt}   IN  @{resp.json()}
      Verifier Chuck dans la blague de categorie   ${elt} 
    END


test dictionary
    Create Session    maSession    https://api.chucknorris.io  disable_warnings=1
    ${resp}   GET On Session   maSession   /jokes/random   expected_status=200
    ${values}   Get From Dictionary   ${resp.json()}   value
    Log To Console    ${values}
    
renvoyer une blague au hasard
    renvoyer une blague au hasard

Quick Get Request with parameters
    Create Session    maSession    https://api.chucknorris.io  disable_warnings=1
    ${resp}   GET On Session   maSession   /jokes/random   params=category=dev   expected_status=200
    Log To Console    ${resp.json()}[value] 

test category
    ${resp}   renvoyer les categories de blagues
    Should Contain    ${resp}    dev
    Should Contain    ${resp}    animal
    FOR   ${elt}   IN  @{resp}
      Log To Console    ${elt}
    END
    
*** Keywords ***
mon premier keyword
    [Arguments]  ${mot}
    Log To Console    ${mot} mon mot cle complique
    RETURN   J'ai réussi    

Verifier Chuck dans la blague de categorie
  [Arguments]   ${category}
    ${resp}   GET On Session   maSession   /jokes/random   params=category=${category}
    Should Contain    ${resp.json()}[value]    Chuck

renvoyer une blague au hasard
    Create Session    maSession    https://api.chucknorris.io  disable_warnings=1
    ${resp}   GET On Session   maSession   /jokes/random   expected_status=200
    Log To Console    ${resp.json()}[value]

renvoyer les categories de blagues
    Create Session    maSession    https://api.chucknorris.io  disable_warnings=1
    ${resp}   GET On Session   maSession   /jokes/categories   expected_status=200
    Log To Console    ${resp.json()}
    RETURN    ${resp.json()}