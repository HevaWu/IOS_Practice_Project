# IOS-Pratice-MusicLover

This project finishing the basic IOS Tutorial. 

## The Music Model:
Properties:
* var name: String
* var photo: UIImage?
* var rating: Int
* var animatedImage: FLAnimatedImage?
* var photoURLString: String?
* var isGif: Bool = false

## In my local file and web server file:
Properties:
* var name: String
* var rating: Int
* var photoURLString: String?

Other properties in Music Model, we could using function in the music model to get them

## Implementing the bellow requirements:
1. Basic Tutorial,(Using TableView to arrange the objects, implement the ranking method)
* Using SDWebImageManager() to manage the image
* Using UIStackView to actualize the RatingControl
2. Not only for static image, implement to load/download the "gif" dynamic image.
  * Change the photoImageView to FLAnimatedImageView to actualize display the animated image
 *  FLAnimatedImageView using 
3. Implement store data into local file(music.json)
  * In MusicTableViewController.loadMusics() function
  * Using JSONEncoder and JSONDecoder to encode and decode JSON data
  * The File path achieved by 
  * * static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  * * static let ArchiveURL = DocumentsDirectory.appendingPathComponent("musics.json")
4. Implement store data into web server(http://127.0.0.1:8000/musics/)
  * Using Django Rest Framework to implement the web local server
  * In Django/ Folder, is the implement of this server. It's using python language to implement.
  * In MusicTableViewController.getDataFromMockServer() and MusicTableViewController.postDataToMockServer(), achieve the GET method and POST method
  * Attention: don't forget using DispatchQueue.main.async() to asynchronous the self.tableView.reloadData(). This make sure there is something shows in our simulator

## Run:
1. install cocoapod, go to the project folder, run "pod install"
2. start the server, do bellow comands in terminal
   
   `install python and virtualenv`
   
   ` Go to Django folder`
   
   `virtual -p /usr/local/bin/python3 venv`
  
   `source venv/bin/activate`
  
   `pip install Django`
  
   `sudo easy_install pip`
  
   `touch requirements.txt`
  
   `pip freeze > requirements.txt`
  
   `django-admin startproject config`
   
   `pip install djangorestframework`
  
   `go to /config/config/settings.py
  INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles', # Ensure a comma ends this line
    'rest_framework', # Add this line
  ]`
  
   `cd into the folder where manage.py file is, python3 manage.py startapp api
  INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'api', # Add this line
  ]`
  
    I have already finishing the model, view, and url part, if don't change it, go!
   `cd into the manage.py file, `
   
   `python3 manage.py makemigrations`
   
   `python3 manage,py migrate`
   
   `without error, run the server!`
   
   `python3 manage.py runserver`
   
3. After setting the server, run the project in MusicLover.xcworkspace
4. Could Add/Delete/Save object, for web server, could check it through open the url link(http://127.0.0.1:8000/musics/), for local server, uncommand the line under "load data local", and command the line under "load data by url server"

reference link: https://scotch.io/tutorials/build-a-rest-api-with-django-a-test-driven-approach-part-1
