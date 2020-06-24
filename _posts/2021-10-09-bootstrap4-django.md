---
layout: post
permalink: /how-to/bootstrap4-with-django/
cover_image: img/bootstrap-django/cover.png
category: how-to 
title:  "How to use Bootstrap 4 with Django"
date:   2021-11-10 20:34:07 +0530
author: "Jai Singhal"
comments: true
tags: ajax django bootstrap bootstrap4 django-bootstrap-form
description: In this post we will learn, how to use Bootstrap 4 framework with Django
kofi: jai_singhal
toc: true
---

## Introduction

In this short guide, we will learn how to add front-end component library such as Bootstrap (specifically version 4) to your Django Project. This guide is oriented to Bootstrap ver. 4, however you can use different version also.

The implementation of Bootstrap will help you to render the pages in a nice, responsive, mobile-first projects with minimal steps.

***

## Adding Bootstrap

For adding bootstrap to your project, you can either download the compiled CSS, JS version along with *Jquery*, or you can use the bootstrap hosted CDN. You can find more info on Bootstrap on [getbootstrap.com](https://getbootstrap.com/)

```html
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
```

```html
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
```

You can include this *CSS* and *JS* CDN in your base template. So that you can extend this base template to other templates, which saves you writing same code again and again.

Note he `block` such as head, style, content and script, we will write the code in between of these blocks.

**templates/base.html**
{% highlight django %}
{% raw %}

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    {% block head %}
    {% endblock %}

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

    {% block style %}
    {% endblock %}

    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous">
    </script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
    </script>
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

***

## Using Bootstrap in the project

Now let's use the Bootstrap in the Django Project. For the sake of demonstration, we are using different kind of components to illustrate how to use it in your real project. You can grab your utility components from [Bootstrap Documentation](https://getbootstrap.com/docs/4.3/getting-started/introduction/).

**templates/index.html**
{% highlight django %}
{% raw %}

{% extends "base.html" %}

{% block content %}

<div class="container">
    <h1>Hello World</h1>
    <h2>Hello World</h2>
    <h3>Hello World</h3>
    <h4>Hello World</h4>

    <hr>
    <div class="alert alert-primary" role="alert">
        A simple primary alert—check it out!
    </div>
    <hr>

    <button type="button" class="btn btn-primary">Primary</button>
    <button type="button" class="btn btn-secondary">Secondary</button>
    <hr>

    <div class="card" style="width: 18rem;">
        <img src="..." class="card-img-top" alt="...">
        <div class="card-body">
            <h5 class="card-title">Card title</h5>
            <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's
                content.</p>
            <a href="#" class="btn btn-primary">Go somewhere</a>
        </div>
    </div>

    <hr>
    <div class="progress">
        <div class="progress-bar" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0"
            aria-valuemax="100"></div>
    </div>

    <hr>

    <nav aria-label="Page navigation example">
        <ul class="pagination">
            <li class="page-item"><a class="page-link" href="#">Previous</a></li>
            <li class="page-item"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">Next</a></li>
        </ul>
    </nav>
    <hr>
</div>

{% endblock %}

{% endraw %}
{% endhighlight %}

After adding several components, you will get this type of output.

<br/>

![Screenshot 1](https://i.imgur.com/MKQqF7a.png)

<br/>

***

## Bootstraping Django forms

Let's now add the bootstrap to the django forms.

**models.py**

For the demo, let's create

```python
from django.db import models
from django.conf import settings

class Post(models.Model):
    title = models.CharField(max_length=100, blank = True)
    content = models.TextField(blank=True)
    user_id = models.ForeignKey(settings.AUTH_USER_MODEL,  on_delete=models.CASCADE)
    draft = models.BooleanField(default = False)
    timestamp = models.DateTimeField(auto_now=False, auto_now_add = True)

    def __str__(self):
        return self.title
```

**views.py**

```python
from django.shortcuts import render
from django.views.generic import CreateView
from .models import Post

class PostCreateView(CreateView):
    model = Post
    fields = ["title", "content", "draft"]
    template_name = 'post-form.html'
    success_url = '/'
```

**templates/post-form.html**

{% highlight django %}
{% raw %}
{% extends "base.html" %}

{% block content %}
<div class="container">
    <div class="col-6">
        <h1 class = "heading">Create Post</h1>
        <hr/>
        <form id="postForm" method="POST">
            {% csrf_token %}
            {{ form.as_p }}
            <input type="submit" name="post-submit" class="btn btn-primary" />
        </form>
    </div>

</div>
{% endblock %}
{% endraw %}
{% endhighlight %}

***

## Final Words
