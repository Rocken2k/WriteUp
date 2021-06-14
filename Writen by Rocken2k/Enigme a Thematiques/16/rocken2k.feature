## Version 2.0
## language: en

Feature: 16-G33K-enigmes-a-thematiques
  Code:
    16
  Site:
    enigmes-a-thematiques
  Category:
    G33K
  User:
    rocken2k
  Goal:
    Find the hidden file

  Background:
  Hacker's software:
    | <Software name> | <Version>     |
    | Kali Linux      | 5.10.         |
    | Firefox Quantum | 68.2.0esr     |
    | Gobuster        | 3.1.0         |

  Machine information:
    Given I am accessing the website through the URL
    """
    https://enigmes-a-thematiques.fr/front/enigme/16
    """
    And I see a puzzle [evidence](1.png)

  Scenario: Fail: Try to interact with the page
    Given the puzzle
    When I click on the image
    Then a pop-up is open
    And I maximize the pop-up
    Then I see full url [evidence](2.png)
    And I delete all the "/"
    Then I translate the sentence "le mot de pase est dans un de ces dossiers"
    And the translation is "the password is in one of these folders"
    Then I translate the phrase inside the pop-up
    And the message says "Look well!"
    And I can't solve the challenge

  Scenario: Fail: Try to find the file on a secret folder
    Given the information from the translated url
    When I go to
    """
    https://enigmes-a-thematiques.fr/web/enigmes/epreuve16
    """
    Then I perform a gobuster scanner to find directories
    And I find one directory called "le" [evidence](3.png)
    Then on the directory "le" I found file "indication 1" [evidence](4.png)
    And I can't solve the challenge

  Scenario: Fail: Try to find the file on the given folders
    Given the information from the translated url
    When I realize that I could navigate through the directories
    Then I stat navigate through the directories
    And on to the directory "/mot" I find the file mdp.txt [evidence](5.png)
    And on directory "de" I find the message "Still not in the right place"
    And on the directory "/passe" I find file "indication 2" [evidence](6.png)
    And on the directory "/est" i find file "indication 3" [evidence](7.png)
    And on the directory "/dans" I find file "indication 4" [evidence](8.png)
    And on the directory "/un" I find file "indication 5" [evidence](9.png)
    And on the directory "/ces" I find file "indication 6" [evidence](10.png)
    And I can't solve the challenge

  Scenario: Fail: Try to find the file on the main directory
    Given the information from indication 6
    When I go to the first directory on the url
    """
    https://enigmes-a-thematiques.fr/web/enigmes/epreuve16
    """
    Then I try to access the directory /pass
    And I got a page not found error [evidence](11.png)
    And I can't solve the challenge

  Scenario: Fail: Try to interpret the indications
    Given the indication 5 that the file is in a "hotter file"
    And I realize that hotter is what is burning what lead me to indication 3
    Then I try to access the directory "/est/pass"
    And I get the same error "page not found"
    And I can't solve the challenge

  Scenario: Success: Try the technic to hide files from Linux
    Given the indication 5 that the file "hidden"
    When I remember to hide a file in Linux you need to put a dot in front
    Then I try to access the path using "." in front of the name
    And I find the answered [evidence](12.png)
    And I solve the challenge [evidence](13.png)
