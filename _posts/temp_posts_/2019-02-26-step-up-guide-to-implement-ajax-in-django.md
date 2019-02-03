---
layout: post
title:  "Step Up Guide to implement Ajax in Django"
date:   2020-02-26 20:34:07 +0530
category: learn
permalink: /learn/step-up-guide-to-implement-ajax-in-django
cover_image: img/step-up-guide-to-implement-ajax-in-django/cover.jpg
author: "Jai Singhal"
comments: true
tags: learn ajax-guide ajaxify-django-forms ajax-django implement-ajax-django ajax django step-up-guide-to-implement-ajax-in-django form-submission-without-refresh work-with-ajax-django get-request post-request asynchronous-calls jai-singhal
description: In this post we will learn, how to submit the forms and perform asynchronous tasks with the help of AJAX
# toc: true
---


<!-- 
* TOC
{:toc} -->

## Introduction

Hello and Welcome to our next exciting post where we learn the different methods to implement AJAX in Django project. We will be using both class bases views and function based views in this post. We will be using jQuery library and Django v2.0 and bootstrap for some designing.


##### What is AJAX?

AJAX is *A*synchronous *J*avaScript *A*nd *X*ML, which is combination of browser built-in XMLHttpRequest object and Javascript and HTML DOM. AJAX commonly transports the data in JSON format, however it might use XML.

##### How AJAX Works?

1. An event occured in our web page like some form submission, some clicking of button etc.
2. An XMLHttpRequest object is created and it sends request to the server
3. The server responds to the request and respond with some sort of data(in JSON) to the web page again.
4. The response is read by the Javascript and performs action with responded data.

##### Why AJAX? 

Many of the time we want to perform some asynchronous calls to the server to **GET** or **POST** some sort of data without refreshing your current page. 

<br>
<hr>

## Initital Setup

We will be using jQuery and Bootstrap v4 for this tutorial, so initially we have include these library into our **base.py** template

###### templates/base.html
{% highlight html %}
{% raw %}
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
{% block head %}
{% endblock %}
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
{% block style %}
{% endblock %}
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</head>
<body>
{% block content %}
{% endblock %}

{% block script %}
{% endblock %}
</body>
</html>
{% endraw %}
{% endhighlight %}
We will be discussing several examples here that readily used in every websites and it will help you get the hands on how to implement AJAX in your django project.

<hr>
<br>

## Example 1: Subscriber Form


**Request**: POST request 

**Views**: Function based views(FBV)