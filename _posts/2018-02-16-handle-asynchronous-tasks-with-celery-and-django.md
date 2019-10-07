---
layout: post
title:  "Handle Asynchronous Tasks using celery and Django"
date:   2018-02-16 20:34:07 +0530
category: how-to
permalink: /how-to/handle-asynchronous-tasks-with-celery-and-django
cover_image: img/handle-asynchronous-tasks-with-celery-and-django/cover.png
author: "Jai Singhal"
comments: true
tags: handle-asynchronous-tasks-with-celery-and-django celery django redis djangopy scheduling django-celery asynchronous jai-singhal how-to periodic-tasks supervisord supervisor
description: In this post we will learn, how to implement celery to django application, to handle asynchronous tasks with Celery.
toc: true
---

## Introduction
 We offen need something that schedule some tasks and run the some tasks periodically or handling the long tasks asynchronously, these all things can achieved by using Celery in Django Project.

##### What is Celery?
Celery is a task queue with focus on the real-time processing, which also supports task scheduling. Celety is fast, simple, highly available and flexible.

Celery need a message transport to send and recieve message which can done by Redis or RabbitMQ.

<hr>
<br>
## Getting Started

Let's start installing the Celery package in your virtualenv.

##### Install Celery
{% highlight bash %}
$ pip install celery
{% endhighlight %}


##### Install Redis

We will be using Message broker as Redis, So let's install


###### Linux/Mac users
You can download the latest version from [here](https://redis.io/download)

{% highlight bash %}
$ wget http://download.redis.io/releases/redis-4.0.8.tar.gz
$ tar xzf redis-4.0.8.tar.gz
$ cd redis-4.0.8
$ make
{% endhighlight %}

###### Windows users
For windows user, you can get executable file of redis from **[here](https://github.com/rgl/redis/downloads)**

After installing, try if it is correctly installed or not. 

{% highlight bash %}
$ redis-cli ping
{% endhighlight %}

It should respond with
{% highlight bash %}
pong
{% endhighlight %}


Also install python package of the redis
{% highlight bash %}
$ pip install redis
{% endhighlight %}


<hr>
<br>
## First Step with Django

Now that you have successfully installed the packages, now lets get's hand on Django Project


#### settings.py
Add some of the setting configuration in your **settings.py**

{% highlight python %}
CELERY_BROKER_URL = 'redis://localhost:6379'
CELERY_RESULT_BACKEND = 'redis://localhost:6379'
CELERY_ACCEPT_CONTENT = ['application/json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_TIMEZONE = "YOUR_TIMEZONE"
{% endhighlight %}

Make sure you have changed your **timezone** from **YOUR_TIMEZONE**. You can get your timezone from [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

Create an **celery.py** file in your main Django project directory

{% highlight bash %}
- src/
  - manage.py
  - celery_project/
    - __init__.py
    - settings.py
    - urls.py
    - celery.py
{% endhighlight %}

<br>
#### celery_project/celery.py

Add the following code in the celery.py module. This module is used to define the celery instance.

Make sure you have changed your project name (\<your project name>\) with your django project name

{% highlight python %}
from __future__ import absolute_import, unicode_literals
import os
from celery import Celery

# set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', '<your project name>.settings')

app = Celery('<your project name>')

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
# - namespace='CELERY' means all celery-related configuration keys
#   should have a `CELERY_` prefix.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Load task modules from all registered Django app configs.
app.autodiscover_tasks()

@app.task(bind=True)
def debug_task(self):
    print('Request: {0!r}'.format(self.request))

{% endhighlight %}
<br>

#### celery_project/\__init__\.py
Then we need to import the app defined the **celery.py** to **\__init__\.py** of your main project directory. By doing this, we can ensure that app is loaded when Django project starts 

{% highlight python %}
from __future__ import absolute_import, unicode_literals

# This will make sure the app is always imported when
# Django starts so that shared_task will use this app.
from .celery import app as celery_app

__all__ = ['celery_app']

{% endhighlight %}


<hr>
<br>

## Creating Tasks
Now let's create some task

Create a new file in your any app registered in the **INSTALLED_APPS**

##### my_app/tasks.py

{% highlight python %}
from __future__ import absolute_import, unicode_literals
from celery import shared_task

@shared_task(name = "print_msg_with_name")
def print_message(name, *args, **kwargs):
  print("Celery is working!! {} have implemented it correctly.".format(name))

@shared_task(name = "add_2_numbers")
def add(x, y):
  print("Add function has been called!! with params {}, {}".format(x, y))
  return x+y
{% endhighlight %}


<hr>
<br>

## Starting Worker Process

Open a **NEW** **terminal** and run the following command to run the worker instance of celery, and also change the directory to where your main project directory is, i,e, the directory where **manage.py** file is placed, and also make sure you have  **activated** your **virtualenv**(if created).

Change the project name with your project name

{% highlight bash %}
$ celery -A <your project name> worker -l info
{% endhighlight %}


You will get this type of output


{% highlight bash %}
 -------------- celery@root v4.1.0 (latentcall)
---- **** ----- 
--- * ***  * -- Linux-4.13.0-32-generic-x86_64-with-Ubuntu-17.10-artful 2018-02-17 08:09:37
-- * - **** --- 
- ** ---------- [config]
- ** ---------- .> app:         celery_project:0x7f9039886400
- ** ---------- .> transport:   redis://localhost:6379//
- ** ---------- .> results:     redis://localhost:6379/
- *** --- * --- .> concurrency: 4 (prefork)
-- ******* ---- .> task events: OFF (enable -E to monitor tasks in this worker)
--- ***** ----- 
 -------------- [queues]
                .> celery           exchange=celery(direct) key=celery
                

[tasks]
  . add_2_numbers
  . celery_project.celery.debug_task
  . print_msg_with_name

[2018-02-17 08:09:37,877: INFO/MainProcess] Connected to redis://localhost:6379//
[2018-02-17 08:09:37,987: INFO/MainProcess] mingle: searching for neighbors
[2018-02-17 08:09:39,084: INFO/MainProcess] mingle: all alone
[2018-02-17 08:09:39,121: WARNING/MainProcess] /home/jai/Desktop/demo/lib/python3.6/site-packages/celery/fixups/django.py:202: UserWarning: Using settings.DEBUG leads to a memory leak, never use this setting in production environments!
  warnings.warn('Using settings.DEBUG leads to a memory leak, never '
[2018-02-17 08:09:39,121: INFO/MainProcess] celery@root ready.

{% endhighlight %}

<br>
**NOTE**: Check for **[tasks]** above, it should contain name of the task which you have created in the module **tasks.py**.!! 

For more info and logs, you also run the worker instance in a **DEBUG MODE**
{% highlight bash %}
celery -A <your project name> worker -l info  --loglevel=DEBUG
{% endhighlight %}

**NOTE**: DO NOT CLOSE THIS TERMINAL, IT SHOULD REMAIN OPEN!!

<hr>
<br>


## Testing the Task
Now let's run the tasks from django shell
Open up your Django shell
{% highlight bash %}
$ python3 manage.py shell
{% endhighlight %}

And run the function with **delay**. 
{% highlight bash %}
>>> from my_app.tasks import print_message, add
>>> print_message.delay("Jai Singhal")
<AsyncResult: fe4f9787-9ee4-46da-856c-453d36556760>
>>> add.delay(10, 20)
<AsyncResult: ca5d2c50-87bc-4e87-92ad-99d6d9704c30>
{% endhighlight %}
<br>

When you check your second terminal where your celery worker instance is running, you will get this type of output, showing your tasks have been recieved and also they have successfully completed

{% highlight bash %}
[2018-02-17 08:12:14,375: INFO/MainProcess] Received task: my_app.tasks.print_message[fe4f9787-9ee4-46da-856c-453d36556760]  
[2018-02-17 08:12:14,377: WARNING/ForkPoolWorker-4] Celery is working!! Jai Singhal have implemented it correctly.
[2018-02-17 08:12:14,382: INFO/ForkPoolWorker-4] Task my_app.tasks.print_message[fe4f9787-9ee4-46da-856c-453d36556760] succeeded in 0.004476275000342866s: None
[2018-02-17 08:12:28,344: INFO/MainProcess] Received task: my_app.tasks.add[ca5d2c50-87bc-4e87-92ad-99d6d9704c30]  
[2018-02-17 08:12:28,349: WARNING/ForkPoolWorker-3] Add function has been called!! with params 10, 20
[2018-02-17 08:12:28,358: INFO/ForkPoolWorker-3] Task my_app.tasks.add[ca5d2c50-87bc-4e87-92ad-99d6d9704c30] succeeded in 0.010077004999857309s: 30
{% endhighlight %}



<hr><br>



## Periodic Tasks

We often need to periodically run our tasks in our django project, here celery fulfills our need with **celery beat** which is nothing but a scheduler, which kicks its target at a regular interval and it can defined both implictly and explictly.

Please do ensure that single scheduler is running for a schedule at a time, otherwise you’d end up with duplicate tasks

Set the timezone in the settings.py according to your time zone, which we have done that earlier in this tutorial.
{% highlight bash %}
timezone = 'Europe/London'
{% endhighlight %}

Now we can create periodic tasks by two ways, either by manually adding a code of scheduler in **celery.py**  or by installing a package **django-celery-beat** which can allows us to create schedulers in the Django Admin

### 1. Writing scheduler manually

Add the following schedule configuration in your **celery.py** file

###### celery_project/celery.py
{% highlight python %}
app.conf.beat_schedule = {
    'add-every-2-seconds': {  #name of the scheduler
        'task': 'add_2_numbers',  # task name which we have created in tasks.py
        'schedule': 2.0,   # set the period of running
        'args': (16, 16)  # set the args
    },
    'print-name-every-5-seconds': {  #name of the scheduler
        'task': 'print_msg_with_name',  # task name which we have created in tasks.py
        'schedule': 5.0,  # set the period of running
         'args': ("DjangoPY", )  # set the args
    },
}
{% endhighlight %}

Open the **NEW** terminal and run the following command

{% highlight bash %}
$ celery -A <project name> beat -l info
{% endhighlight %}

Make sure you are running worker process in a seperate terminal
{% highlight bash %}
celery -A <your project name> worker -l info 
{% endhighlight %}

You will get the output in the terminal where you have started celery beat process 
{% highlight bash %}
celery beat v4.1.0 (latentcall) is starting.
__    -    ... __   -        _
LocalTime -> 2018-02-17 09:56:30
Configuration ->
    . broker -> redis://localhost:6379//
    . loader -> celery.loaders.app.AppLoader
    . scheduler -> celery.beat.PersistentScheduler
    . db -> celerybeat-schedule
    . logfile -> [stderr]@%INFO
    . maxinterval -> 5.00 minutes (300s)
[2018-02-17 09:56:30,268: INFO/MainProcess] beat: Starting...

[2018-02-17 09:56:36,365: INFO/MainProcess] Scheduler: Sending due task add-every-2-seconds (add_2_numbers)
[2018-02-17 09:56:38,365: INFO/MainProcess] Scheduler: Sending due task add-every-2-seconds (add_2_numbers)
[2018-02-17 09:56:39,367: INFO/MainProcess] Scheduler: Sending due task print-name-every-5-seconds (print_msg_with_name)
[2018-02-17 09:56:40,365: INFO/MainProcess] Scheduler: Sending due task add-every-2-seconds (add_2_numbers)
[2018-02-17 09:56:42,365: INFO/MainProcess] Scheduler: Sending due task add-every-2-seconds (add_2_numbers)
...
{% endhighlight %}


<br>

And now if you look at the **worker** process terminal, you will find tasks are running periodically!!


{% highlight bash %}
[2018-02-17 09:56:36,371: WARNING/ForkPoolWorker-1] Add function has been called!! with params 16, 16
[2018-02-17 09:56:36,464: INFO/ForkPoolWorker-1] Task add_2_numbers[7e9f9ff5-4b01-42d3-b301-99a3b078484b] succeeded in 0.09404212199842732s: 32
[2018-02-17 09:56:38,368: INFO/MainProcess] Received task: add_2_numbers[097e8b56-7090-4561-9686-77d7aae6e2d6]  
[2018-02-17 09:56:38,369: WARNING/ForkPoolWorker-2] Add function has been called!! with params 16, 16
[2018-02-17 09:56:38,453: INFO/ForkPoolWorker-2] Task add_2_numbers[097e8b56-7090-4561-9686-77d7aae6e2d6] succeeded in 0.08399435899991659s: 32
[2018-02-17 09:56:39,371: INFO/MainProcess] Received task: print_msg_with_name[2b56d4a2-a358-4186-b849-66342d7635dc]  
[2018-02-17 09:56:39,372: WARNING/ForkPoolWorker-1] Celery is working!! DjangoPY have implemented it correctly.
[2018-02-17 09:56:39,456: INFO/ForkPoolWorker-1] Task print_msg_with_name[2b56d4a2-a358-4186-b849-66342d7635dc] succeeded in 0.08378831899972283s: None
{% endhighlight %}



### 2. Using django-celery-beat

Let's now do the above same thing with **django-celery-beat**

###### 1. Install django-celery-beat
{% highlight bash %}
$ pip install django-celery-beat
{% endhighlight %}

###### 2. Add into Installed apps 
Add the django_celery_beat module to INSTALLED_APPS in your Django project’ settings.py:

{% highlight python %}
INSTALLED_APPS = [
    ...
    'django_celery_beat',
]
{% endhighlight %}

###### 3. Run the django migrations
{% highlight bash %}
$ python manage.py migrate
{% endhighlight %}

<br>
**Note:** The database scheduler won’t reset when timezone related settings change, so you must do this manually:

{% highlight bash %}
$ python manage.py shell
>>> from django_celery_beat.models import PeriodicTask
>>> PeriodicTask.objects.update(last_run_at=None)
{% endhighlight %}


Now go to your Django Admin and create a **Periodic Task** as follows

Choose any name, and select the task which you have created, and also create a Crontab according to your need.
Please refer the guide or some of the examples of Crontab from [here. ](http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html#crontab-schedules)

{% responsive_image path: img/handle-asynchronous-tasks-with-celery-and-django/img1.png %}

<br>
Run the celery beat process in new terminal with **--scheduler** 
{% highlight bash %}
$ celery -A <project name> beat -l info --scheduler django_celery_beat.schedulers:DatabaseScheduler
{% endhighlight %}

Make sure you have running worker process in a seperate terminal with django server and celery beat process

{% highlight bash %}
celery -A <your project name> worker -l info 
{% endhighlight %}

Check the output logs in both of the terminals and check the logs in the respective terminals.

<hr><br>

## Running on Production

Now that celery is perfectly running locally, last thing we need to take care of the production. A question arises here that how we can run these process terminals together for all the time in our Production server, becuase we need to run both the process(beat and worker) to keep the celery working.

 So here Supervisor comes in handy that helps to run both of the instances seperately.

 Supervisor is a client/server system that allows its users to control and keeps it running the process in any unix-like Operating System. So we can use this, for runing celery processes.

 [Here](http://supervisord.org/) is the documentation for the Supervisor.



<hr><br>
## Resources
- [http://docs.celeryproject.org/en/latest/getting-started/first-steps-with-celery.html](http://docs.celeryproject.org/en/latest/getting-started/first-steps-with-celery.html)
- [http://docs.celeryproject.org/en/latest/django/first-steps-with-django.html](http://docs.celeryproject.org/en/latest/django/first-steps-with-django.html)
- [http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html](http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html)
- [http://supervisord.org](http://supervisord.org)


