# frontend

A new Flutter application: My Medical Secretary

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Main functions and related files

### ```~/{projectname}/frontend/lib/screens/login.dart```  

This file is designed to realise the following functions:User login, change password, forget user name. 
For the extended functions, we added user verification function and forget password option.

### ```~/{projectname}/frontend/lib/screens/register.dart```  

This file is mainly used to user registration function. And for the extended function, we added the user verification function. When the user has no right to register or the email has already been registered, there will be a dialog to let the user know why he/she can not register successfully.

### ```~/{projectname}/frontend/lib/screens/appiontmentfile.dart``` 

This part is mainly used to display the user's appointment pdf file and its sharing. The sharing function is a new function we added. The relative code is in the following function and we chose to share the pdf file by its url:
'''Future<void> _sharepdfFromUrl() async {...}'''

### ```~/{projectname}/frontend/lib/screens/doctordetial.dart``` 




