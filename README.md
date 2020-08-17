# IT Glue Helper
The primary purpose of this repository is to serve as a general place for any helper functions I write to interact with the IT Glue API via Powershell

# IT Glue BootStrap Panel Generator
This is two helper functions that can be used in your IT Glue scripts to generate pretty panels in Flexible Assets. I use this in combination with the Manage API
at https://github.com/christaylorcodes/ConnectWiseManageAPI to Auto document the services we have so our engineers have one page to visually see what services
our client has. You can see a redacted version of what this looks like in IT Glue here: https://i.imgur.com/DKm1aM8.png. We also tie in to 365 with the same script
and bring back things like 2FA stats and active e-mail domains.

You only need to take the functions away from this module. Everything past Line 147 is just code to generate a test HTML to show how the solution works.
It will generate a HTML file on your desktop that gives a rough idea of what it looks like in the Flexible Asset.

The code in this module does not cover generating the flexible asset. Please see https://github.com/itglue/powershellwrapper

See https://www.cyberdrain.com/ for examples on how to interact with the IT Glue API.


# Generic IT Glue Flexible Asset Generator
Requirements: "Install-Module ITGlueAPI"

This is designed to do three things:
1) Take any object/hashtable/result or anything you get a result from
2) Generate a new IT Glue Flexible Asset Type based on the structure of that object/hashtable/result
3) Generate the actual flexible assets without needing any fancy formatting

It's meant to be a very quick way of getting data in to IT Glue. It does try to take the property type in to account as well, IE if it's a date it will create a date field in IT Glue. If it's a boolean value, a check box etc.

To get going, replace line 1-6 with your own method of getting your IT Glue Key and if you're not in the EU remove the setting of that as the base URI. Scroll down to line 137 and modify the variables to suit. The example will use Get-Process to generate as an example. Set an organization ID too.

I am posting this in the hope people find use for it, but also help by submitting pull requests to improve it, or by giving ideas on how it can be improved.

