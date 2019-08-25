---
layout: post
title:  "Getting started with Django"
date:   2017-05-20 20:34:07 +0530
category: learn
permalink: /learn/getting-started-with-django/
cover_image: img/introduction-to-django/code-pc-sublime-img.jpg
author: "Jai Singhal"
comments: true

tags: getting-started-with-django my-first-django-app my-first-django-site virtualenv
description: After too much motivation, now it's time to get started with Django. To develop your Django-powered site, you first need to install Python on your system. It is highly recommended to install the latest version of Python.
---

After too much motivation, now it's time to get started with Django. To develop your Django-powered site, you first need to install Python on your system. It is highly recommended to install the latest version of Python, and for those people who are using Python2, it is recommended to switch to Python3. You can easily download the latest version from here.

If you are not familiar with Python, then you should need to brush up your basic knowledge of Python from here.

Now after completely installing python on your system, let's set up the virtual environment(Why?)

A Virtual Environment is a tool to keep the dependencies required by your different projects in separate places, by creating virtual Python environments for them, it keeps your global python site-packages directory clean and manageable.

Settings Up Virtualenv
Virtualenv creates an isolated Python Environment by creating a folder which contains all the Python executables files, and all the necessary Packages that your project would need.

First Install the Virtualenv on your system via pip:-

{% highlight shell %}
$ pip install virtualenv
{% endhighlight %}

You can verify your virtualenv version by-

{% highlight shell %}
$ virtualenv --version
{% endhighlight %}
Now let's create a Virtualenv. Change the directory you want to start your project

{% highlight shell %}
$ cd /where/you/want_to/store/your/project
$ virtualenv venv
{% endhighlight %}

Sometimes in Linux system, you need to explicitly mention that you are creating for python3

{% highlight shell %}
virtualenv -p python3 venv
{% endhighlight %}

Here, venv is the name of the folder, you have created (you can change to whatever name you like). This will install setuptools, pip, wheel and all other packages and dependencies your project would need.

Now to begin with your created virtualenv(venv), you need to activate it, change the directory to the venv folder

{% highlight shell %}
$ cd venv
{% endhighlight %}

For Linux/Mac users,
{% highlight shell %}
$ source bin/activate
{% endhighlight %}

For Windows users,

{% highlight shell %}
$ .\scripts\activate
{% endhighlight %}

Notice that (venv) should be written to the current directory in terminal/cmd.If you are done with working with your virtualenv, you can deactivate it.

{% highlight shell %}
$ deactivate
{% endhighlight %}

Installing Django
Now that you have successfully set up your virtualenv, now you need to install the Django package.

{% highlight shell %}
$ pip install django
{% endhighlight %}

You can download Django of the specific version by specifying the version explicitly. But it is recommended to use the latest version of Django.

{% highlight shell %}
$ pip install django==version
{% endhighlight %}

Check your installed Django version before moving further. If Django is installed, you should see the version of the django you have installed. If it is not installed, it will give an error telling "No module named django"

{% highlight shell %}
$ python -m django --version
{% endhighlight %}

Creating your first Django project
Django Project is a directory where django keep its settings file, Database, and all the Scripts, you will be working upon.

{% highlight shell %}
$ django-admin startproject mysite
{% endhighlight %}

It will create the mysite directory containing the files/folders as listed below-

{% highlight markdown %}
mysite/
    manage.py
    mysite/
        __init__.py
        settings.py
        urls.py
        wsgi.py
{% endhighlight %}

You can change the name outer mysite/ name as you want, many of the developers change it to src, because this is the container of your project, and also it is root directory which all your source code within it. What these .py files actually are, let's see-

manage.py is a command line utility that lets you interact with your Django project, It contains all the necessary commands you would need like starting the server, creating an app, collect static files which will be discussed later.
__init__.py is a blank python file that tells Python that this directory should be considered a Python package.
settings.py is the main configuration of your Django project, that tells you about how the settings work.
urls.py is the URL declaration for your site, i.e., a Table of Content of your Django-powered site.
wsgi.py is an entry-point for WSGI-compatible web servers to serve your project.
The Development server
Now that you have completely setup your Django project let's verify that it works. Change your directory to outer mysite folder(or src folder), where your manage.py file is kept. Open up terminal/cmd and write-

{% highlight markdown %}
python manage.py runserver
{% endhighlight %}

You will see this following output on your command line

{% highlight markdown %}
Performing system checks...

System check identified no issues (0 silenced).

You have 13 unapplied migration(s). Your project may not work properly until you
 apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
May 09, 2017 - 12:58:48
Django version 1.11.1, using settings 'mysite.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CTRL-BREAK.
{% endhighlight %}

Open up your browser and browse https://127.0.0.1:8000/ or http://localhost:8000/. You will see this type of output.


<script type='text/javascript' src='https://ko-fi.com/widgets/widget_2.js'></script><script type='text/javascript'>kofiwidget2.init('Buy me a coffee', '#46b798', 'N4N812393');kofiwidget2.draw();</script> 


 
