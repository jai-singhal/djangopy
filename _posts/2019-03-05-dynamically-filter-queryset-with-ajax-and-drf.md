---
layout: post
title:  "Dynamically filter queryset with AJAX and DRF"
date:   2019-03-05 20:34:07 +0530
category: learn
permalink: /learn/dynamically-filter-queryset-with-ajax-and-drf
cover_image: img/dynamically-filter-queryset-with-ajax-and-drf/cover.jpg
author: "Jai Singhal"
comments: true
tags: ajax dynamically-filter-queryset-with-ajax-and-drf django django-rest-framework
description: In this post we will learn, how to filter the queryset using AJAX and DRF
kofi: jai_singhal
toc: true
---

## Introduction

Filtering queryset dynamically is something that is very common in use. In this post, we will learn how to dynamically filter the queryset depending on the several filters on top of each other. If you do not have hands-on AJAX, then you should definitely check out this **[post](https://djangopy.org/learn/step-up-guide-to-implement-ajax-in-django)**

This post contains a lot of javascript, don't panic just bear with me, I will explain every aspect of it. As usual, the complete project code is available on Github. You can find the link at the end of this post.

The promo GIF of what we will be building is shown below.
<br />
<br />

![Post Promo GIF](/img/dynamically-filter-queryset-with-ajax-and-drf/django_filter.gif)

<br />
<br />
<br />


## Initial Setup

There is some initial setup that has to be done before starting the real project.

The directory structure of the following project would be like this, we would need to create some new files for this project.

#### Directory Structure
```
├── dynamic_filter
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── static
│   └── js
│       └── wine.js
├── wine
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   ├── models.py
│   ├── pagination.py
│   ├── serializers.py
│   ├── templates
│   │   ├── base.html
│   │   └── wine.html
│   ├── tests.py
│   ├── urls.py
│   └── views.py
├── loaddata.py
├── manage.py
├── db.sqlite3
└── wine.csv
```
<br />
<br />

It is good to have on parent template i.e., **base.html** that can be extended in other templates. If already have, ignore this step. We will be using Bootstrap4 as our CSS framework and jQuery library as always to remove the burden of writing CSS and JS from scratch.

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
<br />
<br />

#### Setting static path
We will be going to write a lot of Javascript for this project, so it's better you create a static folder for putting all CSS/js in the same folder. For that, you have to create a new folder name **static** and in there create **js** folder(just like shown in **directory structure**). Also, list the path in your **settings.py**.

{% highlight python %}
STATIC_URL = '/static/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]
{% endhighlight %}

<br />
<br />

#### Installing DRF

We gonna need Django rest framework for this project, so you need to install it
{% highlight bash %}
$ pip install django_rest_framework
{% endhighlight %}

And put the rest_framework in your **INSTALLED_APPS** in **settings.py**

{% highlight python %}
INSTALLED_APPS = [
    ...
    "rest_framework",
]
{% endhighlight %}

<hr />
<br />

## Feed the data
Since we need a lot of data to get better results after filtering, I suggest to download the data, I have found a dataset on [Kaggle](https://kaggle.com). You can download the data from **[here](/data/dynamically-filter-queryset-with-ajax-and-drf/wine.rar)**. After downloading it, copy it to the Django main directory(where manage.py lives)

Create new app named **wine**

{% highlight python %}
$ python manage.py startapp wine
{% endhighlight %}

Put the app name in **settings.py** file.

{% highlight python %}
INSTALLED_APPS = [
    ...
    "wine",
]
{% endhighlight %}

<hr />
<br />

Create a table for storing the data. Open up your wine/models.py file and create the models with the following columns.

**wine/models.py**
{% highlight python %}
{% raw %}
from django.db import models

class Wine(models.Model):
	country = models.CharField(max_length = 100)
	designation = models.CharField(max_length = 200, null = True)
	description = models.TextField(null = True)
	points = models.CharField(max_length = 20, null = True)
	price = models.CharField(max_length = 20, null = True)
	province = models.CharField(max_length = 100, null = True)
	region = models.CharField(max_length = 150, null = True)
	taster_name = models.CharField(max_length = 120, null = True)
	title = models.CharField(max_length = 200, null = True)
	variety = models.CharField(max_length = 150, null = True)
	winery = models.CharField(max_length = 150, null = True)

	def __str__(self):
		return self.title
{% endraw %}
{% endhighlight %}

<br />

Migrate this table to database.

{% highlight bash %}
$ python manage.py makemigrations
{% endhighlight %}

{% highlight bash %}
$ python manage.py migrate
{% endhighlight %}

Now that you have downloaded the data and created a structure to store it, let us import the data from the downloaded CSV. Note that you have copied the **wine.csv** file in the main directory(where manage.py lives). For any confusion follow the directory structure as shown above.

Open the Django shell
{% highlight bash %}
$ python manage.py shell
{% endhighlight %}

<br />
Execute this script to import all the data from the **wine.csv** file, It will take almost 1-2 minute to import the data of total **6500** rows of entries.

{% highlight bash %}
from wine.models import Wine
import csv

wine_csv = open('wine.csv', 'r', encoding = "utf-8") 
reader = csv.reader(wine_csv)
headers = next(reader, None)[1:]

for row in reader:  
   wine_dict = {}
   for h, val in zip(headers, row[1:]):
      wine_dict[h] = val
   wine = Wine.objects.create(**wine_dict)

wine_csv.close()  
{% endhighlight %}



<hr />
<br />

## Creating REST API

Let's now write the business logic of our problem, we will first begin with our serializers, serializers in REST framework work very similarly to Django's Form and ModelForm classes. If you are new with Django Rest framework, you can brush up some basic from **[here](https://www.django-rest-framework.org/).**


**wine/serializers.py**

{% highlight python %}
from rest_framework import serializers
from .models import Wine

class WineSerializers(serializers.ModelSerializer):
	class Meta:
	    model = Wine
	    fields = ('id', 'description', 'designation', 'country', "taster_name", "title",
	    		'points', 'price', 'province', 'region', 'variety', 'winery')
{% endhighlight %}

<br />

#### Customizing Pagination
This step is not necessary, but it's good to know about it. This will customize the default pagination class which we will be using to make our REST API.

**wine/pagination.py**

{% highlight python %}
from rest_framework import pagination
class StandardResultsSetPagination(pagination.PageNumberPagination):
    page_size = 7 # change the records per page from here

    page_size_query_param = 'page_size'

{% endhighlight %}

<hr />
<br />

### Creating Views
Now let's write our views of this project. It includes two important things that need to be discussed.

##### 1. WineListing
This class-based view inherits the **ListAPIView**, which takes the pagination class which we have created above, and also the serializers class.

In this class, we need to override the **get_queryset** method which will return the query set.

In the **get_queryset** method, we will filter the queryset on the basis of query parameters, which we are getting from frontend via AJAX call. For whatever filters, applied by the user, it will check in each **if condition**, and filter down by the respective pararmeter. Likewise, it will perform filters based on the other query parameters. After it completely gets refined with all the filters, we simply return the filtered query set.
<br />
##### 2. AJAX GET methods
All other functional based views help us to get the values to fill in the options of the select box. It is much similar to what we have talked in our previous [post](https://djangopy.org/learn/step-up-guide-to-implement-ajax-in-django). All these functions are kind similar to each other.

**wine/views.py**

{% highlight python %}
from django.http import JsonResponse
from django.shortcuts import render
from rest_framework.generics import ListAPIView
from .serializers import WineSerializers
from .models import Wine
from .pagination import StandardResultsSetPagination

def WineList(request):
	return render(request, "wine.html", {})

class WineListing(ListAPIView):
    # set the pagination and serializer class

	pagination_class = StandardResultsSetPagination
	serializer_class = WineSerializers

	def get_queryset(self):
        # filter the queryset based on the filters applied

		queryList = Wine.objects.all()
		country = self.request.query_params.get('country', None)
		variety = self.request.query_params.get('variety', None)
		province = self.request.query_params.get('province', None)
		region = self.request.query_params.get('region', None)
		sort_by = self.request.query_params.get('sort_by', None)

		if country:
		    queryList = queryList.filter(country = country)
		if variety:
		    queryList = queryList.filter(variety = variety)
		if province:
		    queryList = queryList.filter(province = province)
		if region:
		    queryList = queryList.filter(region = region)    

        # sort it if applied on based on price/points

		if sort_by == "price":
		    queryList = queryList.order_by("price")
		elif sort_by == "points":
		    queryList = queryList.order_by("points")
		return queryList


def getCountries(request):
    # get all the countreis from the database excluding 
    # null and blank values

    if request.method == "GET" and request.is_ajax():
        countries = Wine.objects.exclude(country__isnull=True).\
            exclude(country__exact='').order_by('country').values_list('country').distinct()
        countries = [i[0] for i in list(countries)]
        data = {
            "countries": countries, 
        }
        return JsonResponse(data, status = 200)


def getvariety(request):
    if request.method == "GET" and request.is_ajax():
        # get all the varities from the database excluding 
        # null and blank values

        variety = Wine.objects.exclude(variety__isnull=True).\
        	exclude(variety__exact='').order_by('variety').values_list('variety').distinct()
        variety = [i[0] for i in list(variety)]
        data = {
            "variety": variety, 
        }
        return JsonResponse(data, status = 200)


def getProvince(request):
    # get the provinces for given country from the 
    # database excluding null and blank values

    if request.method == "GET" and request.is_ajax():
        country = request.GET.get('country')
        province = Wine.objects.filter(country = country).\
            	exclude(province__isnull=True).exclude(province__exact='').\
            	order_by('province').values_list('province').distinct()
        province = [i[0] for i in list(province)]
        data = {
            "province": province, 
        }
        return JsonResponse(data, status = 200)


def getRegion(request):
    # get the regions for given province from the 
    # database excluding null and blank values
    
    if request.method == "GET" and request.is_ajax():
        province = request.GET.get('province')
        region = Wine.objects.filter(province = province).\
                exclude(region__isnull=True).exclude(region__exact='').values_list('region').distinct()
        region = [i[0] for i in list(region)]
        data = {
            "region": region, 
        }
        return JsonResponse(data, status = 200)

{% endhighlight %}

<hr />
<br />

For all the FBV and CBV, which we have created just above, let's now create routes for each of these views. Let's first include the app url into main **urls.py** file, this will help to confine all the wine(app) url into a separate urls file. Note that we have given the namespace to the wine url.

**urls.py**
{% highlight python %}
{% raw %}
from django.contrib import admin
from django.urls import path
from django.conf.urls import url, include

urlpatterns = [
    path('admin/', admin.site.urls),
    url(r"^wine/", include(("wine.urls", "wine"), namespace = "wine"))
]

{% endraw %}
{% endhighlight %}

<br />

Create a new file named **urls.py** in wine app, which will contains the url path of all the view function and class based views of wine app, which is discussed above. Note that we are assigning name to every essential url paths, these names are going to be used as reverse url template tags in templates.

**wine/urls.py**

{% highlight python %}
{% raw %}
from django.urls import path
from wine.views import *

urlpatterns = [
    path('', WineList),
    path("wine_listing/", WineListing.as_view(), name = 'listing'),
    path("ajax/countries/", getCountries, name = 'get_countries'),
    path("ajax/variety/", getvariety, name = 'get_varieties'),
    path("ajax/province/", getProvince, name = 'get_provinces'),
    path("ajax/region/", getRegion, name = 'get_regions'),
]

{% endraw %}
{% endhighlight %}

<br />
<hr />
<br />


## Creating Front-end

Now that backend, is ready now, let's move to frontend part. The wine template extends from **base** template containing the select form inputs, and table structure with the table headers.

It is important to note that every select input contains attribute of url, which is nothing but the reverse url template tag containing the name of the url, Django matches the url name and return an absolute path reference (a URL without the domain name) matching a given view. You can learn more about this from [here.](https://docs.djangoproject.com/en/2.1/ref/templates/builtins/#url)

**templates/wine.html**
{% highlight django %}
{% raw %}
{% extends "base.html" %}
{% load staticfiles %}
{% block style %}
    <style type="text/css">
    .properties_table{
       min-height: 540px;
       font-size: 14px;
    }
    </style>
{% endblock %}
{% block content %}
    <section class="site_filter">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-2 col-2">
                    <div class="form-group">
                        <label for="country">Country</label>
                        <select class="form-control" id="countries" 
                            url = "{%url 'wine:get_countries' %}">
                        </select>
                    </div>
                </div>
                <div class="col-sm-2 col-2">
                    <div class="form-group">
                        <label for="Variety">Variety</label>
                        <select class="form-control" id="variety" 
                            url = "{%url 'wine:get_varieties' %}">
                        </select>
                    </div>
                </div>
                <div class="col-sm-2 col-2">
                    <div class="form-group">
                        <label for="Province">Province</label>
                        <select class="form-control" id="province" 
                            url = "{%url 'wine:get_provinces' %}">
                            <option value='all' selected>All Provinces</option>
                        </select>
                    </div>
                </div>
                <div class="col-sm-2 col-2">
                    <div class="form-group">
                        <label for="Region">Region</label>
                        <select class="form-control" id="region" url = "{%url 'wine:get_regions' %}">
                            <option value='all' selected>All Regions</option>
                        </select>
                    </div>
                </div>
                <div class="col-sm-2 col-2">
                    <div class="form-group">
                        <label for="Province">Sort By</label>
                        <select class="form-control" id="sort_by">
                            <option selected="true"
                            disabled="disabled" value = "none">Choose option</option>
                            <option value='price'>Price</option>
                            <option value='points'>Points</option>
                        </select>
                    </div>
                </div>
                <div class="col-sm-2 col-2">
                    <div class="row justify-content-center align-self-center"
                        style="color:white; margin-top:30px;">
                        <a class="btn btn-secondary" id="display_all">Display all</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <br />
    <section>
        <div class="container-fluid">
            <div id = "result-count" class="text-right">
                <span class='font-weight-bold'></span> results found.
            </div>
            <div class="row properties_table justify-content-center">
                <div id = "no_results">
                    <h5>No results found</h5>
                </div>
                <table class="table table-bordered table-responsive table-hover table-striped"
                 id="list_data" data-toggle="table" url = "{% url 'wine:listing' %}">
                    <thead>
                        <tr>
                            <th data-field="country">Country</th>
                            <th data-field="taster_name">Taster name</th>
                            <th data-field="title">Title</th>
                            <th data-field="description">Description</th>
                            <th data-field="designation">Designation</th>
                            <th data-field="points">Points</th>
                            <th data-field="price">Price</th>
                            <th data-field="province">Province</th>
                            <th data-field="region">Region</th>
                            <th data-field="winery">Winery</th>
                            <th data-field="variety">Variety</th>
                        </tr>
                    </thead>
                    <tbody id="listing">
                    </tbody>
                </table>
            </div>
            <div class="row justify-content-center">
                <nav aria-label="navigation">
                    <ul class="pagination">
                        <li class="page-item">
                            <button class="btn btn-primary page-link" id="previous">Previous</button>
                        </li>
                        <li class="page-item pull-right">
                            <button class="btn btn-primary page-link" id="next">Next</button>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </section>
{% endblock %}
{% block script %}
    <script src="{% static 'js/wine.js' %}" type="text/javascript">
    </script>
{% endblock %}
{% endraw %}
{% endhighlight %}

<br />
<hr />
<br />

### Creating Wine.js
Moving on the most challenging part of this project, the **Javascript**. I have tried to provide the comments to most of the lines in the below **JS** snippet, which will make easy for you to understand in a better way. If you are able to understand for a single filter, then it is easy for you to understand for other filters too, because they have kinda similar js code.

**static/js/wine.js**
{% highlight javascript %}
{% raw %}
// variable that keeps all the filter information
var send_data = {}

$(document).ready(function () {
    // reset all parameters on page load
    resetFilters();
    // bring all the data without any filters
    getAPIData();
    // get all countries from database via 
    // AJAX call into country select options
    getCountries();
    // get all varities from database via 
    // AJAX call into variert select options
    getvariety();

    // on selecting the country option
    $('#countries').on('change', function () {
        // since province and region is dependent 
        // on country select, emty all the options from select input
        $("#province").val("all");
        $("#region").val("all");
        send_data['province'] = '';
        send_data['region'] = '';

        // update the selected country
        if(this.value == "all")
            send_data['country'] = "";
        else
            send_data['country'] = this.value;

        //get province of selected country
        getProvince(this.value);
        // get api data of updated filters
        getAPIData();
    });

    // on filtering the variety input
    $('#variety').on('change', function () {
        // get the api data of updated variety
        if(this.value == "all")
            send_data['variety'] = "";
        else
            send_data['variety'] = this.value;
        getAPIData();
    });

    // on filtering the province input
    $('#province').on('change', function () {
        // clear the region input 
        // since it is dependent on province input
        send_data['region'] = "";
        $('#region').val("all");
        if(this.value == "all")
            send_data['province'] = "";
        else
            send_data['province'] = this.value;
        getRegion(this.value);
        getAPIData();
    });

    // on filtering the region input
    $('#region').on('change', function () {
        if(this.value == "all")
            send_data['region'] = "";
        else
            send_data['region'] = this.value;
        getAPIData();
    });

    // sort the data according to price/points
    $('#sort_by').on('change', function () {
        send_data['sort_by'] = this.value;
        getAPIData();
    });

    // display the results after reseting the filters
    $("#display_all").click(function(){
        resetFilters();
        getAPIData();
    })
})


/**
    Function that resets all the filters   
**/
function resetFilters() {
    $("#countries").val("all");
    $("#province").val("all");
    $("#region").val("all");
    $("#variety").val("all");
    $("#sort_by").val("none");

    //clearing up the province and region select box
    getProvince("all");
    getRegion("all");

    send_data['country'] = '';
    send_data['province'] = '';
    send_data['region'] = '';
    send_data['variety'] = '';
    send_data["sort_by"] = '',
    send_data['format'] = 'json';
}

/**.
    Utility function to showcase the api data 
    we got from backend to the table content
**/
function putTableData(result) {
    // creating table row for each result and
    // pushing to the html cntent of table body of listing table
    let row;
    if(result["results"].length > 0){
        $("#no_results").hide();
        $("#list_data").show();
        $("#listing").html("");  
        $.each(result["results"], function (a, b) {
            row = "<tr> <td>" + b.country + "</td>" +
            "<td>" + b.taster_name + "</td>" +
            "<td title=\"" + b.title + "\">" + b.title.slice(0, 50) + "..." + "</td>" +
                "<td title=\"" + b.description + "\">" + b.description.slice(0, 60) + "..." + "</td>" +
                "<td>" + b.designation + "</td>" +
                "<td>" + b.points + "</td>" +
                "<td>" + b.price + "</td>" +
                "<td>" + b.province + "</td>" +
                "<td>" + b.region + "</td>" +
                "<td>" + b.winery + "</td>" +
                "<td>" + b.variety + "</td></tr>"
            $("#listing").append(row);   
        });
    }
    else{
        // if no result found for the given filter, then display no result
        $("#no_results h5").html("No results found");
        $("#list_data").hide();
        $("#no_results").show();
    }
    // setting previous and next page url for the given result
    let prev_url = result["previous"];
    let next_url = result["next"];
    // disabling-enabling button depending on existence of next/prev page. 
    if (prev_url === null) {
        $("#previous").addClass("disabled");
        $("#previous").prop('disabled', true);
    } else {
        $("#previous").removeClass("disabled");
        $("#previous").prop('disabled', false);
    }
    if (next_url === null) {
        $("#next").addClass("disabled");
        $("#next").prop('disabled', true);
    } else {
        $("#next").removeClass("disabled");
        $("#next").prop('disabled', false);
    }
    // setting the url
    $("#previous").attr("url", result["previous"]);
    $("#next").attr("url", result["next"]);
    // displaying result count
    $("#result-count span").html(result["count"]);
}

function getAPIData() {
    let url = $('#list_data').attr("url")
    $.ajax({
        method: 'GET',
        url: url,
        data: send_data,
        beforeSend: function(){
            $("#no_results h5").html("Loading data...");
        },
        success: function (result) {
            putTableData(result);
        },
        error: function (response) {
            $("#no_results h5").html("Something went wrong");
            $("#list_data").hide();
        }
    });
}

$("#next").click(function () {
    // load the next page data and 
    // put the result to the table body
    // by making ajax call to next available url
    let url = $(this).attr("url");
    if (!url)
        $(this).prop('all', true);

    $(this).prop('all', false);
    $.ajax({
        method: 'GET',
        url: url,
        success: function (result) {
            putTableData(result);
        },
        error: function(response){
            console.log(response)
        }
    });
})

$("#previous").click(function () {
    // load the previous page data and 
    // put the result to the table body 
    // by making ajax call to previous available url
    let url = $(this).attr("url");
    if (!url)
        $(this).prop('all', true);

    $(this).prop('all', false);
    $.ajax({
        method: 'GET',
        url: url,
        success: function (result) {
            putTableData(result);
        },
        error: function(response){
            console.log(response)
        }
    });
})

function getCountries() {
    // fill the options of countries by making ajax call
    // obtain the url from the countries select input attribute
    let url = $("#countries").attr("url");

    // makes request to getCountries(request) method in views
    $.ajax({
        method: 'GET',
        url: url,
        data: {},
        success: function (result) {

            countries_option = "<option value='all' selected>All Countries</option>";
            $.each(result["countries"], function (a, b) {
                countries_option += "<option>" + b + "</option>"
            });
            $("#countries").html(countries_option)
        },
        error: function(response){
            console.log(response)
        }
    });
}

function getvariety() {
    // fill the options of varities by making ajax call
    // obtain the url from the varities select input attribute
    let url = $("#variety").attr("url");
    // makes request to getvariety(request) method in views
    $.ajax({
        method: 'GET',
        url: url,
        data: {},
        success: function (result) {
            winery_options = "<option value='all' selected>All Varieties</option>";
            $.each(result["variety"], function (a, b) {
                winery_options += "<option>" + b + "</option>"
            });
            $("#variety").html(winery_options)
        },
        error: function(response){
            console.log(response)
        }
    });
}

function getProvince(country) {
    // fill the options of provinces by making ajax call
    // obtain the url from the provinces select input attribute
    let url = $("#province").attr("url");
    // makes request to getProvince(request) method in views
    let province_option = "<option value='all' selected>All Provinces</option>";
    $.ajax({
        method: 'GET',
        url: url,
        data: {
            "country": country
        },
        success: function (result) {
            $.each(result["province"], function (a, b) {
                province_option += "<option>" + b + "</option>"
            });
            $("#province").html(province_option)
        },
        error: function(response){
            console.log(response)
        }
    });
}

function getRegion(province) {
    // fill the options of region by making ajax call
    // obtain the url from the region select input attribute
    let url = $("#region").attr("url");
    // makes request to getRegion(request) method in views
    let region_option = "<option value='all' selected>All regions</option>";
    $.ajax({
        method: 'GET',
        url: url,
        data: {
            "province": province
        },
        success: function (response) {
            $.each(response["region"], function (a, b) {
                region_option += "<option>" + b + "</option>"
            });
            $("#region").html(region_option);
        },
        error: function(response){
            console.log(response)
        }
    });
}

{% endraw %}
{% endhighlight %}

<hr />
<br />

## Final Words
AJAX is the best way to do asynchronous tasks on a small scale. However, if you want to perform asynchronous tasks at a very large scale, you can opt any frontend javascript framework/library, the best available in the market are **React**, **Angular**, **Vue**.

If you have any problem in the steps discussed above, you can look out our **GitHub** **repository** 
[https://github.com/djangopy-org/dynamic_filter](https://github.com/djangopy-org/dynamic_filter) or you can comment down below. 
