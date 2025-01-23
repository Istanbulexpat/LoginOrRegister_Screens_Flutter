# LoginOrRegister_Screens_Flutter
These are simple flutter screens with logic for sending users either to a login screen or a Register Screen.


# LoginOrRegister.dart 
This provides simple logic that determines if the user simply requires a Login Screen or the Register Screen, and sends them to that respective screen.

# LoginScreen.dart 
This screen provides a simple login screen to login using email and password, using Google sign on, 
or using Apply Sign on. This screen utilizes Google Authentication for all three. The user must have already created 
a username and password using the Register screen if they choose to use that path.  Otherwise, Google Sign on and 
Apple Sign on will work the first time the user enters.

# RegisterScreen.dart 
This screen provides a simple Register screen to login using email and password, using Google sign on, 
or using Apply Sign on. This screen utilizes Google Authentication for all three. The user must type in the password twice,
and is authenticated uswing Google authentication. Otherwise, Google Sign on and Apple Sign on will work the first time the user enters.

# Textfield.dart 
This screen is a component for the email and password text fields, and is brought into
the LoginScreen.dart and RegisterScreen.dart

# LoginPasskey.dart
This was an early attempt at building authentication using Passkeys. At the time of writing, Passkeys were still 'catching on' 
and documentation was spurious at best. This code never made it to production, but is a good start based on Google, Apple, 
and Email authentication as a beginning structure, and has similarities to the LoginScreen file in this repo.

# LoginIntroScreen.dart 
This screen provides an example that can be used as an onboarding screen.
It allows the user two options/buttons - to Sign In or Sign up.
Those two buttons can be used to push user to those respective login screens in this repo.

# Other edits that can be made to these screens:
1. You will need to replace the logo at top with logo or image of your choice, or you can remove entirely
2. The screen contains a 3-4 color linear gradient that you can adjust with your own color scheme.
3. All buttons, text fields are aligned to center vertically and horizontally.
