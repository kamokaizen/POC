var resizefunc = [];
//portlets
! function($) {
    "use strict";

    /**
    Portlet Widget
    */
    var Portlet = function() {
        this.$body = $("body"),
            this.$portletIdentifier = ".portlet",
            this.$portletCloser = '.portlet a[data-toggle="remove"]',
            this.$portletRefresher = '.portlet a[data-toggle="reload"]'
    };

    //on init
    Portlet.prototype.init = function() {
            // Panel closest
            var $this = this;
            $(document).on("click", this.$portletCloser, function(ev) {
                ev.preventDefault();
                var $portlet = $(this).closest($this.$portletIdentifier);
                var $portlet_parent = $portlet.parent();
                $portlet.remove();
                if ($portlet_parent.children().length == 0) {
                    $portlet_parent.remove();
                }
            });

            // Panel Reload
            $(document).on("click", this.$portletRefresher, function(ev) {
                ev.preventDefault();
                var $portlet = $(this).closest($this.$portletIdentifier);
                // This is just a simulation, nothing is going to be reloaded
                $portlet.append('<div class="panel-disabled"><div class="loader-1"></div></div>');
                var $pd = $portlet.find('.panel-disabled');
                setTimeout(function() {
                    $pd.fadeOut('fast', function() {
                        $pd.remove();
                    });
                }, 500 + 300 * (Math.random() * 5));
            });
        },
        //
        $.Portlet = new Portlet, $.Portlet.Constructor = Portlet

}(window.jQuery),
/**
 * Components
 */
function($) {
    "use strict";

    var Components = function() {};

    //initializing tooltip
    Components.prototype.initTooltipPlugin = function() {
            $.fn.tooltip && $('[data-toggle="tooltip"]').tooltip()
        },
        //initializing tooltip
        Components.prototype.initSelect2 = function() {
            if ($(".select2").length) {
                $(".select2").select2();

                $(".select2-limiting").select2({
                    maximumSelectionLength: 2
                });
            }
        },

        //initializing popover
        Components.prototype.initPopoverPlugin = function() {
            $.fn.popover && $('[data-toggle="popover"]').popover()
        },

        //initializing custom modal
        Components.prototype.initCustomModalPlugin = function() {
            $('[data-plugin="custommodal"]').on('click', function(e) {
                Custombox.open({
                    target: $(this).attr("href"),
                    effect: $(this).attr("data-animation"),
                    overlaySpeed: $(this).attr("data-overlaySpeed"),
                    overlayColor: $(this).attr("data-overlayColor"),
                    overlayOpacity: $(this).attr("data-overlayOpacity")
                });
                e.preventDefault();
            });
        },

        //initializing nicescroll
        Components.prototype.initNiceScrollPlugin = function() {
            //You can change the color of scroll bar here
            $.fn.niceScroll && $(".nicescroll").niceScroll({ cursorcolor: '#98a6ad', cursorwidth: '6px', cursorborderradius: '5px' });
        },

        //range slider
        Components.prototype.initRangeSlider = function() {
            $.fn.slider && $('[data-plugin="range-slider"]').slider({});
        },


        //initilizing
        Components.prototype.init = function() {
            var $this = this;
            this.initTooltipPlugin(),
                this.initSelect2(),
                this.initPopoverPlugin(),
                this.initNiceScrollPlugin(),
                this.initCustomModalPlugin(),
                this.initRangeSlider(),
                $.Portlet.init();
        },

        $.Components = new Components, $.Components.Constructor = Components

}(window.jQuery),
//initializing main application module
function($) {
    "use strict";
    $.Components.init();
}(window.jQuery);
