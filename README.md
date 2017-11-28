​**Title:** Debt Tracker  
​**Team Members:** Patricia Arenillo, Anahita Farshi, Serra Park  
​**Demo Link:** https://youtu.be/pbJUCjRS9W8

​**Idea:** An application where users can track debts and loans between friends, remind and check off paid transactions.

​**Models and Description:**  
User  
- has username, email, and many IOUs and Completeds  
- Users can either be debtors or lenders  

IOU
- has description and amount
- belongs to a debtor and a lender

Completed Transaction
- has description and amount
- belongs to a debtor and a lender

**Features:**
- Users can log in
- Users can create IOUs
- Users can remind friends to pay
- Users can check off paid transactions
- Users can review past transactions

**Division​ ​of​ ​Labor:**
- Patricia:

  - basic setup with relations and validations for Users, Ious, Completeds models
  - show method and related helper methods for User controller
  - new and create method for Iou controller
  - method for processing completed Ious into Completeds and show methods for Completed controller
  - seed file
  - plain text information extracted from controller and forms with no styling for the User, Iou, Completed views

- Anahita:

  - reminder button that sends an email notification (Action Mailer)
  - sign in/sign up with username

- Serra:

  - completed views
  - general styling for application
