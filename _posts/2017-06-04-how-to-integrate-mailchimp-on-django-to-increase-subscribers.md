---
layout: post
title:  "How to integrate MailChimp on Django to increase Subscribers"
date:   2017-06-04 20:34:07 +0530
category: package-of-week
permalink: /package-of-week/how-to-integrate-mailchimp-on-django-to-increase-subscribers/
cover_image: img/how-to-integrate-mailchimp-on-django-to-increase-subscribers/cover.jpg
author: "Jai Singhal"
comments: true

tags: getting-started-with-django my-first-django-app my-first-django-site virtualenv
description: After too much motivation, now it's time to get started with Django. To develop your Django-powered site, you first need to install Python on your system. It is highly recommended to install the latest version of Python.
toc: true
---

## Introduction
In this Post, we will discuss on how to integrate the MailChimp API to your Django Application. This API will help you to provide a platform to send emails to the audience who subscribes to your website, we will also discuss how to send a confirmation email for confirming the subscription using Threading because connecting with other API may take 2-3 second to connect. Using threads allows a program to run multiple operations concurrently in the same process space.

By MailChimp, you can send Beautiful Templated Message that will grow your Business by sending regular emails of your new product, news, post or whatever you want to promote. MailChimp is forever free but up to 2000 subscribers and 12,000 emails per month.

## What is MailChimp
MailChimp is an email marketing service and their features and integrations allow sending marketing emails, automated messages, and targeted campaigns. MailChimp has been around since 2001 and now more than 15 million people and businesses around the world use MailChimp.

## Initial Setup
First, of fall you need to Sign up and create your account at MailChimp. Go to the MailChimp website to register your website.

 

 

 

Fill up your details or credentials of your and your website and finally activate your account from the mail they sent you.

#### Create a List
After complete registration with MailChimp, you will land to the Dashboard of MailChimp.

Now we have to create a List. So click on the button of Create a List shown below, or by going to the List Panel from the menu bar and there after clicking on Create a list Button.

 



 

Now fill up your all necessary details in List Form. These details may be included in the MailChimp emails you sent, so If you have any hosted email service, use that email address. After you successfully filled up your details, click on Save. 

 

#### Get Your List and API KEY
After creating your List, get your List Key and API key.

You can get your List Key from lists > settings. Scroll down the page, you fill find a field of Unique id for list <Yor List Name> list. Copy your list id from there.

 

 

 

After that, get your API key from Account > Extras > API Keys. Then click on Create a Key button to get your API key.

 

 

 It is strongly recommended to hide your keys during the development of your Django Application. I would recommend you to save your keys in the settings.py file.

 {% highlight python %}
MAILCHIMP_API_KEY = XXXXXYour API KeyXXXXXX
MAILCHIMP_SUBSCRIBE_LIST_ID = XXXXXYour lIST KeyXXXXXX
 {% endhighlight %}

## Setup in your Django Application
Now you have setup your Django Application to connect to the MailChimp API, whenever any user tries to Subscribe to your Website.

Like my previous articles, I will explain it by a brief example so that you can understand clearly.

So for the sake of example, I have created a table in models.py of two fields, first one is email_id the second one is timestamp.

 {% highlight python %}
from django.db import models
from django.utils import timezone

class Subscribe(models.Model):
    email_id = models.EmailField(null = True, blank = True)
    timestamp = models.DateTimeField(default=timezone.now)
	def __str__(self):
		return self.email_id
{% endhighlight %}


You have to install a package of MailChimp. You can download from PyPI package mailchimp2.0.9 OR you can directly install with pip.

{% highlight bash %}
pip install mailchimp
 {% endhighlight %}

After installing the package, let's actually set up the MailChimp Integration and sending a confirmation mail of subscription. Like discussed above, we used Threading to connect to MailChimp API because connecting with other API may take 2-3 second to connect. Using threads allows a program to run multiple operations concurrently in the same process space.

**Note**: This section of code, I have written by creating a new py file named utils.py in the same Django App. This is not necessary, but if you do, it will be good.

{% highlight python %}
import threading
import mailchimp
from django.conf import settings

class SendSubscribeMail(object):
	def __init__(self, email):
		self.email = email
		thread = threading.Thread(target=self.run, args=())
		thread.daemon = True                     
		thread.start()                                 

	def run(self):
		API_KEY = settings.MAILCHIMP_API_KEY
		LIST_ID = settings.MAILCHIMP_SUBSCRIBE_LIST_ID
		api = mailchimp.Mailchimp(API_KEY)
		try:
			api.lists.subscribe(LIST_ID, {'email': self.email})
		except:
			return False
 {% endhighlight %}

Let's get set up the views. Usually, the Subscription forms are AJAX-powered and they are usually in Homepage. So in this tutorial, I have created an Ajax handling function based view. 

{% highlight python %}
from django.http import HttpResponse, JsonResponse
from .models import Subscribe
from .utils import SendSubscribeMail

def subscribe(request):
    if request.method == 'POST':
        email = request.POST['email_id']
        email_qs = Subscribe.objects.filter(email_id = email)
        if email_qs.exists():
            data = {"status" : "404"}
            return JsonResponse(data)
        else:
            Subscribe.objects.create(email_id = email)
            SendSubscribeMail(email) # Send the Mail, Class available in utils.py
            
    return HttpResponse("/")
{% endhighlight %} 

#### Set up your URL.
{% highlight python %}
from django.conf.urls import url
from my_app.views import subscribe

urlpatterns = [
    ...
    url(r'^subscribe/', subscribe, name = "subscribe"),
    ...
]
{% endhighlight %}

Finally, you have to design the template for a Subscription form. Include this form in anywhere in your page, I have included this form in my footer.
{% highlight django %}
{% raw %}
<div class = "subscribe_form">
    <p>Sign up for our newsletter to get latest updates</p>
    <form id = "subscribe" form method = 'POST'>{% csrf_token %}
        <input id = "email_id" type = "email" name = "email_id" placeholder="your@email.com">
        <button type="submit" value = "Subscribe" id = "email_submit">Subscribe</button>
     </form>
</div>
{% endraw %}
{% endhighlight %}

Complete your form by adding ajax script, which will execute after submitting the email. Now you need to pass the csrftoken (Why?) as JSON object along with email id got from the input.

{% highlight javascript %}
$('#subscribe').submit(function(e){
      e.preventDefault();
      var email_id = $("#email_id").val();
      if(email_id){
        var csrfmiddlewaretoken = csrftoken;
        var email_data = {"email_id": email_id, 
                          "csrfmiddlewaretoken" : csrfmiddlewaretoken};
        $.ajax({
          type : 'POST',
          url :  '/subscribe/',
          data : email_data,
          success : function(response){
            $('#email_id').val(''); 
            if(response.status == "404"){
              alert("This Email is already been subscribed!");
            }
            else{
              alert("Thank you for Subscribing! Please Check your Email to Confirm the Subscription");
            }
          },
          error: function(response) {
            alert("Sorry Something went Wrong");
            $('#email_id').val(''); 
          }
        });
        return false;
      }
      else{
        alert("Please provide correct email!");
      }
  });
 

function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = jQuery.trim(cookies[i]);
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}
var csrftoken = jQuery("[name=csrfmiddlewaretoken]").val();

function csrfSafeMethod(method) {
    return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
}
$.ajaxSetup({
    beforeSend: function(xhr, settings) {
        if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
            xhr.setRequestHeader("X-CSRFToken", csrftoken);
        }
    }
})
{% endhighlight %}

 Now you are all set, you can test by subscribing with your known email. Check your subscribed email, you will get this type of mail.

 
## Final Words

This site is also powered by MailChimp. You can check by subscribing to our website. You will find our Subscribe Newsletter form available at the footer. If you have any problem regarding installation you can ask it in the Comment section.


