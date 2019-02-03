 (function(){
      emailjs.init("user_JMRUsf1DxWEa19XU0UwjO");
   })();

var contact_form = $("#contact_form");
contact_form.submit(function(event){
  event.preventDefault();

  // Change to your service ID, or keep using the default service
  var service_id = "default_service";
  var template_id = "template_L0DHnyyK";

  contact_form.find("button").text("Sending...");
  emailjs.sendForm(service_id,template_id, "contact_form")
    .then(function(){ 
       contact_form.find("button").text("Sent!!");
       contact_form[0].reset();
    }, function(err) {
       contact_form.find("button").text("Send");
    });
  return false;
});
