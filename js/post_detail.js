
$(document).ready(function(){
    var disqus_shortname = 'django-py'; 
    //   var disqus_developer = 1; // Comment out when the site is live
    var disqus_identifier = "{{ page.permalink }}";
    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();

})

