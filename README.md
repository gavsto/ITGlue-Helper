# IT Glue Helper
The primary purpose of this repository is to serve as a general place for any helper functions I write to interact with the IT Glue API via Powershell

# Generic IT Glue Flexible Asset Generator
Requirements: "Install-Module ITGlueAPI"

This is designed to do three things:
1) Take any object/hashtable/result or anything you get a result from
2) Generate a new IT Glue Flexible Asset Type based on the structure of that object/hashtable/result
3) Generate the actual flexible assets without needing any fancy formatting

It's meant to be a very quick way of getting data in to IT Glue. It does try to take the property type in to account as well, IE if it's a date it will create a date field in IT Glue. If it's a boolean value, a check box etc.

To get going, replace line 1-6 with your own method of getting your IT Glue Key and if you're not in the EU remove the setting of that as the base URI. Scroll down to line 137 and modify the variables to suit. The example will use Get-Process to generate as an example. Set an organization ID too.

I am posting this in the hope people find use for it, but also help by submitting pull requests to improve it, or by giving ideas on how it can be improved.

