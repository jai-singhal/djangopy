---
layout: post
title:  "Multiple Image upload in Django"
date:   2021-02-02 10:34:07 +0530
category: how-to
permalink: /how-to/multiple-image-upload-in-django
cover_image: img/multiple-images/cover.jpg
author: "Jai Singhal"
comments: true
tags: multiple-image-upload-in-django how-to django django-formset python-django multiple-forms multiple-image-upload blog-post multiple-images formsets 
description: In this tutorial, we will see how to upload more than one image in a form. We will be using django-formsets that helps to generate multiple forms in single page
---

# Introduction

In this tutorial, we will see how to upload more than one image in a form. We will be using **django-formsets** that helps to generate multiple forms in single page. Uploading multiple photos and connecting these with some foreign key is kind of tricky task that needs to be implemented.

Django Formsets allows to clone the same form as per need, it records all these information in its management form which is hidden when it is rendered. Information such as count of the total forms, intiial form count, you can read more from [here](https://docs.djangoproject.com/en/2.0/topics/forms/formsets/#understanding-the-managementform)

Django formsets are also very useful in the form validations, we can make the validations like we are making in simple Django forms.
<br />
<hr />
<br />
# Blog-Post Example

For the sake of understanding of this tutorial, I have taken an example of a blog, where there can multiple images for a post. I have choose this example because I think people find this task to difficult, so this way we can learn both the things i.e., learning django-formsets and uploading multiple images in a post. 
<br />

## models.py

I have created a simple **Post** model and a **Image** model, in which there is relationship of many-to-one between Post and Image i.e., many images have a foreign key relationship with one post. Upload handler is used for managing the upload of the image 

{% highlight python %}

from django.db import models
from django.conf import settings

class Post(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, default = 1, on_delete=models.CASCADE)
    title = models.CharField(max_length=80)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now=True, auto_now_add=False)
    draft = models.BooleanField()

    def __str__(self):
        return self.title


def upload_handler(instance, filename):
	return "%s/%s" % (instance.post.title, filename)

class Image(models.Model):
    file = models.ImageField(upload_to=upload_handler, 
                                height_field="height",
                                width_field="width",
                                max_length=200,
                                blank = False
                            )

    alt = models.CharField(max_length = 80, blank = True, null = True)
    height = models.IntegerField(default=0)
    width = models.IntegerField(default=0)
    post = models.ForeignKey(Post, on_delete=models.CASCADE, default = 1)
    
    def __str__(self):
        return self.file.name


{% endhighlight %}




<br />



## settings.py
For uploading the media, we have to set the root directory where we have to kept the static media files. Make an directory called **media_cdn** in your Base directory of your django project or choose any other directory you want.

{% highlight python %}
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(os.path.dirname(BASE_DIR), "media_cdn")
{% endhighlight %}




<br />
## forms.py
Now let's create their respective ModelForm for **Post** and **Image** models. Also a **FormSet** for image.

For handling validation errors in formset, we can create a clean method in a class inherited from **BaseFormSet**, where we can write our **clean** method for validation errors. Also during creating django formset we can pass keyword arguement **extra** to denote intial number of forms.

{% highlight python %}
from django import forms
from .models import (
    Post,
    Image,
)
from django.forms import formset_factory
from django.utils.translation import gettext_lazy as _

class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = "__all__"
        exclude = (
            "user",
        )

class ImageForm(forms.ModelForm):
    class Meta:
        model = Image
        fields = {
            "file",
            "alt"
        }


class BaseImageFormSet(forms.BaseFormSet):
    def clean(self):
        for form in self.forms:
            if not form.cleaned_data.get("file"):
                raise forms.ValidationError(_("Blank Images not allowed"))


ImageFormSet = formset_factory(ImageForm, extra=1, formset = BaseImageFormSet)
{% endhighlight %}






<br />

## views.py

Now that are formset and Model form is ready, let's create a view. I have used class based view instead of Function based view here.
The **PostView** is a CBV with methods such **get**, **post** and a helper method **get_forms** to get the context of all the forms. Also a **dispatch** method for handling authentication

As we are saving multiple instances then we have ensure the atomicity and integrity problem, which can solved using django transaction which is available in django.db. If you haven't used the transactions in django, you can read the documentation from [here](https://docs.djangoproject.com/en/2.0/topics/db/transactions/)

In **post** method of the class, we are saving the instance of post as well as instances of Images by django formsets and looping through each form we have in the set. Also a transaction savepoint and rollbacks are placed to avoid atomicity problem. 

During rendering multiple form, it is good practice to provide to prefix as an parameter, so that it can be distinguishable from other forms.  


{% highlight python %}
from django.shortcuts import render
from django.views import View
from django.http import HttpResponseRedirect
from django.db import transaction
from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import login_required
from .forms import (
    PostForm,
    ImageFormSet,
    ImageForm
)
from django.contrib import messages


class PostView(View):
    template_name = "index.html"
    form_class1 = PostForm
    form_class2 = ImageFormSet
    success_url = "/"
    
    @method_decorator(login_required)
    def dispatch(self, *args, **kwargs):
        return super(PostView, self).dispatch(*args, **kwargs)

    def get_forms(self, request, *args, **kwargs):
        context = {}
        context['postForm'] = self.form_class1(request.POST or None, prefix='post')
        context['imageForm'] = self.form_class2(request.POST or None, request.FILES or None, prefix = "images")
        return context

    def get(self, request, *args, **kwargs):
        context = self.get_forms(request, *args, **kwargs)
        return render(request, self.template_name, context)

    @transaction.atomic
    def post(self, request, *args, **kwargs):
        postFormInstance = self.form_class1(request.POST, prefix = "post")
        imageFormSet = self.form_class2(request.POST, request.FILES, prefix="images")
            
        sid = transaction.savepoint()  
              
        if postFormInstance.is_valid():
            postFormInstance = postFormInstance.save(commit=False)
            postFormInstance.user = request.user
            postFormInstance.save()
        else:
            messages.add_message(request, messages.ERROR, postFormInstance.errors)
            context = self.get_forms(request, *args, **kwargs)
            return render(request, self.template_name, context)

        if not imageFormSet.is_valid():
            transaction.savepoint_rollback(sid)
            messages.add_message(request, messages.ERROR, imageFormSet.non_form_errors())
            context = self.get_forms(request, *args, **kwargs)
            return render(request, self.template_name, context)

        for imgForm in imageFormSet:
            if imgForm.is_valid():
                imgFormInstance = imgForm.save(commit = False)
                imgFormInstance.post = postFormInstance
                imgFormInstance.save()
            else:
                messages.add_message(request, messages.ERROR, imgForm.errors)
                context = self.get_forms(request, *args, **kwargs)
                return render(request, self.template_name, context)

        transaction.savepoint_commit(sid)

        return HttpResponseRedirect(self.success_url)
{% endhighlight %}


<br />
## urls.py

Set the url for the view(CBV) which we have created as well as set the url pattern for static files.

{% highlight python %}

from django.urls import path
from django.conf import settings
from django.conf.urls.static import static

from my_app.views import PostView

urlpatterns += [
    path('', PostView.as_view())
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL,
                          document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)
{% endhighlight %}



<br />
## templates/base.html

A base template that has block for content and javaScript and include a jQuery script.
{% highlight django %}
{% raw %}
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Demo|DjangoPy</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    {% block style %} {% endblock %}
</head>
<body>
    {% block content %}{% endblock %}
    {% block script %} {% endblock %}
</body>
</html>
{% endraw %}
{% endhighlight %}




<br />
## templates/index.html


Let's create a template for forms like **postForm** and **imageForm**. 
For imageform, I have first included the management form which is discussed above, and also iterated over the number of initial forms in the formset, which is one in our case(extra=1).

Also Inlcude this Message template in your template(if not included).


{% highlight django %}
{% raw %}
{% extends "base.html" %}
{% block content %}

<!-- Message template -->
{% if messages %}
<ul class="messages">
    {% for message in messages %}
    <li{% if message.tags %} class="{{ message.tags }}" {% endif %}>{{ message }}</li>
        {% endfor %}
</ul>
{% endif %}
<!-- Message template -->

<form method="POST" id="form1" enctype="multipart/form-data">{% csrf_token %} 
    {{postForm.as_p}}
    <div id="imageForms">
        {{imageForm.management_form}}
        <button id="add-more-image" type="button">Add more images</button>
        {% for form in imageForm %}
        <div class="image-form">
            {{ form }}
        </div>
        {% endfor %}
    </div>
    <br>
    <input type="submit" />
</form>
{% endblock %} 
{% endraw %}
{% endhighlight %}

<br />
## javascript

Add some javascript(jQuery) to clone the form, when **Add more Images** is been clicked. Note I have used the jQuery syntax here.

{% highlight javascript %}
function cloneImageForm(imageFormElement){
    var total = $("#id_images-TOTAL_FORMS").val();
    imageFormElement.find('type:input').each(function() {
        var name = $(this).attr('name').replace('-' + (total-1) + '-','-' + total + '-');
        var id = 'id_' + name;
        $(this).attr({'name': name, 'id': id}).val('').removeAttr('checked');
    });
    imageFormElement.find('label').each(function() {
        var newFor = $(this).attr('for').replace('-' + (total-1) + '-','-' + total + '-');
        $(this).attr('for', newFor);
    });
    total++;
    $("#id_images-TOTAL_FORMS").val(total);
    $("#imageForms").append(imageFormElement);
}

$(document).ready(function () {
    $("#add-more-image").click(function (e) {
        var imageFormElement = $("#imageForms").find('.image-form').last().clone();
        e.preventDefault();
        cloneImageForm(imageFormElement);
    })
})
{% endhighlight %}

## Final Output
<br />
{% responsive_image path: img/multiple-images/screenshot1.png %}

<br />


## Adding css to the template

pip install django-widget-tweaks


INSTALLED_APPS += [
    'widget_tweaks',
]




# References
- [https://docs.djangoproject.com/en/2.0/topics/forms/formsets/](https://docs.djangoproject.com/en/2.0/topics/forms/formsets/)
- [https://docs.djangoproject.com/en/2.0/topics/db/transactions/](https://docs.djangoproject.com/en/2.0/topics/db/transactions/)