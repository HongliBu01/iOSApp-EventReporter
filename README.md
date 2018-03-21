# Final Project

Discover

## Third-Party Framework:
### Firebase
Official Website: https://firebase.google.com/docs/ios/setup<br>
In the project, we use FirebaseDatabase as the datasase to save and retrieve user and event data.<br>
1.Installation:<br>
(1) setup CocoaPods and in the Podfile, add "pod "Firebase/core""<br>
(2) pod install<br>
2. populate database:<br>
 (1)get instance reference by "Database.database().reference().child("posts")"<br>
 (2) set value for "user"of firebase by "ref.child("users").child(user.uid).setValue(["username": username])"<br>
3. retrieve data:<br>
(1) get instance reference by "Database.database().reference().child("posts")"<br>
(2) obeserve database and retrieve newly posted data by "ref. child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in .....})<br>


(Pod Update before Running! , then autocreate schema!)
## Instructions:
1. "MarketingMaterials" was uploaded to another branch called MarketingMaterials
2. After cloning the master branch, open the project by clicking on ".xcworkspace" file
3. There are several libraries were imported, by never used, like"GeoFire"
4. When running on simulator, check "using location simulation", otherwise, uncheck the box. Don't let your simulator overwrite your device location service.
5. Best Practices to verify Map function is to post events at different locations, otherwise, annotation from same location might be covered.(I think it is hard to display two annotations on single spot)
6. When you post events, you'd better write down caption and description. I don't want to show events with litte information
7. Posted events is displayed in order of user, i like this style. So when you retrieve new info, don't just look at the bottom of the tableview
8. It's to noisy to print all data in the console, but I think my printing can help you to figure out the flow clearly. At some spots, I just print fake data.
9. Be patient when you launch, use image picker, and view map for the first time

## Authors
* **Hongli Bu**
