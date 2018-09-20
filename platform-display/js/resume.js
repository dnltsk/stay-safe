(function($) {
  "use strict"; // Start of use strict

  // Smooth scrolling using jQuery easing
  $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: (target.offset().top)
        }, 1000, "easeInOutExpo");
        return false;
      }
    }
  });

  // Closes responsive menu when a scroll trigger link is clicked
  $('.js-scroll-trigger').click(function() {
    $('.navbar-collapse').collapse('hide');
  });

  // Activate scrollspy to add active class to navbar items on scroll
  $('body').scrollspy({
    target: '#sideNav'
  });

$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "https://raw.githubusercontent.com/dnltsk/stay-safe/master/platform-display/datas/platformdata.csv?v=1",
        dataType: "text",
        success: function(data) {processData(data);}
     });
});

var minute = 0,
	platformData = [];

function processData(allText) {
    var allTextLines = allText.split(/\r\n|\n/);
    var headers = allTextLines[0].split(',');
    var lines = [];

    for (var i=1; i<allTextLines.length; i++) {
        var data = allTextLines[i].split(',');
        if (data.length == headers.length) {

            var tarr = [];
            for (var j=0; j<headers.length; j++) {
//                tarr.push(headers[j]+":"+data[j]);
                tarr[headers[j]] = data[j];
            }
            lines.push(tarr);
        }
    }

	minute = 0;
	platformData = lines;
	tick();
	animateTrainLeftMiddle();
}

	function animateTrainLeftMiddle() {
		$('.train').animate({
			marginLeft: '2vw'
		}, 1000);
	}

	function getPlatformSlot(slot) {
		switch (slot) {
		case 0:
			return platformData[minute].b2;
		case 1:
			return platformData[minute].c1;
		case 2:
			return platformData[minute].c2;
		case 3:
			return platformData[minute].d1;
		case 4:
			return platformData[minute].d2;
		case 5:
			return platformData[minute].e1;
		}
		return 0;
	}

	function tick() {
		var index, slot;

		for (var i = 0; i < 6; ++i) {
			index = 0;
			slot = getPlatformSlot(i);

			if (slot > 600) {
				index = 4;
			} else if (slot > 400) {
				index = 3;
			} else if (slot > 200) {
				index = 2;
			} else if (slot > 0) {
				index = 1;
			}

			$('.resume-section .row div:nth-child(' + (i + 1) + ') .platform div').removeClass().addClass('fill' + index);
		}

		++minute;
		if (minute >= 59) {
			minute = 0;
		}
		setTimeout(tick, 100);
	}

})(jQuery); // End of use strict
