---
layout: post
title:  "Pagination with Django"
date:   2017-05-31 17:23:56 +0530
category: how-to-archives
permalink: /how-to/pagination-with-django/
cover_image: img/pagination-with-django/cover.jpg
author: "Jai Singhal"
comments: true

tags:  django-pagination pagination-with-django bootstrap-pagibation
description: Django provides a few classes that can help you to manage your paginated data i.e., data that’s split across several pages, with “Previous/Next” links or list it into discrete page numbers.
---

## Introduction
You may have come across a problem of displaying many objects in a single page. Pagination allows you to divide the objects into discrete pages. It is very difficult to show up all the objects in a single page. For example, if you are running a blog website, when you want to list all the post, it is better to divide the posts into pages.

Django provides a few classes that can help you to manage your paginated data i.e., data that are split across several pages, with “Previous/Next” links or list it into discrete page numbers. You can use the Django Pagination by including the class that lives in django/core/paginator.py

Let's understand by an example of Blog app.



##### Models.py

{% highlight python %}
from django.db import models
from django.utils import timezone
from django.conf import settings

class Post(models.Model):
	title = models.CharField(max_length = 100)
	content = models.TextField()
	author = models.ForeignKey(settings.AUTH_USER_MODEL, default=1)
	publish = models.DateField(auto_now=True, auto_now_add = False)
{% endhighlight %}

Now I have created 25 posts of random title and content using a shell just to demonstrate the example.

After this, let's create the post list view in view.py under the main Homepage URL.



#### Views.py
{% highlight python %}
def post_list(request):
	queryset_list = Post.objects.all().order_by("id")
	paginator = Paginator(queryset_list, 3) #posts per page
	page = request.GET.get('page')
	try:
		queryset = paginator.page(page)
	except PageNotAnInteger:
		queryset = paginator.page(1)
	except EmptyPage:
		queryset = paginator.page(paginator.num_pages)

	context = {
		"object_list" : queryset,
	}
	return render(request, "list.html", context)
{% endhighlight %}

Now that we have completely setup our views, it's time create the template list.html.

Note: I have included all the necessary CSS and JS of Jquery and Bootstrap in base.html, and using the Template inheritance of Django, I have content block described in list.html

There are two types of pagination you can use in your template.

##### 1.) Using only the previous and next buttons
Pagination can be done by providing two buttons for navigating either previous page or next page from the current page. This is the basic way to Paginate your Django Page. You could also show the page numbers along with the previous and next buttons.


{% highlight django %}
{% raw %}
{% extends "base.html" %}

{% block content %}
{% for obj in object_list %}
  <div class = "container">
    <div class = "col-md-6">
      id = {{obj.id}}<br>
      title = {{obj.title}}<br>
      content = {{obj.content}}<br>
      publish = {{obj.publish}}<br>
      <hr>
    </div>
  </div>
{% endfor %}
<div class = "container">
  <div class = "col-md-6">
    <ul class="pager">
      <span class="step-links">
        {% if object_list.has_previous %}
        <li class="previous"> <a href="?page={{ object_list.previous_page_number }}">Previous</a></li>
        {% else %}
        <li class="previous"> <a title = "No Posts available">Previous</a></li>
        {% endif %}
        {% if object_list.has_next %}
        <li class="next"><a href="?page={{ object_list.next_page_number }}">Next</a></li>
        {% else %}
        <li class="next"><a title = "No Posts available">Next</a></li>
        {% endif %}
        </span>
     </ul>
  </div>
</div>

{% endblock %}
{% endraw %}
{% endhighlight %}



{% responsive_image path: img/pagination-with-django/1.jpg %}


#### 2.) Using Discrete Page Numbers
Listing the range of page numbers with left and right navigation of page can be another alternative to Paginate your page.

{% highlight django %}
{% raw  %}
{% extends "base.html" %}
{% block content %}

{% for obj in object_list %}
<div class = "container">
  <div class = "col-md-6">
    <br>
    <p>id = {{obj.id}}</p>
    <p>title = {{obj.title}}</p>
    <p>content = {{obj.content}}</p>
    <p>publish = {{obj.publish}}</p>
    <hr>
  </div>
</div>
{% endfor %}
<div class = "container">
  <div class = "col-md-6">
    <nav aria-label="Page navigation example">
      <ul class="pagination">
        <li class="page-item">  <!-- Jump to Prvious Page -->
          {% if object_list.has_previous %}
             <li class="previous"> <a href="?page={{ object_list.previous_page_number }}">
             <span aria-hidden="true">‹</span></a>
          {% else %}
              <li class="previous disabled"><a>‹</a>
          {% endif %}
        </li>
         {% for page in object_list.paginator.page_range %}
            {% if page == object_list.number %}
            <li class="pg active"><a class = "page_number" href="?page={{page}}">{{page}}</a>
            {% else %}
            <li class="pg"><a class = "page_number" href="?page={{page}}">{{page}}</a>
            {% endif %}
        {% endfor %}
        <li class="page-item">  <!-- Jump to Next Page -->
          {% if object_list.has_next %}
            <li class="previous"> <a href="?page={{ object_list.next_page_number }}">›</a></li>
          {% else %}
              <li class="next disabled"><a>›</a>
          {% endif %}
        </li>
      </ul>
    </nav>
  </div>
</div>
{% endblock %}
{% endraw %}
{% endhighlight %}


{% responsive_image path: img/pagination-with-django/2.jpg %}




## Improving above Pagination
Suppose, you have 100's of objects that are listed 4 per page, so it will make 20 discrete page numbers which would become cumbersome and surely look Bad.

So we can improve this Pagination by showing 5 pages numbers at a time in Pagination, and 4 other buttons that will jump to the next sequence of page numbers.

">>" and "<<" buttons will help the user to jump directly to the first page and last page respectively. "..." button present at left and right will help the user to move to the first page (last page) of the previous sequence and next sequence respectively.
{% responsive_image path: img/pagination-with-django/4.jpg %}


Note: If you want to increase/decrease the page number showing at a time(like 5 in this example), you can change it by increasing/decreasing the loop iteration shown in the below according to your need. And also you need to change the skip_pages variable in Script.


{% highlight django %}
{% raw  %}
{% extends "base.html" %}
{% block content %}
{% for obj in object_list %}
  <div class = "container">
    <div class = "col-md-6">
      <br>
      <p>id = {{obj.id}}</p>
      <p>title = {{obj.title}}</p>
      <p>content = {{obj.content}}</p>
      <p>publish = {{obj.publish}}</p>
      <hr>
    </div>
  </div>
{% endfor %}
  <div class = "container">
    <div class = "col-md-6">
      <nav aria-label="Page navigation example">
        <ul class="pagination">
          <li class="page-item">    <!-- Jump to First Page -->
            {% if object_list.number != 1 %}
               <li class="previous">
                  <a href="?page=1">
                    <span aria-hidden="true">&laquo;</span></a>
            {% else %}
                <li class="previous disabled">
                <a><span aria-hidden="true">&laquo;</span></a>
            {% endif %}
          </li>
          <li class="page-item">  <!-- Jump to Prvious Page -->
            {% if object_list.has_previous %}
               <li class="previous"> <a href="?page={{ object_list.previous_page_number }}">
               <span aria-hidden="true">‹</span></a>
            {% else %}
                <li class="previous disabled"><a>‹</a>
            {% endif %}
          </li>
          {% if object_list.has_previous %}
          <li class="page-item">  <!-- Show Previous 4 page numbers -->
              <li class="previous"> <a class = "skip_prev" href = "">...</a></li>
          {% else %}
                <li class="next disabled"><a>...</a>
          {% endif %}
          </li>
          {% for i in "12345" %}
        <!-- Change the range ("12345") according to your choice to show numbers -->
            <li class="pg" data = {{i}}><a class = "page_number" href=""></a>
          {% endfor %}

          {% if object_list.has_next %}
          <li class="page-item">  <!-- Show next 4 page numbers -->
              <li class="previous"> <a class = "skip_next" href = "">...</a></li>
          {% else %}
                <li class="next disabled"><a>...</a>
          {% endif %}
          </li>
          <li class="page-item">  <!-- Jump to Next Page -->
            {% if object_list.has_next %}
              <li class="previous"> <a href="?page={{ object_list.next_page_number }}">›</a></li>
            {% else %}
                <li class="next disabled"><a>›</a>
            {% endif %}
          </li>
          <li class="page-item">  <!-- Jump to Last Page -->
            {% if object_list.number != object_list.paginator.num_pages %}
              <li class="previous"> <a href="?page={{ object_list.paginator.num_pages }}">»</a></li>
            {% else %}
                <li class="next disabled"><a>»</a>
            {% endif %}
          </li>
        </ul>
      </nav>
    </div>
  </div>
{% endblock %}
{% endraw %}
{% endhighlight %}


You have to include this Jquery Script to power the above HTML. Paste this script to the script container or in script of  base.html

Note: If you want to change the number of pages showing at a time, change the skip_pages value according to your need keeping in mind that you have the same number of iterations discussed above.

{% highlight django %}
{% raw  %}
{% block script %}
<script>
$(document).ready(function(){

  var skip_pages = 5; //change your number accordingly you want to show numbers

  var total_pages = {{object_list.paginator.num_pages}};
  var current_page = {{object_list.number}};
  var factor = Math.floor(current_page/skip_pages);

  $(".page_number").each(function(i, obj) {   //Showing the discrete numbers
        var page = factor*(skip_pages) + i + 1;
        if(current_page%skip_pages == 0)
          page = (factor-1)*skip_pages + i + 1;
        if(page - 1 < total_pages){
          $(this).html(page);
          $(this).attr("href", "?page=" + page);
        }
        else{
          var x = i+1;
          $('li[data=' + x + ']').css("display", "none");
        }
  });
    var page = current_page%skip_pages;
    if(page == 0)
      page = skip_pages;
    $('li[data=' + page + ']').each(function(){   //Deciding the active class
      $('li[data=' + page + ']').addClass("active");
    });

  $(".skip_next").click(function(){   //Skip next ... Function
      if(current_page%skip_pages == 0)
        factor = factor-1;
      var page = (factor+1)*skip_pages + 1;
      if(page < total_pages)
        $(this).attr("href", "?page=" + page);
      else
        $(this).attr("href", "?page=" + total_pages);
  })
  $(".skip_prev").click(function(){ //Skip Previous ... Function
      if(current_page%skip_pages == 0)
        factor = factor-1;
      var page = skip_pages*(factor-1) + 1;
      if(page > 0)
        $(this).attr("href", "?page=" + page);
      else
        $(this).attr("href", "?page=" + "1");
  })
})

</script>
{% endblock %}
{% endraw %}
{% endhighlight %}

<br>
Finally, the Pagination would look like


{% responsive_image path: img/pagination-with-django/3.jpg %}



Play around with the design you want to show you Pagination. I have shown 3 of the most used Pagination in websites.

Comment your different ways to Paginate your Django page, it will help others too.

For more information and option available in Pagination class visit the Official Documentation of Django Pagination
