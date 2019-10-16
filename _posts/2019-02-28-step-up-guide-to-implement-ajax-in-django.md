---
layout: post
title:  "Step Up Guide to implement Ajax in Django"
date:   2019-02-28 20:34:07 +0530
category: learn
permalink: /learn/step-up-guide-to-implement-ajax-in-django/
cover_image: img/step-up-guide-to-implement-ajax-in-django/cover.jpg
author: "Jai Singhal"
comments: true
tags: learn ajax-guide ajaxify-django-forms ajax-django implement-ajax-django ajax django step-up-guide-to-implement-ajax-in-django form-submission-without-refresh work-with-ajax-django get-request post-request asynchronous-calls jai-singhal
description: In this post we will learn, how to submit the forms and perform asynchronous tasks with the help of AJAX
toc: true
---


<!-- 
* TOC
{:toc} -->

## Introduction

Hello and Welcome to our next exciting post where we explore different methods to implement AJAX in Django project. We will be using both class bases views and function based views in this post. We will take the help of several frontend libraries such as JQuery and Bootstrap4.

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

We will be using jQuery and Bootstrap v4 for this tutorial, so initially, we have included these libraries into our base.py template

**templates/base.html**

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
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
{% block style %}
{% endblock %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
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

We will be discussing several examples here that readily used in every website and it will help you get the hands-on how to implement AJAX in your Django project.
<hr>
<br>

## Example 1: Basic Contact Form

**Request**: POST request 

**Views**: Function based views(FBV) and Class Based views(CBV)

**Directory Structure:**
```
├── app_1
│   ├── admin.py
│   ├── apps.py
│   ├── forms.py
│   ├── __init__.py
│   ├── migrations
│   ├── models.py
│   ├── templates
│   │   ├── contact_cbv.html
│   │   └── contact.html
│   ├── tests.py
│   └── views.py
├── db.sqlite3
├── ajax_guide
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── templates
│   ├── base.html
└── manage.py
```
<br />
<hr />

I want to make this example which is easy to understand for the newbie, however, it is also helpful for the intermediates. So let's get started.


### models.py

Let's create a basic Contact Model 
{% highlight python %}
{% raw %}
from django.db import models

class Contact(models.Model):
	name = models.CharField(max_length = 100)
	email = models.EmailField()
	message = models.TextField()
	timestamp = models.DateTimeField(auto_now_add = True)

	def __str__(self):
		return self.name

{% endraw %}
{% endhighlight %}

<hr />

### urls.py

{% highlight python %}
{% raw %}
from django.contrib import admin
from django.urls import path
from app_1 import views as app1

urlpatterns = [
    path('', app1.contactPage), # FBV

    path('ajax/contact', app1.postContact, name ='contact_submit'),
]
{% endraw %}
{% endhighlight %}

Note that, I have used a path name for the **contact_submit**, this will useful in making the **AJAX** request

<hr />

### forms.py

In **ContactForm** class, I have done some little changes in the basic form rendering. In **__init__** method, I have added **form-control** class to every form input element, to make it Bootstrap4 powered.

{% highlight python %}
{% raw %}
from django import forms
from .models import Contact

class ContactForm(forms.ModelForm):
	class Meta:
		model = Contact
		exclude = ["timestamp", ]
		widgets = {
			'message': forms.Textarea(attrs={'rows':4, 'cols':15}),
		}

	def __init__(self, *args, **kwargs):
		super(ContactForm, self).__init__(*args, **kwargs)
		for field in self.fields:
			self.fields[field].widget.attrs.update({
		    'class': 'form-control'})

{% endraw %}
{% endhighlight %}

<hr />


### Views.py

Now, this is the section where we need to put some attention to understand the AJAX in a better way. I have created two Function based views(FBV) which deal with **GET** and **POST** respectively.

In the POST view function i.e., **postContact()** function, we are first checking whether the POST request made is **AJAX** or NOT, and checks for **POST** request.

{% highlight python %}
{% raw %}
from django.shortcuts import render
from django.http import JsonResponse
from .forms import ContactForm

#FBV

def contactPage(request):
	form = ContactForm()
	return render(request, "contact.html", {"contactForm": form})

def postContact(request):
	if request.method == "POST" and request.is_ajax():
		form = ContactForm(request.POST)
		form.save()
		return JsonResponse({"success":True}, status=200)
	return JsonResponse({"success":False}, status=400)

{% endraw %}
{% endhighlight %}


<hr />


### contact.html

Moving to frontend section, let's first extends the **base.html** which is discussed above.

Render the form which was created above enclosing **form tag** along with **csrf_token** and submit button. Note the usage of template blocks carefully.

Talking about the **javascript** part which is a crucial part of this tutorial. I have made an **AJAX** **POST** request on form submission event. Note the url used here is the name of the path, I have discussed in **urls.py**. After successful submission of the form from the backend, it will **reset** the form.

{% highlight django %}
{% raw %}
{% extends "base.html" %}
{% block head %}
	<title>Contact Form[FBV]</title>
{% endblock %}
{% block style %}
{% endblock %}
{% block content %}
<div class="container">
   <div class="jumbotron">
      <h1 class="text-center display-4">Contact Form[FBV]</h1>
      <p class="lead text-center">This is sample example for integration of AJAX with Django</p>
    </div>
    <div class="row justify-content-center align-items-center">
      <div class="col-sm-6 ">
      	<form id = "contactForm" method= "POST">{% csrf_token %}
      		{{ contactForm.as_p }}
      		<input type="submit" name="contact-submit" class="btn btn-primary" />
      	</form>
      </div>
   </div>
</div>
{% endblock %}
{% block script %}
<script type="text/javascript">
$(document).ready(function(){
   $("#contactForm").submit(function(e){
	// prevent from normal form behaviour
      	e.preventDefault();
    	// serialize the form data  
      	var serializedData = $(this).serialize();
      	$.ajax({
      		type : 'POST',
      		url :  "{% url 'contact_submit' %}",
      		data : serializedData,
      		success : function(response){
			//reset the form after successful submit
      			$("#contactForm")[0].reset(); 
      		},
      		error : function(response){
      			console.log(response)
      		}
      	});
   });
});
</script>
{% endblock %}
{% endraw %}
{% endhighlight %}
<br />

<hr />
## Making Class based views

To convert the above example from Function based views to class based views(CBV), we just need to transform our views.py only, and also make a route for the view in urls.py
### urls.py
{% highlight python %}
{% raw %}
from app_1 import views as app1
urlpatterns = [
	#CBV
	
    path('', app1.ContactAjax.as_view(), name = 'contact_submit')
]
{% endraw %}
{% endhighlight %}

<hr/>

### views.py
In the **FBV**, we have used the **2** function views, that can be wrap in the single class containing two methods namely **GET** and **POST** with a single url route.

{% highlight python %}
{% raw %}
from django.shortcuts import render
from django.http import JsonResponse
from .forms import ContactForm
from django.views import View
#CBV

class ContactAjax(View):
	form_class = ContactForm
	template_name = "contact.html"

	def get(self, *args, **kwargs):
		form = self.form_class()
		return render(self.request, self.template_name, {"contactForm": form})

	def post(self, *args, **kwargs):
		if self.request.method == "POST" and self.request.is_ajax():
			form = self.form_class(self.request.POST)
			form.save()
			return JsonResponse({"success":True}, status=200)
		return JsonResponse({"success":False}, status=400)
{% endraw %}
{% endhighlight %}

### Screenshot

{% responsive_image path: img/step-up-guide-to-implement-ajax-in-django/screenshot.png %}

<br />
<hr />
<br />


## Example 2: Get User Details

**Request**: GET request 

**Views**: Function based views(FBV)


If you get comfortable with the above example, let's move to our second example. This example helps you to integrate the **AJAX GET** request in your Django project. We will be using Function based views. In this example, we will try to get the user information for the user which is selected. We will use the default **User** class provided by Django.

**Directory Structure:**

The directory structure of the app will be as follows
```
├── app_1
├── app_2
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   ├── models.py
│   ├── templates
│   │   ├── user.html
│   ├── tests.py
│   └── views.py
├── db.sqlite3
├── ajax_guide
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── templates
│   ├── base.html
└── manage.py
```
<hr />

### urls.py
Create the url route for the displaying the user and an **AJAX** request url

{% highlight python %}
{% raw %}
from django.urls import path
from app_2 import views as app2

urlpatterns = [
    #app_2
    path('user', app2.userPanel),
    path('ajax/get_user_info', app2.getUserInfo, name = 'get_user_info'),
]

{% endraw %}
{% endhighlight %}

<hr />

### views.py

The views are pretty similar with above example views, with the slight change i.e., the method **GET** in replace of **POST** and way of wrapping the object into the dictionary and sending the **response**

{% highlight python %}
{% raw %}

from django.shortcuts import render
from django.http import JsonResponse
from django.contrib.auth.models import User

#FBV

def userPanel(request):
	usernames = User.objects.all().values("username")
	return render(request, "user.html", {"usernames": usernames})

def getUserInfo(request):
	if request.method == "GET" and request.is_ajax():
		username = request.GET.get("username")
		try:
			user = User.objects.get(username = username)
		except:
			return JsonResponse({"success":False}, status=400)
		user_info = {
			"first_name": user.first_name,
			"last_name": user.last_name,
			"email": user.email,
			"is_active": user.is_active,
			"joined": user.date_joined
		}
		return JsonResponse({"user_info":user_info}, status=200)
	return JsonResponse({"success":False}, status=400)
{% endraw %}
{% endhighlight %}


<hr />

### user.html

Moving to the frontend part, after selecting username option from the **select box**, the **AJAX** call will be made to our Django server with the username which is selected, and the Django server will respond with information for the respective username in its response, which is then rendered in the table body.

{% highlight django %}
{% raw %}

{% extends "base.html" %}
{% block head %}
	<title>Get user Info</title>
{% endblock %}
{% block style %}
{% endblock %}
{% block content %}
<div class="container">
   <div class="jumbotron">
   <h1 class="text-center display-4">User Panel</h1>
   <p class="lead text-center">This is sample example for integration of AJAX with Django</p>
   <p class="lead text-center">GET the user details for selected user. 
	 Please create some users(if not created)</p>
   </div>
   <div class="row justify-content-center align-items-center">
   <div class="col-4">
   	<label>Select Username</label>
   	<select class="form-control" id = "users">
   		<option selected="true" disabled="disabled">Select user</option>
   		{% for uname in usernames %}
   			<option value = {{uname.username}}>{{uname.username}}</option>
   		{% endfor %}
   	</select>
   </div>
   <div class="col-9" id = "user_info">
   	<hr />
   	<table class="table table-stripped table-fixed">
		<thead>
			<tr>
				<td>First Name</td>
				<td>Last Name</td>
				<td>Email</td>
				<td>is_active</td>
				<td>Date Joined</td>
			</tr>
		</thead>
   		<tbody>
   		</tbody>
   	</table>
   </div>
   </div>
</div>
{% endblock %}
{% block script %}
<script type="text/javascript">
$(document).ready(function(){
   $("#users").change(function(e){
   	e.preventDefault();
   	var username = $(this).val();
   	var data = {username};
   	$.ajax({
   		type : 'GET',
   		url :  "{% url 'get_user_info' %}",
   		data : data,
   		success : function(response){
   			$("#user_info table tbody").html(`<tr>
   				<td>${response.user_info.first_name || "-"}</td>
   				<td>${response.user_info.last_name || "-"}</td>
   				<td>${response.user_info.email || "-"}</td>
   				<td>${response.user_info.is_active}</td>
   				<td>${response.user_info.joined}</td>
   				</tr>`)
   		},
   		error : function(response){
   			console.log(response)
   		}
   	})
   })
})
</script>
{% endblock %}

{% endraw %}
{% endhighlight %}

<hr />

### Screenshot

{% responsive_image path: img/step-up-guide-to-implement-ajax-in-django/screenshot2.png %}

<br />
<hr />
<br />

## Final Words

AJAX is the best way to do asynchronous tasks on a small scale. However, if you want to perform asynchronous tasks at a very large scale, you can opt any frontend javascript framework/library, the best available in the market are **React**, **Angular**, **Vue**.

If you have any problem in the steps discussed above, you can look out our **GitHub** **repository** [https://github.com/djangopy-org/ajax_guide](https://github.com/djangopy-org/ajax_guide)

<br />
<hr />
<br />

## References
- [https://github.com/djangopy-org/ajax_guide](https://github.com/djangopy-org/ajax_guide)
- [https://code.djangoproject.com/wiki/AJAX](https://code.djangoproject.com/wiki/AJAX)
- [https://docs.djangoproject.com/en/2.1/ref/csrf/#ajax](https://docs.djangoproject.com/en/2.1/ref/csrf/#ajax)