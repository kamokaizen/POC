! function ($) {
    "use strict";

    var Sidemenu = function () {
        this.$body = $("body"),
            this.$openLeftBtn = $(".open-left"),
            this.$menuItem = $("#sidebar-menu a")
    };
    Sidemenu.prototype.openLeftBar = function () {
        $("#wrapper").toggleClass("enlarged");
        $("#wrapper").addClass("forced");
                
        
        if ($("#wrapper").hasClass("enlarged") && $("body").hasClass("fixed-left")) {
            $("body").removeClass("fixed-left").addClass("fixed-left-void");
        } else if (!$("#wrapper").hasClass("enlarged") && $("body").hasClass("fixed-left-void")) {
            $("body").removeClass("fixed-left-void").addClass("fixed-left");
        }

        if ($("#wrapper").hasClass("enlarged")) {
            $(".left ul").removeAttr("style");
        } else {
            $(".subdrop").siblings("ul:first").show();
        }

        toggle_slimscroll(".slimscrollleft");
        $("body").trigger("resize");
    },
        //menu item click

        Sidemenu.prototype.menuItemClick = function (e) {
            if (!$("#wrapper").hasClass("enlarged")) {


                if ($(this).parent().hasClass("has_sub")) {
                    //main link
                    $(this).parent().find('ul').slideToggle(300);
                    $(this).toggleClass('subdrop');

                } else if (!$(this).parent().hasClass("has_sub")) {
                    //inner link
                    $("#sidebar-menu .list-unstyled").not($(this).parent().parent()).unbind().slideUp(300);
                    $("#sidebar-menu ul li.has_sub li").not($(this)).removeClass('active subdrop');
                    $("#sidebar-menu ul li a").not($(this)).removeClass('active subdrop');

                    $(this).parent().addClass('active');
                    $(this).parent().parent().parent().find('>a').addClass('active');
                    
                    //scroll top
                    $("html, body").animate({ scrollTop: 0 }, "slow");
                    
                }
                


                /*
                if (!$(this).hasClass("subdrop")) {
                    $("#sidebar-menu ul li.has_sub a.active").not($(this)).removeClass('active');
                    $("#sidebar-menu ul li li").not($(this).parent().find('li')).removeClass('active');

                    $("ul", $(this).parents("ul:first")).slideUp(350);
                    $("a", $(this).parents("ul:first")).removeClass("subdrop");
                    $("#sidebar-menu .pull-right i").removeClass("zmdi-chevron-down").addClass("zmdi-chevron-right");

                    $(this).next("ul").slideDown(350);
                    $(this).addClass("subdrop");

                    $(".drop-arrow i", $(this).parents(".has_sub:first")).removeClass("zmdi-chevron-right").addClass("zmdi-chevron-down");
                    $(".drop-arrow i", $(this).siblings("ul")).removeClass("zmdi-chevron-down").addClass("zmdi-chevron-right");

                } else if ($(this).hasClass("subdrop")) {
                    $(this).removeClass("subdrop");
                    $(this).next("ul").slideUp(350);
                    $(".drop-arrow i", $(this).parent()).removeClass("zmdi-chevron-down").addClass("zmdi-chevron-right");
                }
                */
            }
        },

        //init sidemenu
        Sidemenu.prototype.init = function () {
            var $this = this;

            var ua = navigator.userAgent,
                event = (ua.match(/iP/i)) ? "touchstart" : "click";

            //bind on click
            this.$openLeftBtn.on(event, function (e) {
                e.stopPropagation();
                $this.openLeftBar();
                
                //nav icon changed
                var icon = $(this).find('i');
                icon.toggleClass('zmdi-close');                

            });

            // LEFT SIDE MAIN NAVIGATION
            $this.$menuItem.on(event, $this.menuItemClick);

            // NAVIGATION HIGHLIGHT & OPEN PARENT
            $("#sidebar-menu ul li.has_sub .active").trigger("click");
        },

        //init Sidemenu
        $.Sidemenu = new Sidemenu, $.Sidemenu.Constructor = Sidemenu

} (window.jQuery),


    function ($) {
        "use strict";

        var FullScreen = function () {
            this.$body = $("body"),
                this.$fullscreenBtn = $("#btn-fullscreen")
        };

        //turn on full screen
        // Thanks to http://davidwalsh.name/fullscreen
        FullScreen.prototype.launchFullscreen = function (element) {
            if (element.requestFullscreen) {
                element.requestFullscreen();
            } else if (element.mozRequestFullScreen) {
                element.mozRequestFullScreen();
            } else if (element.webkitRequestFullscreen) {
                element.webkitRequestFullscreen();
            } else if (element.msRequestFullscreen) {
                element.msRequestFullscreen();
            }
        },
            FullScreen.prototype.exitFullscreen = function () {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                } else if (document.mozCancelFullScreen) {
                    document.mozCancelFullScreen();
                } else if (document.webkitExitFullscreen) {
                    document.webkitExitFullscreen();
                }
            },
            //toggle screen
            FullScreen.prototype.toggle_fullscreen = function () {
                var $this = this;
                var fullscreenEnabled = document.fullscreenEnabled || document.mozFullScreenEnabled || document.webkitFullscreenEnabled;
                if (fullscreenEnabled) {
                    if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {
                        $this.launchFullscreen(document.documentElement);
                    } else {
                        $this.exitFullscreen();
                    }
                }
            },
            //init sidemenu
            FullScreen.prototype.init = function () {
                var $this = this;
                //bind
                $this.$fullscreenBtn.on('click', function () {
                    $this.toggle_fullscreen();
                });
            },
            //init FullScreen
            $.FullScreen = new FullScreen, $.FullScreen.Constructor = FullScreen

    } (window.jQuery),

    //main app module
    function ($) {
        "use strict";

        var App = function () {
            this.VERSION = "1.0",
                this.AUTHOR = "Comodo",
                this.SUPPORT = "",
                this.pageScrollElement = "html, body",
                this.$body = $("body")
        };

        //on doc load
        App.prototype.onDocReady = function (e) {
            FastClick.attach(document.body);
            resizefunc.push("initscrolls");
            resizefunc.push("changeptype");

            $('.animate-number').each(function () {
                $(this).animateNumbers($(this).attr("data-value"), true, parseInt($(this).attr("data-duration")));
            });

            //RUN RESIZE ITEMS
            $(window).resize(debounce(resizeitems, 100));
            $("body").trigger("resize");

            // right side-bar toggle
            $('.right-bar-toggle').on('click', function (e) {

                $('#wrapper').toggleClass('right-bar-enabled');
            });


        },
            //initilizing 
            App.prototype.init = function () {
                var $this = this;
                //document load initialization
                $(document).ready($this.onDocReady);
                //init side bar - left
                $.Sidemenu.init();
                //init fullscreen
                $.FullScreen.init();
            },

            $.App = new App, $.App.Constructor = App

    } (window.jQuery),

    //initializing main application module
    function ($) {
        "use strict";
        $.App.init();
    } (window.jQuery);



/* ------------ some utility functions ----------------------- */
//this full screen
var toggle_fullscreen = function () {

}

function executeFunctionByName(functionName, context /*, args */) {
    var args = [].slice.call(arguments).splice(2);
    var namespaces = functionName.split(".");
    var func = namespaces.pop();
    for (var i = 0; i < namespaces.length; i++) {
        context = context[namespaces[i]];
    }
    return context[func].apply(this, args);
}
var w, h, dw, dh;
var changeptype = function () {
    w = $(window).width();
    h = $(window).height();
    dw = $(document).width();
    dh = $(document).height();

    if (jQuery.browser.mobile === true) {
        $("body").addClass("mobile").removeClass("fixed-left");
    }

    if (!$("#wrapper").hasClass("forced")) {
        if (w > 990) {
            $("body").removeClass("smallscreen").addClass("widescreen");
            $("#wrapper").removeClass("enlarged");
        } else {
            $("body").removeClass("widescreen").addClass("smallscreen");
            $("#wrapper").addClass("enlarged");
            $(".left ul").removeAttr("style");
        }
        if ($("#wrapper").hasClass("enlarged") && $("body").hasClass("fixed-left")) {
            $("body").removeClass("fixed-left").addClass("fixed-left-void");
        } else if (!$("#wrapper").hasClass("enlarged") && $("body").hasClass("fixed-left-void")) {
            $("body").removeClass("fixed-left-void").addClass("fixed-left");
        }

    }
    toggle_slimscroll(".slimscrollleft");
}


var debounce = function (func, wait, immediate) {
    var timeout, result;
    return function () {
        var context = this,
            args = arguments;
        var later = function () {
            timeout = null;
            if (!immediate) result = func.apply(context, args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) result = func.apply(context, args);
        return result;
    };
}

function resizeitems() {
    if ($.isArray(resizefunc)) {
        for (i = 0; i < resizefunc.length; i++) {
            window[resizefunc[i]]();
        }
    }
}

function initscrolls() {
    if (jQuery.browser.mobile !== true) {
        //SLIM SCROLL
        $('.slimscroller').slimscroll({
            height: 'auto',
            size: "5px"
        });

        $('.slimscrollleft').slimScroll({
            height: 'auto',
            position: 'right',
            size: "5px",
            color: '#98a6ad',
            wheelStep: 5
        });
    }
}

function toggle_slimscroll(item) {
    if ($("#wrapper").hasClass("enlarged")) {
        $(item).css("overflow", "inherit").parent().css("overflow", "inherit");
        $(item).siblings(".slimScrollBar").css("visibility", "hidden");
    } else {
        $(item).css("overflow", "hidden").parent().css("overflow", "hidden");
        $(item).siblings(".slimScrollBar").css("visibility", "visible");
    }
}

// counter
function cardViewCounter() {
    $(".counter").each(function (i, el) {
        var $this = $(el),

            start = attrDefault($this, 'start', 0),
            end = attrDefault($this, 'end', 0),
            prefix = attrDefault($this, 'prefix', ''),
            postfix = attrDefault($this, 'postfix', ''),
            duration = attrDefault($this, 'duration', 1000),
            delay = attrDefault($this, 'delay', 1000),
            format = attrDefault($this, 'format', false);


        var o = { curr: start };

        TweenLite.to(o, duration / 1000, {
            curr: end,
            ease: Power1.easeInOut,
            delay: delay / 1000,
            onUpdate: function () {
                $this.html(prefix + (format ? numberWithCommas(Math.round(o.curr)) : Math.round(o.curr)) + postfix);
            }
        });
    });
}

// Element Attribute Helper
function attrDefault($el, data_var, default_val) {
    if (typeof $el.data(data_var) != 'undefined') {
        return $el.data(data_var);
    }
    return default_val;
}


function overviewSticky() {
    if ($('.sticky-level-list').length) {
        var s = $(".sticky-level-list");
        var pos = s.position();
        $(window).scroll(function () {
            var windowpos = $(window).scrollTop();

            if (windowpos >= pos.top) {
                s.addClass("stick");
                $('.overview-charts').css('margin-top', '72px');
            } else {
                s.removeClass("stick");
                $('.overview-charts').css('margin-top', '0');
            }
        });
    }
}

$(document).ready(function () {
    overviewSticky();
    $.fn.modal.prototype.constructor.Constructor.DEFAULTS.backdrop = 'static';

});