---
layout: post
title:  "How to Implement Categories in Django"
date:   2017-07-08 17:23:56 +0530
category: how-to
permalink: /how-to/how-to-implement-categories-in-django/
cover_image: img/how-to-implement-categories-in-django/cover.jpg
author: "Karan Suthar"
comments: true

tags: Django-breadcrumbs how-to-implement-categories-in-django Implement-Categories-in-Django Modified-Preorder-Tree Traversal-MPTT Modified-Preorder-Tree-Traversal-Django categories-in-django django-categories nested categories DjangoPy-Foundation django sub-categories

description: In this tutorial, we'll learn how to implement categories and subcategories in our Django project without using any external module.
---

## Introduction
Categories are essential for any website because it is easy for users to access content sorted by categories. Categories may have their subcategories, and subcategories may also have subcategories and so on. So in this post, I'll explain how to implement nested categories in a Django project. You can create categories with Django Admin Panel and then associate it with content like an article or post, So let's get started.

Let's implement categories for blog posts, consider my_posts app in the project, add following models in it

#### Models.py
{% highlight python %}
class Category(models.Model):
    name = models.CharField(max_length=200)
    slug = models.SlugField()
    parent = models.ForeignKey('self',blank=True, null=True ,related_name='children')

    class Meta:
        unique_together = ('slug', 'parent',)    #enforcing that there can not be two
        verbose_name_plural = "categories"       #categories under a parent with same 
                                                 #slug 

    def __str__(self):                           # __str__ method elaborated later in
        full_path = [self.name]                  # post.  use __unicode__ in place of
                                                 # __str__ if you are using python 2
        k = self.parent                          

        while k is not None:
            full_path.append(k.name)
            k = k.parent

        return ' -> '.join(full_path[::-1])
{% endhighlight %}

Next, we'll use category in Post model as a foreign key.

{% highlight python %}
class Post(models.Model):
    user =  models.ForeignKey(settings.AUTH_USER_MODEL,default=1)
    title = models.CharField(max_length=120)
    category = models.ForeignKey('Category', null=True, blank=True)
    content = HTMLField('Content')
    draft = models.BooleanField(default=False)
    publish = models.DateField(auto_now=False,auto_now_add=False,)
    slug = models.SlugField(unique=True)

    def __str__(self):
        return self.title


    def get_cat_list(self):           #for now ignore this instance method,
        k = self.category
        breadcrumb = ["dummy"]
        while k is not None:
            breadcrumb.append(k.slug)
            k = k.parent

        for i in range(len(breadcrumb)-1):
            breadcrumb[i] = '/'.join(breadcrumb[-1:i-1:-1])
        return breadcrumb[-1:0:-1]
{% endhighlight %} 

So with Category being a foreign key in Post model, a category can be associated with post.

Open the terminal and change the current working directory to one that contains manage.py then run following migration commands.  

{% highlight bash %}
python3 manage.py makemigrations
python3 manage.py migrate
{% endhighlight %}

Now we make some Category object from the interactive shell so open Django interactive shell by typing following command in terminal.

{% highlight bash %}
python3 manage.py shell
{% endhighlight %}

Then in shell, you can create categories as illustrated below

{% highlight bash %}
>>> from my_posts.models import *
>>> fruits = Category.objects.create(name='fruits', slug='fruits')
>>> fruits
<Category: fruits>
>>> beverages = Category.objects.create( name='bevarages', slug='beverages' )
>>>
>>> berry = Category.objects.create( name = 'berry', slug = 'berry', parent = fruits )
>>> citrus_fruits = Category.objects.create(name='citrus fruits', slug='citrus-fruits', parent=fruits)
>>>
>>> hot_bev = Category.objects.create( name = 'hot', slug = 'hot' , parent = beverages )
>>> cold_bev = Category.objects.create( name = 'cold', slug = 'cold', parent = beverages )
>>>
>>> Category.objects.all()
<QuerySet [<Category: fruits -> berry>, <Category: bevarages>, <Category: fruits -> citrus fruits>, 
<Category: bevarages -> cold>, <Category: fruits>, <Category: bevarages -> hot>]>
>>>
>>> Category.objects.get(name='fruits')
<Category: fruits>
>>> f = Category.objects.get(name='fruits', parent=None)
>>> f
<Category: fruits>

>>> f.children.all()
<QuerySet [<Category: fruits -> berry>, <Category: fruits -> citrus fruits>]>
>>> b =  f.children.get( name='berry', parent=f)
>>> b
<Category: fruits -> berry>

>>> Category.objects.all().delete()            #to delete all the Category objects
(6, {'my_posts.Category': 6})
{% endhighlight %}

 

Now we'll add categories with Django Admin Panel, so add following code to admin.py

{% highlight python %}
Admin.py
from .models import Category

admin.site.register(Category)
{% endhighlight %}

then run the server by 

{% highlight bash %}
python3 manage.py runserver
{% endhighlight %}

Now go to admin panel from your browser, you'll see category there.


{% responsive_image path: img/how-to-implement-categories-in-django/1.jpg %}

 

 

Now we add some main categories, by main categories I mean the categories having a null parent. Go to categories and click "Add Category" and add the category like in the image below.

 

 
{% responsive_image path: img/how-to-implement-categories-in-django/2.jpg %}


 

 

Now to illustrate the nested categories add one more main category say "python", now add a category "news" as a subcategory of "python", you have to select "python" as the parent category of "news", like in the image below.

 

 

{% responsive_image path: img/how-to-implement-categories-in-django/3.jpg %}


 

 

Now for sake of well understanding add one more category "2017" having  "news"  as parent category like in the image below.

 
{% responsive_image path: img/how-to-implement-categories-in-django/4.jpg %}

 

 

Now the categories we've created are showed as follow.

 

{% responsive_image path: img/how-to-implement-categories-in-django/5.jpg %}


 

 

You may be wondering how '-- >' are appended after categories ( which is useful in distinguishing between same-named subcategories of a different parent at any level ), this is since we have defined the __str__ method in Category model.

Let's add a post to illustrate how to associate a category with it, so go to the home in admin panel then go to post and click 'add post' button.
{% responsive_image path: img/how-to-implement-categories-in-django/6.jpg %}


 

#### Urls.py
As you can see in the image, we have added the post in python > news > 2017. Next, we have to add URL pattern for the category, so go to urls.py and add the following line in urlpatterns list.

{% highlight python %}
url(r'^category/(?P<hierarchy>.+)/$', views.show_category, name='category'),
{% endhighlight %} 

#### Views.py

{% highlight python %}

Now in views.py add the following function.

def show_category(request,hierarchy= None):
    category_slug = hierarchy.split('/')
    category_queryset = list(Category.objects.all())
    all_slugs = [ x.slug for x in category_queryset ]
    parent = None
    for slug in category_slug:
        if slug in all_slugs:
            parent = get_object_or_404(Category,slug=slug,parent=parent)
        else:
            instance = get_object_or_404(Post, slug=slug)
            breadcrumbs_link = instance.get_cat_list()
            category_name = [' '.join(i.split('/')[-1].split('-')) for i in breadcrumbs_link]
            breadcrumbs = zip(breadcrumbs_link, category_name)
            return render(request, "postDetail.html", {'instance':instance,'breadcrumbs':breadcrumbs})

    return render(request,"categories.html",{'post_set':parent.post_set.all(),'sub_categories':parent.children.all()})
{% endhighlight %} 

Note that the last element of the category_slug list in show_category could either be a Post object or a category object, 

For example the parameter hierarchy may be '/python/news' or it may be  'python/news/2017/instagram-makes-a-move-to-python-3/'  in former case the last element of category_slug would be a category object but in later case it is a Post object,  so in for loop tracing categories with hierarchical relation so if the last element be a Post object then it will be rendered with "postDetail.html" template, otherwise if it be a Category object then it will be rendered with "categories.html" template.

In context dictionary, 'breadcrumbs' are there because you may want to have the breadcrumb in your post detail page.

 

##### Templates/categories.html
Add following code in "categories.html".
{% highlight django %}
{% raw %}
{% extends 'base.html' %}
{% load static  %}
{% block content %}
<br>
{% if sub_categories %}
    <h3>Sub Categories</h3>
    {% for i in sub_categories %}
        <a href="{{ i.slug }}"> {{ i.name }} </a>
    {% endfor %}
{% endif %}

<div class="row small-up-1 medium-up-3" >
{% if post_set %}
{% for i in post_set %}
    <div class="columns">
        <div class=" card-article-hover card">
          <a href="{{ i.slug }}">
            <img  src="{{ i.cover_photo.url }}">
          </a>
          <div class="card-section">
            <a href="{{ i.slug }}">
              <h6 class="article-title">{{ i.title | truncatechars:30}}</h6>
            </a>
          </div>
          <div class="card-divider flex-container align-middle">
            <a href="" class="author">{{ i.user.get_full_name }}</a>
          </div>
          <div class="hover-border">
          </div>
        </div>
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
<ul class="breadcrumbs">
  <li><a href="/">Home</a></li>
      {% for slug,name in breadcrumbs %}
          <li><a href="/category/{{ slug }}">{{ name }}</a></li>
      {% endfor %}
</ul>
{% endraw %}
 {% endhighlight %}

So breadcrumbs in post detail page would look like in the image below.

 

{% responsive_image path: img/how-to-implement-categories-in-django/7.jpg %}


 

 

And our Category pages would look like images below

 



 

 

Note that we have only a subcategory in Python/news and no post so only subcategory there. But in '2017' there is no subcategory and a simple post which showed in the image below.

 



 

 

You may be wondering about the cover_image attribute used in template code and hence reflected in card view of the post in above photo, the cover_photo is a field in Post model and for brevity, I did not include the cover_photo attribute in code. If you have any queries regarding it then comment below.

 

## CONCLUSION

Although this approach is not most efficient because we are making many database queries, but for small websites and blogs this approach is good to go. If you are working on some projects like a news website or e-commerce website which contain many level of nested categories then you may want to find a comparatively efficient way to implement category with Modified Preorder Tree Traversal (MPTT), there is Django package available for it, read a post on how to implement categories with django-mptt here. 

If you have any query let me know in the comments below.

Happy coding :) 

<script type='text/javascript' src='https://ko-fi.com/widgets/widget_2.js'></script><script type='text/javascript'>kofiwidget2.init('Buy me a coffee', '#46b798', 'N4N812393');kofiwidget2.draw();</script> 