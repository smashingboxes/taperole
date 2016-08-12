#Contributor Guidelines

##Submitting a Pull Request

###Workflow
We use [Waffle.io](https://waffle.io/smashingboxes/tape) to manage our workflow for this project. Please respect the workflow and move PRs that are ready to be mereged into the 'Ready' column.

####Testing

There are two main ways we test taperole. The first is basic unit tests, via rspec. Those can be run via:

`rake test`

The second way is a kind of integration test. We use tape to stand up a basic vanilla rails app (leveraging docker) and then check that a curl returns the correct thing. There isn't an easy way to run this locally, but it is set up on travis to run automatically.

###PR Structure

Please give details regarding your PR in the following format. It really helps with review and quickens the speed at which your changes are merged in

![example pull request]( http://i.imgur.com/HJq8DHc.png )

##Opening Issues

###Basic details

Please include the following in the Issues you open

* OS Version
* ansible version
* tape version
