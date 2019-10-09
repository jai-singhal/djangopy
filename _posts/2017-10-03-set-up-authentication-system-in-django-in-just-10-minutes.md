---
layout: post
title:  "Set-up Authentication System in Django in just 10 minutes"
date:   2017-10-03 20:34:07 +0530
category: learn
permalink: /learn/set-up-authentication-system-in-django-in-just-10-minutes/
cover_image: img/set-up-authentication-system-in-django-in-just-10-minutes/cover.jpg
author: "Jai Singhal"
comments: true

tags: Django-Authentication-System Django-Authentication login logout register django djangopy

description: In this post, we will discuss Authentication System in Django. We will be discussing the most abstract way to how to implement on your Django Project in just simple steps.
toc: true
---

Authentication is something which needs to be implemented on each and every website. And with Django, it is very simple and easy to implement because we don't need to make the Authentication system from scratch, it is already made by the Django, we need to simply use it.

## Introduction
In this tutorial, we will be discussing that how to implement the login, logout, and register views in a brand new accounts app.

## Initial Set Up
Let's create a new django-app named accounts to your Project.

{% highlight bash %}
python manage.py startapp accounts
{% endhighlight %}

Make an entry of that app to Installed Apps in the Django settings.
{% highlight python %}
INSTALLED_APPS += [
    "accounts"
]
{% endhighlight %}

Create two new .py files to your accounts app that is forms.py and urls.py

Then this would be your following App structure.

{% highlight bash %}
src/
   accounts/
      migrations/
      __init__.py
      admin.py
      apps.py
      forms.py
      models.py
      tests.py
      urls.py
      views.py
   my_proj/
      __init__.py
      settings.py
      urls.py
      wsgi.py 
 {% endhighlight %}

#### my_proj/urls.py
Create some main URLs to your main project. Note that I have included the accounts urls of accounts app.

{% highlight python %}
from django.conf.urls import url, include
from django.views.generic import TemplateView
from django.contrib.auth.decorators import login_required

urlpatterns += [

    url(r'^accounts/', include("accounts.urls", namespace = "accounts")),
    url(r'^$', login_required(TemplateView.as_view(template_name="home.html"))),
]
{% endhighlight %}

Note: Change the DIRS OF Templates settings in your Django settings.

Let's create a base template so that we can you use that for Template Inheritance. If you have already made a base file Ignore this step.

#### templates/base.html


{% highlight django %}
{% raw %}
<!--doctype HTML-->
{% load staticfiles %}
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
{% block head %}
{% endblock head %}
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" />
{% block style %}
{% endblock style %}
</head>
<body>

{% block content %}
{% endblock content %}

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>

{% block script %}
{% endblock script %}

</body>
</html>
 {% endraw %}
{% endhighlight %}

#### templates/home.html
Create a home page or a landing page with the navbar. Again repeating if you have your own navbar and home page, you don't need to change it, I am just discussing for the sake of completion of the tutorial.


{% highlight django %}
{% raw %}
{% extends "base.html" %}
{% block style %}
<style>
.navbar-login{
    width: 305px;
    padding: 10px;
    padding-bottom: 0px;
}
.navbar-login-session{
    padding: 10px;
    padding-bottom: 0px;
    padding-top: 0px;
}
.icon-size{
    font-size: 87px;
}
</style>
{% endblock %}
{% block content %}
<div class="navbar navbar-default navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a target="_blank" href="#" class="navbar-brand">My Project</a>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li class = "active"><a href="#" >Home</a></li>
             </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <span class="glyphicon glyphicon-user"></span> 
                        <strong>Admin</strong>
                        <span class="glyphicon glyphicon-chevron-down"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <div class="navbar-login">
                                <div class="row">
                                    <div class="col-lg-4">
                                        <p class="text-center">
                                            <span class="glyphicon glyphicon-user icon-size"></span>
                                        </p>
                                    </div>
                                    <div class="col-lg-8">
                                        <p class="text-left"><strong>Welcome</strong></p>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <div class="navbar-login navbar-login-session">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <p>
                                            <a href="/accounts/logout" class="btn btn-danger btn-block">Logout</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</div>
{% endblock %}
{% endraw %}
{% endhighlight %}

## Login
Let's begin with the login system. Like I have said before that you don't need to create from scratch. Like we don't need to create the database for the Login system like username and password fields. We Just need to create a Django form of fields including the username and password. We can also create new additional fields (if required) in Login.

 

#### accounts/forms.py
I have created a Django form for the Login View with fields username and password and also a clean method which raises some common Validation Errors like Incorrect Password, User does not Exist, User Not Active etc. You can create more Validation Errors according to your need. Also, I have added classes in fields of username and password.

{% highlight python %}
from django.contrib.auth import authenticate
from django import forms

class UsersLoginForm(forms.Form):
	username = forms.CharField()
	password = forms.CharField(widget = forms.PasswordInput,)

	def __init__(self, *args, **kwargs):
		super(UsersLoginForm, self).__init__(*args, **kwargs)
		self.fields['username'].widget.attrs.update({
		    'class': 'form-control',
		    "name":"username"})
		self.fields['password'].widget.attrs.update({
		    'class': 'form-control',
		    "name":"password"})

	def clean(self, *args, **keyargs):
		username = self.cleaned_data.get("username")
		password = self.cleaned_data.get("password")

		if username and password:
			user = authenticate(username = username, password = password)
			if not user:
				raise forms.ValidationError("This user does not exists")
			if not user.check_password(password):
				raise forms.ValidationError("Incorrect Password")
			if not user.is_active:
				raise forms.ValidationError("User is no longer active")

		return super(UsersLoginForm, self).clean(*args, **keyargs)
 {% endhighlight %}

#### accounts/views.py
Now after creating a form, let's create a Django View which accepts the request and render a request to templates. I have implemented the Function Bases View which handles both GET and POST request methods.

{% highlight python %}
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from .forms import UsersLoginForm

def login_view(request):
	form = UsersLoginForm(request.POST or None)
	if form.is_valid():
		username = form.cleaned_data.get("username")
		password = form.cleaned_data.get("password")
		user = authenticate(username = username, password = password)
		login(request, user)
		return redirect("/")
	return render(request, "accounts/form.html", {
		"form" : form,
		"title" : "Login",
	})
{% endhighlight %}

#### accounts/urls.py
Create urls for the respective view, like in our case that is login_view

{% highlight python %}
from django.conf.urls import url
from .views import (
    login_view,
)

urlpatterns = [
    url(r"^login/$", login_view, name = "login"),
]
{% endhighlight %}
 
#### templates/ accounts/ form.html
Now I have created a template for the login view, you can change according to your need. Note that I have inherited the base.html, which is discussed above.

{% highlight django %}
{% raw %}
{% extends "base.html" %}
{% load staticfiles %}
{% block style %}
<style type="text/css">
body {
	background: #eee !important;
}
.wrapper {
	margin-top: 80px;
  margin-bottom: 80px;
}
.form-signin {
  padding: 15px 35px 45px;
  margin: 0 auto;
  background-color: #fff;
  border: 1px solid rgba(0,0,0,0.1);

  .form-signin-heading,
	.checkbox {
	  margin-bottom: 30px;
	}
	.checkbox {
	  font-weight: normal;
	}
	.form-control {
	  position: relative;
	  font-size: 16px;
	  height: auto;
	  padding: 10px;
		@include box-sizing(border-box);
		&:focus {
		  z-index: 2;
		}
	}
	input[type="text"] {
	  margin-bottom: -1px;
	  border-bottom-left-radius: 0;
	  border-bottom-right-radius: 0;
	}
	input[type="password"] {
	  margin-bottom: 20px;
	  border-top-left-radius: 0;
	  border-top-right-radius: 0;
	}
}
@media(max-width: 500px){
	footer{
		height: 130px !important;
		padding-bottom: 10px;
		padding-top: 10px;
	}
}
</style>
{% endblock %}

{% block content %}
<div class = "container">
  <div class = "col-md-6 col-md-offset-3">
    <div class="wrapper">
      <form class="form-signin" method = 'POST' action= '' enctype = "multipart/form-data" style="margin-top: -30px; margin-bottom: -18px;">{% csrf_token %}
        <h2 class="form-signin-heading">{{title}}</h2>
        {{form.as_p }}
        </label><br>
        <button class="btn btn-lg btn-primary btn-block" type="submit">{{title}}</button>
        <br>
        {% if title == "Login" %}<h5>Not Registered? <a href = "/accounts/register">Register Here</a></h5>{% endif %}
        {% if title == "Register" %}<h5>Already Registered? <a href = "/accounts/login">Login Here</a></h5>{% endif %}
      </form>

    </div>
  </div>
</div>
{% endblock %}
{% endraw %}
{% endhighlight %}

If you have followed the exact tutorial, you will have this kind of output for Login Page

{% responsive_image path: img/set-up-authentication-system-in-django-in-just-10-minutes/login.jpg %}
 

## Register 
After creating the Login View, let's create the register view.

#### accounts/forms.py
Starting with forms, let's create a Register Form with a class named UsersRegistrationForm which is somewhat similar to that of UsersLoginForm. So in this form, we have fields of username, password, email, and confirm_email. Aand along with this a clean method which is some standard validation errors.

{% highlight python %}
from django.contrib.auth import authenticate, get_user_model
from django import forms

User = get_user_model()

class UsersRegisterForm(forms.ModelForm):
	class Meta:
		model = User
		fields = [
			"username",
			"email",
			"confirm_email", 
			"password",
		]
	username = forms.CharField()
	email = forms.EmailField(label = "Email")
	confirm_email = forms.EmailField(label = "Confirm Email")
	password = forms.CharField(widget = forms.PasswordInput)


	def __init__(self, *args, **kwargs):
		super(UsersRegisterForm, self).__init__(*args, **kwargs)
		self.fields['username'].widget.attrs.update({
		    'class': 'form-control',
		    "name":"username"})
		self.fields['email'].widget.attrs.update({
		    'class': 'form-control',
		    "name":"email"})
		self.fields['confirm_email'].widget.attrs.update({
		    'class': 'form-control',
		    "name":"confirm_email"})
		self.fields['password'].widget.attrs.update({
		    'class': 'form-control',
		    "name":"password"})


	def clean(self, *args, **keyargs):
		email = self.cleaned_data.get("email")
		confirm_email = self.cleaned_data.get("confirm_email")
		username = self.cleaned_data.get("username")
		password = self.cleaned_data.get("password")

		if email != confirm_email:
			raise forms.ValidationError("Email must match")
		
		email_qs = User.objects.filter(email=email)
		if email_qs.exists():
			raise forms.ValidationError("Email is already registered")

		username_qs = User.objects.filter(username=username)
		if username_qs.exists():
			raise forms.ValidationError("User with this username already registered")
		
		#you can add more validations for password

		if len(password) < 8:	
			raise forms.ValidationError("Password must be greater than 8 characters")


		return super(UsersRegisterForm, self).clean(*args, **keyargs)
 {% endhighlight %}

#### accounts/views.py
 Now let's create the view for the register, This is view is Function Bases View which is for handling both GET and POST request.

{% highlight python %}
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from .forms import UsersRegisterForm

def register_view(request):
	form = UsersRegisterForm(request.POST or None)
	if form.is_valid():
		user = form.save()
		password = form.cleaned_data.get("password")	
		user.set_password(password)
		user.save()
		new_user = authenticate(username = user.username, password = password)
		login(request, new_user)
		return redirect("/accounts/login")
	return render(request, "accounts/form.html", {
		"title" : "Register",
		"form" : form,
	})
 {% endhighlight %}

#### accounts/urls.py
creating url for the register_view in the accounts urls.

{% highlight python %}
from django.conf.urls import url
from .views import (
    register_view,
)

urlpatterns += [
    url(r"^register/$", register_view, name = "register"),
]
 {% endhighlight %}

{% responsive_image path: img/set-up-authentication-system-in-django-in-just-10-minutes/register.jpg %}

 

## Logout
Now let's create our last view i.e., logout view. This is very simple view and very straightforward.

#### accounts/views.py

In my accounts views, I have created a new view named logout_view, which simply logouts and redirect to home.

{% highlight python %}
from django.contrib.auth import logout
from django.http import HttpResponseRedirect

def logout_view(request):
	logout(request)
	return HttpResponseRedirect("/")
{% endhighlight %}


#### accounts/urls.py
Writing the view url to accounts urls.

{% highlight python %}
from django.conf.urls import url
from .views import logout_view

urlpatterns += [
    url(r'^logout/$', logout_view, name = "logout"),
]
{% endhighlight %}

## Final Words
I hope that you have successfully implemented the Authentication System to your Django Project. However, if you find any problem in any of the steps discussed above, you can check our Github Repository from here

And also feel free to comment down below, if you have any problem regarding this tutorial and please share your experience with the DjangoPy

