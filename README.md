# KopiMate
KopiMate, an NUS SoC Orbital 2023 Project

<!-----

You have some errors, warnings, or alerts. If you are using reckless mode, turn it off to see inline alerts.
* ERRORs: 0
* WARNINGs: 0
* ALERTS: 5

Conversion time: 2.307 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β34
* Sun Jul 23 2023 22:53:30 GMT-0700 (PDT)
* Source doc: KopiMate - Project README
* This document has images: check for >>>>>  gd2md-html alert:  inline image link in generated source and store images to your server. NOTE: Images in exported zip file from Google Docs may not appear in  the same order as they do in your doc. Please check the images!


WARNING:
You have 4 H1 headings. You may want to use the "H1 -> H2" option to demote all headings by one level.

----->


<p style="color: red; font-weight: bold">>>>>>  gd2md-html alert:  ERRORs: 0; WARNINGs: 1; ALERTS: 5.</p>
<ul style="color: red; font-weight: bold"><li>See top comment block for details on ERRORs and WARNINGs. <li>In the converted Markdown or HTML, search for inline alerts that start with >>>>>  gd2md-html alert:  for specific instances that need correction.</ul>

<p style="color: red; font-weight: bold">Links to alert messages:</p><a href="#gdcalert1">alert1</a>
<a href="#gdcalert2">alert2</a>
<a href="#gdcalert3">alert3</a>
<a href="#gdcalert4">alert4</a>
<a href="#gdcalert5">alert5</a>

<p style="color: red; font-weight: bold">>>>>> PLEASE check and correct alert issues and delete this message and the inline alerts.<hr></p>



# **KopiMate **an NUS SoC Orbital 2023 Project


# Project README

<p style="text-align: right">
By: Kotaro Yong and Huang Yueqian</p>


<p style="text-align: right">
Level of Achievement: Apollo 11</p>



---

**Download the Milestone 3 Release Android APK for testing here: [https://github.com/yueqianh/KopiMate/releases/tag/v0.3](https://github.com/yueqianh/KopiMate/releases/tag/v0.3)   **


# Part 1. Introduction


## 1.1 Project Scope

(One sentence) An informative app that lists nearby coffee shops/cafes/roasters and integrates social features for sharing.

(Longer) An informative app that contains a database of many coffee shops/cafes/roasters in Singapore, so that users can easily look up for one they wish to visit. The app also has a social feature that allows coffee shop owners and customers to share anything about coffee.


## 1.2 Target audience

The target audience of this project is coffee shop owners in Singapore, as well as any member of the public interested in Singapore’s local coffee scene.


## 1.3 Why this app?

For the majority, coffee is more likened to a quick way to start the day rather than something to be slowly enjoyed. They have underappreciated the beauty of coffee.

At the same time, there is a growing movement of specialty coffee shops and roasters in Singapore. However it is difficult for them to garner popularity amongst the myriad of restaurants in Singapore.

Furthermore, as beginners who just scratched the surface of coffee making, when we try to brew a cup of coffee ourselves, we found it quite troublesome to find this information. There were all kinds of devices and methods. We realised there was a need for a centralised system to make it easier to access this knowledge.


## 1.4 How our app solves the problem

By integrating features like sharing of coffee culture and brewing techniques into our app, we aim to accelerate the spread of awareness and appreciation for coffee in the local scene.

We also hope to help coffee lovers connect with each other in sharing techniques, experiences and recipes. The application can offer a clean and standardised user interface to make content sharing easier. There is no more hassle of going on to different internet forums to search for answers.


## 1.5 User Stories



* As an average Singaporean who consumes coffee on a daily basis but does not know the rich culture behind coffee making, I can use the application to learn more about the coffee’s origin and development, as well as the latest local movements by coffee lovers.
* As an experienced coffee lover, I can connect directly with other coffee lovers and share our techniques and recipes in a standardised format, so there is no more hassle of going on to different internet forums to search for answers.
* As a beginner who just entered the scene of coffee making, I can access a database of the best practices and guides when making coffee, as well as learning from the experiences of experts in coffee making.


# Part 2. Design and Implementation


## 2.1 Features



* Login page where users can sign up with their emails. Data will be stored in a Firebase cloud.
* The Nearby Shops page fetches shop info from the Firestore (NoSQL) and populates a list for a user to view. Upon tapping on the shop listing, the user is taken to the Google Maps search result for that particular shop.
* A forum for coffee lovers to post their knowledge in how to brew that type of coffee and an online shop that lists nearby roasters and their stock of beans.
* We aim to complete the forum for coffee lovers to do content sharing and an online shop that lists nearby roasters and their stock of beans.
* We also aim to improve the Nearby page, adding more information about the coffee shops as well as enabling the ability for users to see their actual nearby shops.


## 2.2 Use Cases


### Use Case 1: Using the “Nearby Shops” Feature



* **System**: KopiMate 
* **Primary Actor**: Members of public wishing to find cafes/coffee shops nearby
* **Scenario**: The user browses through the list of shops listed in the Nearby screen of the app. Based on their current location, he/she selects cafes/coffee shops closest to them and taps to find out more. After confirming that the shop has his/her intended type of coffee (e.g. specialty brewed coffee), he/she taps on the location and is brought to Google Maps for a turn-by-turn direction to that shop.


### Use Case 2: Using the “Forum” Feature



* **System**: KopiMate 
* **Primary Actor**: Members of public wishing to share or learn about different types of coffee
* **Scenario**: The user creates an account on KopiMate using his/her email and accesses the Forum page. He/She chooses a coffee forum that he/she is interested in (e.g. Latte) and taps to enter it. He/She finds some of the posts by others helpful and presses the Like button to show his/her support. He/She then follows up with a comment thanking the author of the post. He/She then realises that there is another question unaddressed in the forum. He/She proceeds to draft the question in the textbox and then publishes in the forum, waiting for other users’ reply.


## 2.3 Tech Stack and Architecture



* Flutter (Frontend) using Dart language
* Firebase (Backend), including Cloud Firestore as NoSQL database, Firebase Storage as cloud storage, Firebase Authentication as account management and authentication system
* Google Maps API

_Architecture Diagram_




## 2.4 App Usage Flow Chart



1. Browsing Nearby Shops
2. Existing User Login


### 



3. Register / Forgot Password
4. Posting, Liking, Commenting, Deleting Posts in Forum




## 2.5 Sequence Diagrams

_Sequence diagram for Register process_

_Sequence diagram for Login process_

_Sequence diagram for posting activities in the Espresso Forum_




## 2.6 Design Principles



* **Dry principle: **Instead of duplicating complex logic, we encapsulated it in classes that could be reused. This allowed us to instantiate the class whenever we needed that specific functionality, rather than rewriting the same logic. For instance, the logic for the posts were encapsulated in a widget to be used throughout the different pages.
* **YAGNI principle:** We defined the minimum viable product (MVP) that needed to be implemented to meet the project's goals. This has helped in avoiding unnecessary work on non-essential features.


## 2.7 Design Pattern



* **Model view controller (MVC) pattern**

**	**

	

In this example, we have three main components of the MVC pattern:


    **Model:** The Forum class stores the messages different users have posted.


    **View:** The StreamBuilder is responsible for rendering the posts to the user interface. In this case, it simply displays the posts on the app.


    **Controller:** The textController acts as the intermediary between the model and the view. It receives user input and updates the model accordingly. It also communicates with the view to display the posts on the forum.


## 2.8 Coding Standards



* **Use appropriate naming conventions: **We meaningfully named variables, functions, classes, and other elements in our code. By doing this, it becomes easier to grasp their functionality which leads to faster comprehension by other users.
* **Formatting: **We used a Dart extension in VSCode to ensure that our code is properly indented with appropriate spacing.


# Part 3. Testing


## 3.1 Unit Testing

We created multiple test files for Unit Testing and Widget Testing for the Flutter Project. These test files are stored in the “test” folder of the project directory. Passed tests are shown with the green tick to the left of the line number.

**Unit Test 1: Testing that button has text.**



<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")


**Unit Test 2: Testing that the formatDate function converts DateTime from Cloud Firestore to date-time strings in the “DD/M/YYYY” format.**



<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image2.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image2.png "image_tooltip")





## 3.2 System Testing


### Test Case 1: Incorrect credentials for login page

Keying in an unregistered email/password will display the corresponding error and the user is unable to login.


### Test Case 2: Invalid credentials for register page

Keying in a invalid email/registered email address/unmatching passwords will display the corresponding error and the user is unable to create an account on KopiMate.


### Test Case 3: Trying to post an empty message

Trying to post an empty message will display the corresponding error and prevent it from being posted on the forum.


### Test Case 4: Trying to add a shop with no image

Trying to add a shop with no image will show the corresponding error and prevent it from being added to Firestore.




## 3.3 Integration Testing 

Utilising the Firebase test lab feature, our app was able to pass the robo test on multiple Android models.



<p id="gdcalert3" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image3.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert4">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image3.png "image_tooltip")




<p id="gdcalert4" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image4.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert5">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image4.png "image_tooltip")


Furthermore, we conducted several tests to verify the synchronisation of data between the UI and the Firestore database. 


### Test 1: Adding a user from Firebase Authentication

A user that was added through Firebase Authentication platform was able to login to KopiMate, thus displaying data synchronisation between the two systems.



<p id="gdcalert5" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image5.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert6">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image5.png "image_tooltip")





### Test 2: Creating posts from the Firestore database

Upon creating a post document from Firebase, the UI similarly displayed that post, hence showing that there was effective communication between the two systems.


## 3.4 User Acceptance Testing

We recruited a diverse group of coffee enthusiasts to collect feedback on usability and functionality of our app.

**Positive feedback:**

Users enjoyed the sleek design of the nearby shops page and how easy it was to navigate through the different shops and access their information. They also liked the forums page rustic feel and the 

**Negative feedback:**

Some felt that the forums page could include more types of coffee. These improvements will be implemented in the future.




# Part 4. Development Plan

As of Milestone 3, we have completed all the main objectives we set out to achieve with the KopiMate app. These objectives include:



* A Nearby Shops page displaying a catalogue of specialty coffee shops, along with their locations on map, address, rating, phone number and website.
* Ability to show the user's current location and display nearby shops.
* A Forum page displaying the various forums for users to post and comment. Ability to like posts and delete posts.
* A user authentication system requires the user to sign up / log in with their email address or Google account, before being allowed to post on the forums.

Looking ahead to Splashtown, we aim to continue fixing bugs and implement the following enhancements:



* When a user provides his/her current location, rank the list of stores based on the store’s distance from the user.
* Linking the selection of a shop marker on Google Maps to the details page of that shop.
