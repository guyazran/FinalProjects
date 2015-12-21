# FinalProjects

these are my final projects

both projects are of the same app, “Salary Tracker”.

the app is currently being used by 2 shift managers at the Temple Bar to help calculate the employees’ salaries.

the main attraction of this app is the ability to make specific calculations that bypass cumbersome use of a calculator.

another advantage is that the app allows the user to calculate overtime into the final salary in the same calculation.

in the android version there is a “timer” function that allows the user to enter minimal parameters at the beginning of an employees’ shift and forget about him/her until the shift is over.

in today’s restaurant, bar, and small business market, all applications and programs are cumbersome, difficult to use, and require the users to do calculations by themselves with external applications/programs.

in the future this app can replace these systems with an intuitive and easy to use interface. there are already talks with the owner of the bar to help integrate this app with specific Temple Bar needs and at a later level, saving employee information on a server database and exporting XML files with monthly summaries.

the code:
in the code there is a clear separation between logic and UI.

the logic:
the logic is comprised of 2 main packages each with a specific purpose. SimpleTime handles all time related calculations. these help the user find out how long a shift was. Finance is a representation of Money and all Money related objects. Currency, at this stage, has is there only for display purposes, and has no effect on any outcomes within the app.

there is another app specific package called HumanResources, who’s purpose is to hold employee information and expand the Timer class found in SimpleTime to suit the apps needs

the UI:
Simple Calculation:
in the android and iOS apps there is a page that can help make easy salary calculations with information about a person’s shift. all the user must do is enter the start and end time of the shift (easily using the system time picker the user is already familiar with) and the rate per hour that the employee makes and then it’s just a click of a button (or enter on the keyboard).

Timer:
in the android app there is a feature that is now being tested with a shift manager at the Temple Bar. the feature uses saves the start time of an employee’s shift and calculates the employee’s salary from that time. no calculations and no thinking. just watching the salary change as time goes by. even if a timer is mistakenly stopped it can be continued at any time as if it were never stopped. timers are saved and are restored, even after the device is turned off.

Settings:
in the android and iOS apps there are 2 settings options that subtly customize the UI to the user’s content.



Web:
this is a simple game based on Nintendo’s Super Mario franchise. the game is built in HTML, CSS and javascript. the objective of the game is to control Mario to collect coins that increase your score to 1000 points while avoiding the enemy. making contact with the enemy will decrease your life. when your lives reach 0, you have lost the game.

how does it work:
there are a few main functions that runs using setInterval() that updates the UI every few milliseconds. the coins are generated in a random fashion in a range from the floor to as high as Mario can jump.

Controls:
in order to avoid page scrolling, the controls are based on WASD directions.
w - jump
a - move left
d - move right


this is my project. enjoy!



