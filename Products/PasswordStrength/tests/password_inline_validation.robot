*** Settings ***
Resource  plone/app/robotframework/keywords.robot
Resource  plone/app/robotframework/selenium.robot
Resource  plone/app/robotframework/saucelabs.robot
Resource  Products/PasswordStrength/tests/common.robot

Library  Remote  ${PLONE_URL}/RobotRemote
Library  plone.app.robotframework.keywords.Debugging

Test Setup  Test Setup
Test Teardown  Close all browsers

*** Test Cases ***

Test register form
    Go to  ${PLONE_URL}/@@register
    # Contains password description ?
    Hint for  Password  Element should contain  Minimum 1 capital letter.
    # Fill form
    Input for  User name  Input text  rocky
    Input for  E-mail  Input text  rocky@balboa.com
    # Reacts with bad password
    Input for  Password  Input text  12345
    Input for  Confirm password  Input text  12345
    Input for  Confirm password  Click element
    Error for  Password  Element should be visible
    Error for  Password  Element should contain   This password doesn't match requirements for passwords
    Error for  Confirm password  Element should be visible
    Error for  Confirm password  Element should contain  This password doesn't match requirements for passwords
    # Accepts well formed password
    Input for  Password  Input text  ABCDEFGHIJabcdefghij1!
    Input for  Confirm password  Input text  ABCDEFGHIJabcdefghij1!
    Click element  css=#formfield-form-email
    Error for  Password  Element should not be visible
    Error for  Confirm password  Element should not be visible
    Click button  Register
    # Redirected
    Wait until page contains  Welcome  5
    Element should contain  css=h1.documentFirstHeading  Welcome

Test new user form
    Enable autologin as  Manager
    Go to  ${PLONE_URL}/@@new-user
    # Contains password description ?
    Hint for  Password  Element should contain  Minimum 1 capital letter.
    # Fill form
    Input for  User Name  Input text  rocky
    Input for  E-mail  Input text  rocky@balboa.com
    # Reacts with bad password
    Input for  Password  Input text  12345
    Input for  Confirm password  Input text  12345
    Input for  Confirm password  Click element
    Error for  Password  Element should be visible
    Error for  Password  Element should contain  This password doesn't match requirements for passwords
    Error for  Confirm password  Element should be visible
    Error for  Element should contain  This password doesn't match requirements for passwords
    # Accepts well formed password
    Input for  Password  Input text  ABCDEFGHIJabcdefghij1!
    Input for  Confirm password  Input text  ABCDEFGHIJabcdefghij1!
    Click element  Add user
    Error for  Password  Element should not be visible
    Error for  Confirm password  Element should not be visible
    Click button  Register
    # Redirected
    Wait until page contains  Users and Groups  5
    Element should contain  css=h1.documentFirstHeading  Users and Groups
    Page should contain element  css=input[value="rocky"]
    Disable autologin

Test change password form with inline validation
    Test change password form

Test register form without password with inline validation
    Test register form without password

Test reset form with inline validation
    Test reset form

*** Keywords ***
Test Setup
    Open SauceLabs test browser
    Go to  ${PLONE_URL}
    Enable autologin as  Manager
    The self registration enabled
    The mail setup configured
    Own passwords registration enabled
    The inline validation enabled
    ${plone_version} =  Get plone version
    Set global variable  ${plone_version}
    Disable autologin
