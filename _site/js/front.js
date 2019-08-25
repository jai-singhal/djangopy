var data = {};

// function processPageView(e) {
//     $.map(e, function (e) {
//         data[e[0]] = e[1]
//     });
//     var t = $("#ga-page-view").attr("ga-page-url");
//     $("#ga-page-view").text(data[t]), $(".ga-page-view").each(function (e, a) {
//         t = $(this).attr("ga-page-url"), $(this).text(data[t])
//     })
// }
$(document).ready(function () {
    "use strict";
    // $.ajax({
    //     url: "/pageviews.json",
    //     dataType: "json",
    //     timeout: 1e4,
    //     success: function (e) {
    //         processPageView(e.rows)
    //     },
    //     error: function () {
    //         console.log("Error in fetching views")
    //     }
    // });
    $(".post-content a").each(function (e, t) {
        $(t).parent().is("h1") || $(t).parent().is("h2") || $(t).parent().is("h3") ? ($(this).css("text-decoration", "none"), $(this).css("color", "#212529")) : $(t).attr("target", "_blank")
    });
    var e = [];
    $("#search_button").click(function () {
        if ($("#search").val(""), $("#search_results").html(""), e.length) return !1;
        $.ajax({
            type: "GET",
            url: "/feed.xml",
            dataType: "xml",
            success: function (t) {
                $($(t).find("item")).each(function (t, a) {
                    var s = {};
                    s.link = $(a).find("link").text(), s.title = $(a).find("title").text(), s.description = $(a).find("description").text();
                    var n = [];
                    $($(a).find("category")).each(function (e, t) {
                        n.push(t.innerHTML)
                    }), s.tags = n, e.push(s)
                })
            },
            error: function () {
                console.error("Failed to get search results")
            }
        })
    }), $("#search_form").submit(function (t) {
        t.preventDefault();
        for (var a = $("#search").val().toLowerCase(), s = "", n = 0, r = 0; r < e.length; r++) {
            var o = -1 != e[r].title.toLowerCase().search(a),
                i = -1 != e[r].description.toLowerCase().search(a),
                c = -1 != e[r].tags.indexOf(a);
            (o || i || c) && (n++, s += "<p><a href = '" + e[r].link + "'>" + e[r].title + "</a></p>")
        }
        0 == n && (s = "<p style = 'color:red'>No results found</p>"), setTimeout(function () {
            $("#search_results").html("<br>" + s)
        }, 200)
    });
    var t = $("link#theme-stylesheet");
    $("<link id='new-stylesheet' rel='stylesheet'>").insertAfter(t);
    var a = $("link#new-stylesheet");

    function s(e, t) {
        var a = $(e).height();
        $(t).css("min-height", a)
    }
    $.cookie("theme_csspath") && a.attr("href", $.cookie("theme_csspath")), $("#colour").change(function () {
        if ("" !== $(this).val()) {
            var e = "css/style." + $(this).val() + ".css";
            a.attr("href", e), $.cookie("theme_csspath", e, {
                expires: 365,
                path: document.URL.substr(0, document.URL.lastIndexOf("/"))
            })
        }
        return !1
    }), s(".featured-posts .text", ".featured-posts .image"), $(window).resize(function () {
        s(".featured-posts .text", ".featured-posts .image")
    }), $(".link-scroll").bind("click", function (e) {
        var t = $(this);
        $("html, body").stop().animate({
            scrollTop: $(t.attr("href")).offset().top + 2
        }, 700), e.preventDefault()
    }), $("[data-fancybox]").fancybox(), $(window).on("scroll", function () {
        var e = $(this).scrollTop();
        $(window).width() > 1250 ? $("section.divider").css({
            "background-position": "left -" + e / 8 + "px"
        }) : $("section.divider").css({
            "background-position": "center bottom"
        })
    }), $(".search-btn").on("click", function (e) {
        e.preventDefault(), $(".search-area").fadeIn(), $("#search").focus()
    }), $(".search-area .close-btn").on("click", function () {
        $(".search-area").fadeOut()
    }), $(".navbar-toggler").on("click", function () {
        $(".navbar-toggler").toggleClass("active")
    })
});