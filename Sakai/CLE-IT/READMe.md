# Functional Automation integration testing for Sakai CLE

## Description:

This repository contains the following projects:

- APIs for the rSmart versions of Sakai's Open Academic Environment (OAE) and Collaborative Learning Environment (CLE)
- Cucumber features and step definitions for integration testing CLE

## APIs

The Sakai APIs are written in Ruby 1.9.2 using the Nokogiri and Yaml locally as Ruby gems with the command:

`gem install nokogiri`
`gem install yaml`

Installing the gems will also install all necessary dependencies.


## Configure your test environment

Rename cle-it.yml.template to cle-it.yml in config directory.  Change values according to your environment

## Cucumber projects

You are of course welcome to use the APIs on their own to write your own test scripts using whatever framework you prefer. However, if you're interested in getting a fast start and either learning the API by example or leveraging work we've already done, you're welcome to grab our Cucumber projects.


## Contribute

* Fork the project.
* Additional or bug-fixed Classes, Elements, or Methods should be demonstrated in accompanying tests. Pull requests that do not include test scripts that use the new code won't be accepted.
* Make sure you provide RDoc comments for any new public method or page class you add. Remember, others will be using this gem.
