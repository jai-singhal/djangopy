---
layout: post
title:  "Reverse Engineering of the Django Admin Foreign Key's Add/Edit Button"
date:   2017-07-07 20:34:07 +0530
category: how-to
permalink: /how-to/reverse-engineering-of-the-django-admin-foreign-keys-addedit-button/
cover_image: img/reverse-engineering-of-the-django-admin-foreign-keys-addedit-button/cover.jpg
author: "Jai Singhal"
comments: true
tags: Django-Admin-Foreign-Key Django-Admin Foreign-Key-Add Foreign-Key-Edit ForeignKey-add Reverse-Engineering-Django Reverse-Engineering-the-Django-Admin-Foreign-Key's-Add/Edit-Button DjangoPy django

description: In this tutorial, we will learn about how to add Django Admin's Foreign key's Add and Edit feature on Django form, so that we can easily add and edit the Foreign Key element in a pop-up window.
toc: true
---


## Introduction
In this tutorial, we will learn about how to add Django Admin's Foreign key's Add and Edit feature on Django form, so that we can easily add and edit the Foreign Key element in a pop-up window without refreshing the same page. This can be done with the help of AJAX. 

Recently I was working on a project and I wanted a functionality such that I can add Foreign Key element just like Django Admin provides. I wanted this feature to be implemented in a form of my app and I found this interesting and surely it will be interesting and helpful to you too.

 
 {% responsive_image path: img/reverse-engineering-of-the-django-admin-foreign-keys-addedit-button/2.jpg %}


## Implementing Server-side
Now let's implement this functionality to your Django app. I will discuss the implementation with the help of an example. Here I take an example of Model Book and Author where Author is a foreign key field in Book Model. 

#### Models.py
For the example discussed above, the class Model Author and Book would look like which is shown below. You need NOT to change your models.py, this is just for the sake of explaining with the appropriate example.

{% highlight python %}
from django.db import models
from django.utils import timezone

class Author(models.Model):
	name = models.CharField(max_length = 100)
	def __str__(self):
		return self.name

class Book(models.Model):
	title = models.CharField(max_length = 100)	
	author = models.ForeignKey(Author)
	price =  models.DecimalField(max_digits=12, decimal_places=4, default = 0)
	publish = models.DateField(default=timezone.now)
	def __str__(self):
		return self.title
{% endhighlight %} 


#### Forms.py
Design your form and do other Validations, here I am, showed you a basic example of forms

{% highlight python %}
from django.forms import ModelForm
from .models import Book, Author

class BookForm(ModelForm):
	class Meta:
		model = Book
		fields = [
			"title",
			"author",
			"price",
			"publish",
		]

class AuthorForm(forms.ModelForm):
	class Meta:
		model = Author
		fields = [
			"name"
		]
{% endhighlight %}

#### Views.py
Now, this is the important part of this tutorial. First of all, import all the forms, models and all the necessary imports to the view. Here I am using Function based views, you can use Class Based views it doesn't matter.

These functions are self-explanatory, only the HttpResponse with JS script may be tricky for you to understand, it is only sending a response of script to close the popup by calling the function closePopup once the form is successfully submitted.

Note that in function get_author_id(), I have used a decorator @csrf_exempt, this is done so because when you make Ajax call you need to send csrftoken in data. You can remove this decorator and send a csrftoken with the ajax call which is discussed the same in the previous Post 

{% highlight python %}
from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from .forms import BookForm, AuthorForm
from .models import Book, Author
from django.views.decorators.csrf import csrf_exempt
import json

def BookCreate(request):
	form = BookForm(request.POST or None)
	if form.is_valid():
		instance = form.save()		
		return HttpResponseRedirect("/")
	return render(request, "book_form.html", {"form" : form,})

def AuthorCreatePopup(request):
	form = AuthorForm(request.POST or None)
	if form.is_valid():
		instance = form.save()

		## Change the value of the "#id_author". This is the element id in the form
		
		return HttpResponse('<script>opener.closePopup(window, "%s", "%s", "#id_author");</script>' % (instance.pk, instance))
	
	return render(request, "author_form.html", {"form" : form})

def AuthorEditPopup(request, pk = None):
	instance = get_object_or_404(Author, pk = pk)
	form = AuthorForm(request.POST or None, instance = instance)
	if form.is_valid():
		instance = form.save()
		
		## Change the value of the "#id_author". This is the element id in the form
		
		return HttpResponse('<script>opener.closePopup(window, "%s", "%s", "#id_author");</script>' % (instance.pk, instance))

	return render(request, "author_form.html", {"form" : form})

@csrf_exempt
def get_author_id(request):
	if request.is_ajax():
		author_name = request.GET['author_name']
		author_id = Author.objects.get(name = author_name).id
		data = {'author_id':author_id,}
		return HttpResponse(json.dumps(data), content_type='application/json')
	return HttpResponse("/")
{% endhighlight %} 

#### Urls.py
Configure your URLs according to your views 

{% highlight python %}
from django.conf.urls import url
from my_app.views import (BookCreate,
                          AuthorCreatePopup,
                          AuthorEditPopup,
                          get_author_id)

urlpatterns = [
    ...
    url(r'^book/create', BookCreate, name = "BookCreate"),
    url(r'^author/create', AuthorCreatePopup, name = "AuthorCreate"),
    url(r'^author/(?P<pk>\d+)/edit', AuthorEditPopup, name = "AuthorEdit"),
    url(r'^author/ajax/get_author_id', get_author_id, name = "get_author_id"),
    ...
]
 {% endhighlight %}

## Implementing Client-Side
##### Templates/book_form.html
Create the main form for the Book(for this example).

Note that I have taken images from the Admin icon images for add and edit.

{% highlight django %}
{% raw %}
{% extends "base.html" %}
{% load staticfiles %}
{% block content %}

<div class = "container">
	<h1>Create a Book</h1>
	<form method = 'POST' action= '' enctype = "multipart/form-data" novalidate id = "book-form">{% csrf_token %}
		<label for="book-title" class="control-label">Book Title</label>
			{{form.title }}
		<br><br>
		<label for="book-author" class="control-label">Book Author</label>
		{{form.author }}
		<a href="/author/create" id="add_author" onclick="return showAddPopup(this);"><img src = "{% static '/images/icon-addlink.svg' %}"></a>
		<a id="edit_author" style="cursor: pointer; cursor: hand;"><img src = "{% static '/images/icon-changelink.svg' %}"></a>
		<br><br>
		<label for="book-price" class="control-label">Book Price</label>
		{{form.price }}
		<br><br>
		<label for="book-publish" class="control-label">Book Publish</label>
		{{form.publish }}
		<input type="submit" value = "Submit" />
	</form>
</div>

{% endblock %}
{% endraw %}
{% endhighlight %}

Add the following Jquery Script to either above form or to the base.html 

{% highlight django %}
{% raw %}
{% block script %}

<script type="text/javascript">
function showEditPopup(url) {
    var win = window.open(url, "Edit", 
        'height=500,width=800,resizable=yes,scrollbars=yes');
    return false;
}
function showAddPopup(triggeringLink) {
    var name = triggeringLink.id.replace(/^add_/, '');
    href = triggeringLink.href;
    var win = window.open(href, name, 'height=500,width=800,resizable=yes,scrollbars=yes');
    win.focus();
    return false;
}
function closePopup(win, newID, newRepr, id) {
    $(id).append('<option value=' + newID + ' selected >' + newRepr + '</option>')
    win.close();
}

</script>
{% endblock %}
{% endraw %}
{% endhighlight %}

Create an Ajax Call that will activate when edit link is clicked. This Ajax Call is made to get the ID of the name which it is associated.

{% highlight javascript %}
$("#edit_author").click(function(){
	author_name = $("#id_author option:selected").text();
	var data = {"author_name":author_name};
    $.ajax({
        type : 'GET',
        url :  '/author/ajax/get_author_id',
        data : data,
        success : function(data){
        	var url = "/author/" + data['author_id'] + "/edit/";
        	showEditPopup(url);
        },
        error: function(data) {
          alert("Something Went Wrong"); 
        }
  	});
})
{% endhighlight %}

#### Templates/author_form.html
Create a basic form for the foreign key Model i.e., Author in this example.

{% highlight django %}
{% raw %}
{% extends "base.html" %}

{% block content %}
<div class = "container">
	<h1>Author Form</h1>
	<form method = 'POST' action= '' enctype = "multipart/form-data" novalidate id = "author-form">{% csrf_token %}
		{{form.as_p}}
		<input type="submit" value = "Submit" />
	</form>
</div>
{% endblock %}
{% endraw %}
{% endhighlight %}

If you have followed the same example, you will get this type of output.


{% responsive_image path: img/reverse-engineering-of-the-django-admin-foreign-keys-addedit-button/1.jpg %}

## Final Words 

If you have any Question regarding the above tutorial feel free to comment below. And also share the experience with the DjangoPy in the comments below. You can find the repository from [here](https://github.com/djangopy-org/reverse-engineering-django-admin).

