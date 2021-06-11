## Version 2.0
## language: en

Feature: JWT - Revoked token
  Site:
    root-me.org
  Category:
    Web-Server
  User:
    rocken2k
  Goal:
    Get an access to the admin endpoint

  Background:
  Hacker's software:
    | <Software name> | <Version>     |
    | Kali Linux      | 5.10.         |
    | Firefox Quantum | 68.2.0esr     |
    | Burp Suite      | v2020.12.1    |
    | QTerminal       | 0.14.1        |

  Machine information:
    Given I am accessing the website through the URL
    """
    http://challenge01.root-me.org/web-serveur/ch63/
    """
    Then I see the homepage with information for requests [evidence](1.png)

  Scenario: Fail: Following the initial instructions to get the flag
    Given the instruction for POST and GET requests
    Then I open Burp Suite to intercept the requests
    And I ask to reload the page
    And I can intercept the request in Burp Suite
    When I send a POST request to "/login"
    Then I see a "Bad Request" message with some instructions [evidence](2.png)
    And I send another POST request with the instruction
    And I see "Bad Request" message again [evidence](3.png)
    And I can't solve the challenge

  Scenario: Fail: Trying to submit the token
    Given the title of the challenge is "JWT - Revoked token"
    Then I try to get the token through a "curl request"
    When I send a curl request with the following information
    """
    curl -H "Content-Type: Application/json" -X POST -d '{"username":"admin",
    "password":"admin"}' http://challenge01.root-me.org/web-serveur/ch63/login
    """
    Then I can see the "access_token" value [evidence](4.png)
    And I submit a GET request with the token value
    And I get a "Missing Authorization Header" message [evidence](5.png)
    And I can't solve the challenge

  Scenario: Success: Sending the token
    Given that I got a "Missing Authorization Header" message
    Then I look up on the internet how to properly submit authorization's type
    And I find the syntax [evidence](6.png)
    When I properly submit the GET request with the token
    Then I get a "Token is revoked" message [evidence](7.png)
    And I search on google other ways to submit JWT token
    And after some tries, I submit the token with an extra space in the end
    And I replace the extra space for "=" like base64 encoding
    When I send the get request with the modified token
    Then I can see the flag [evidence](8.png)
    And I submit the flag
    And I solve the challenge [evidence](9.png)
