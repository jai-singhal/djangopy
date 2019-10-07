---
layout: post
title:  "Categories with django-mptt"
date:   2017-07-30 20:34:07 +0530
category: package-of-the-week
permalink: /package-of-week/categories-with-django-mptt/
cover_image: img/categories-with-django-mptt/cover.jpg
author: "Karan Suthar"
comments: true

tags: Django-Authentication-System Django-Authentication login logout register django djangopy

description: In this post, we'll learn how to implement categories in Django efficiently by storing hierarchical data in place of making many database queries since database queries are costly in terms of time complexity.
toc: true
---

## Introduction
In this tutorial, we will learn how to implement categories and breadcrumb in a Django site. Categories may be related to each other as child-parent, so categories are hierarchical data and to store and access them efficiently mptt i.e modified preorder tree traversal should be used in which the number of database queries made is minimum. There are some referral links provided at the end of the article to understand how CRUD operations are applied on hierarchical data efficiently.

## Installation
{% highlight shell %}
pip3 install django-mptt
{% endhighlight %}

And add **mptt** in **INSTALLED_APPS** in **settings.py** 

## Jump into the code

We will be implementing categories and breadcrumb for a blog website. So consider following models for my_posts app in Django project. 

#### Models.py
{% highlight python %}
from django.db import models
from mptt.models import MPTTModel, TreeForeignKey

class Post(models.Model):
  title = models.CharField(max_length=120)
  category = TreeForeignKey('Category',null=True,blank=True)
  content = models.TextField('Content')
  slug = models.SlugField()

  def __str__(self):
    return self.title
{% endhighlight %}

##### And category model be :

{% highlight python %}
class Category(MPTTModel):
  name = models.CharField(max_length=50, unique=True)
  parent = TreeForeignKey('self', null=True, blank=True, related_name='children', db_index=True)
  slug = models.SlugField()

  class MPTTMeta:
    order_insertion_by = ['name']

  class Meta:
    unique_together = (('parent', 'slug',))
    verbose_name_plural = 'categories'

  def get_slug_list(self):
    try:
      ancestors = self.get_ancestors(include_self=True)
    except:
      ancestors = []
    else:
      ancestors = [ i.slug for i in ancestors]
    slugs = []
    for i in range(len(ancestors)):
      slugs.append('/'.join(ancestors[:i+1]))
    return slugs

  def __str__(self):
    return self.name
{% endhighlight %} 

Now run migration commands to create database tables. To show categories in admin panel add following to project_name/my_posts/admin.py

 

#### Admin.py
{% highlight python %}
from mptt.admin import MPTTModelAdmin

admin.site.register(Post,PostAdmin)
admin.site.register(Category , MPTTModelAdmin) 
{% endhighlight %}

Now run the following command to collect static files from mptt, provided that you've already defined STATIC_ROOT in settings.py

{% highlight bash %}
python3 manage.py collectstatic
{% endhighlight %}

Doing these steps, you can now add some nested categories by selecting categories > ADD  CATEGORY of my_posts app in Django Admin panel, there is an image below to illustrate how to create a category object.

 

{% responsive_image path: img/categories-with-django-mptt/1_cropped.jpg %}


 

After adding some categories, we have following category tree

 
{% responsive_image path: img/categories-with-django-mptt/2_cropped.jpg %}


 

If you want to change the indentation pixels i.e the space before each category object so that the relation between them can be determined easily, add the following line of code in settings.py

{% highlight python %}
MPTT_ADMIN_LEVEL_INDENT = 20   #you can replace 20 with some other number
                                 #to change indentation space
{% endhighlight %}

The category tree showed above is not collapsable and expandable, you can tweak this by changing **my_posts/admin.py** as

{% highlight python %}
from mptt.admin import DraggableMPTTAdmin

admin.site.register(Post,PostAdmin)
admin.site.register(Category, DraggableMPTTAdmin )
{% endhighlight %}

{% responsive_image path: img/categories-with-django-mptt/3_cropped.jpg %}


Now go to posts > ADD POST then you will find category drop-down to associate a category to that post, this field is not a required field so you may leave it untouched. 

 

 
{% responsive_image path: img/categories-with-django-mptt/4_cropped.jpg %}
 

#### Urls.py
Next, we have to add URL pattern for the category, so go to urls.py and add the following line to the urlpatterns list.

{% highlight python %}
url(r'^category/(?P<hierarchy>.+)/$', views.show_category, name='category'),
{% endhighlight %}

#### Views.py
Now in views.py add the following function.
{% highlight python %}
def show_category(request,hierarchy= None):
    category_slug = hierarchy.split('/')
    parent = None
    root = Category.objects.all()

    for slug in category_slug[:-1]:
        parent = root.get(parent=parent, slug = slug)

    try:
        instance = Category.objects.get(parent=parent,slug=category_slug[-1])
    except:
        instance = get_object_or_404(Post, slug = category_slug[-1])
        return render(request, "postDetail.html", {'instance':instance})
    else:
        return render(request, 'categories.html', {'instance':instance})
 {% endhighlight %}

#### Templates/categories.html
Add following code in categories.html.

{% highlight django %}
{% raw %}
{% extends 'base.html' %}
{% load static  %}

{% block head_title %} {{ instance.name }} {% endblock %}

{% block content %}
<br>
<div class="text-center"><h2>{{instance.name}}</h2></div>

{% if  instance.children.all %}
    <h4>Sub Categories</h4>
    {% for i in instance.children.all %}
        <a href="{{ i.slug }}"> {{ i.name }} </a><br>
    {% endfor %}

    <br><hr>
{% endif %}

{% if  instance.post_set.all %}
 {% for i in instance.post_set.all %}
  <h4>Posts</h4>
  <div class="row small-up-1 medium-up-3" >

   <div class="column">
    <a href="{{ i.slug }}">
      <div class="card" style="width: 300px; border-color: black">
         <div class="card-divider">
           <strong>{{ i.title | truncatechars:30}}</strong>
         </div>

         <div class="card-section">
          <small>{{ i.publish}} </small>
          <p>{{ i.content | safe | truncatechars_html:120 }}</p>
         </div>
      </div>
    </a>
   </div>
{% endfor %}

{% endif %}
</div>
{% endblock %}
{% endraw %}
{% endhighlight %}
 
The CSS framework used is Zurb's Foundation 6 you may use bootstrap as well.

 

Next,  add following code snippet inside the postDetail.html template to implement breadcrumbs in post detail page ( you should add it above post's title ).

{% highlight django %}
{% raw %}
{% load namify %}

<ul class="breadcrumbs">
    <li><a href="/">Home</a></li>
     
    {% for i in instance.category.get_slug_list %}
       <li><a href="/category/{{ i }}">{{ i | get_name }}</a></li>
    {% endfor %}

</ul> 
 {% endraw %}
{% endhighlight %}

Note that filter get_name is used to extract the name of categories from the slug.

To implement this filter create a directory templatetags at the same level as models.py, views.py, etc in my_post app and create a empty python file __init__.py to ensure the directory is treated as a Python package and create another python file namify.py, add following code in it.

 
{% highlight python %}
from django import template

register = template.Library()

@register.filter
def get_name(value):
    spam = value.split('/')[-1]         # assume value be /python/web-scrapping
                                        # spam would be 'web-scrapping'
    spam = ' '.join(spam.split('-'))    # now spam would be 'web scrapping'
    return spam
{% endhighlight %}

Finally, we have following post detail page for recently created post

 
{% responsive_image path: img/categories-with-django-mptt/5_cropped.jpg %}

 

The breadcrumb above the title of the post is useful in navigation, for example, if you click web scrapping then it will take you to the catogories.html page where you can navigate posts in web scrapping as well as its sub categories as in the following image.

{% responsive_image path: img/categories-with-django-mptt/6_cropped.jpg %}

 

## FINAL WORDS
Modified Preorder Tree Traversal is not just limited to categories but can also be used for efficiently accessing and storing hierarchical data. Although insert and move operations are not as efficient if the tree is changing frequently. However, overall mptt is currently the best solution for database queries overhead. If you have  any problem in any step discussed above, you can check our Github Repository from [here](https://github.com/djangopy-org/django_mptt_categories). 

## RELATED PACKAGES 

  - django-categories
  - django-treenav
 <br/> <br/>


## USEFUL LINKS
[https://github.com/django-mptt/django-mptt](https://github.com/django-mptt/django-mptt)

[https://www.caktusgroup.com/blog/2016/01/04/modified-preorder-tree-traversal-django/](https://www.caktusgroup.com/blog/2016/01/04/modified-preorder-tree-traversal-django/)

[https://www.sitepoint.com/hierarchical-data-database/](https://www.sitepoint.com/hierarchical-data-database/)

[http://mikehillyer.com/articles/managing-hierarchical-data-in-mysql/](http://mikehillyer.com/articles/managing-hierarchical-data-in-mysql/)

Happy Coding :)

