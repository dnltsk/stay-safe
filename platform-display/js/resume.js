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

var second = 0,
	train = -1,
	markerPosition = 67, // percent
	platformNumber = 2,
	animationSpeed = 100, // milliseconds
	platformData = [],
	timetableData = [];

	$(document).ready(function() {
		$('.marker').css({
			marginLeft: markerPosition + 'vw'
		});

		loadPlatformData();
	});

	function loadPlatformData() {
		$.ajax({
			type: "GET",
			url: "https://raw.githubusercontent.com/dnltsk/stay-safe/master/platform-display/datas/platformdata.csv?v=2",
			dataType: "text",
			success: function(data) {
				platformData = processData(data);
				loadTimetableData();
			}
		 });
	}

	function loadTimetableData() {
		$.ajax({
			type: "GET",
			url: "https://raw.githubusercontent.com/dnltsk/stay-safe/master/platform-display/datas/timeTable.csv?v=3",
			dataType: "text",
			success: function(data) {
				timetableData = processData(data);

				second = 0;
				tick();

				animateTrainLeftMiddle();
			}
		 });
	}

	function processData(allText) {
		var allTextLines = allText.split(/\r\n|\n/);
		var headers = allTextLines[0].split(',');
		var lines = [];

		for (var i=1; i<allTextLines.length; i++) {
			var data = allTextLines[i].split(',');
			if (data.length == headers.length) {

				var tarr = [];
				for (var j=0; j<headers.length; j++) {
					tarr[headers[j]] = data[j];
				}
				lines.push(tarr);
			}
		}

		return lines;
	}

	function animateTrainLeftMiddle() {
		$('.train').animate({
			marginLeft: '2vw'
		}, 1000, function() {
			fillTrain();
		});
	}

	function animateTrainMiddleRight() {
		train = -1;

		$('.trainTime').html('');
		$('.trainDestination').html('');
		$('.trainLine').html('').removeClass().addClass('trainLine');

		coverTrain();

		$('.train').animate({
			marginLeft: '100vw'
		}, 1000, function() {
			$('.train').css({
				marginLeft: '-110vw'
			});
			animateTrainLeftMiddle();
		});
	}

	function getTimetableDatetime(ts) {
		var fix = ts.split(' ')[0].split('.');
		fix = fix[2] + '-' + fix[1] + '-' + fix[0] + 'T' + ts.split(' ')[1] + ':00+02:00';

		return fix;
	}

	function getTimetableTrain() {
		var now = new Date(platformData[second].timestamp);

		for (var i = 0; i < timetableData.length; ++i) {
			var ts = timetableData[i].timestamp;
			var dt = new Date(getTimetableDatetime(ts));

//			if ((dt >= now) && (platformNumber === platformData[second].platform)) {
			if ((dt >= now)) {
				return i;
			}
		}

		return 0;
	}

	function getPlatformSlot(slot) {
		switch (slot) {
		case 0:
			return platformData[second].b2;
		case 1:
			return platformData[second].c1;
		case 2:
			return platformData[second].c2;
		case 3:
			return platformData[second].d1;
		case 4:
			return platformData[second].d2;
		case 5:
			return platformData[second].e1;
		}
		return 0;
	}

	function getTimetableSlot(slot) {
		switch (slot) {
		case 0:
			return timetableData[train].car1;
		case 1:
			return timetableData[train].car2;
		case 2:
			return timetableData[train].car3;
		case 3:
			return timetableData[train].car4;
		case 4:
			return timetableData[train].car5;
		case 5:
			return timetableData[train].car6;
		}
		return 0;
	}

	function tick() {
		var index, slot, color;

		for (var i = 0; i < 6; ++i) {
			index = 0;
			color = '';
			slot = getPlatformSlot(i);

			if (slot > 15) {
				index = 4;
				color = 'red';
			} else if (slot > 10) {
				index = 3;
				color = 'yellow';
			} else if (slot > 5) {
				index = 2;
			} else if (slot > 0) {
				index = 1;
			}

			$('.resume-section .row div:nth-child(' + (i + 1) + ') .platform').removeClass().addClass('platform').addClass(color);
			$('.resume-section .row div:nth-child(' + (i + 1) + ') .platform div').removeClass().addClass('fill' + index);
		}

		++second;
		if (second >= (60 * 60 - 1)) {
			second = 0;
		}

		var currentTrain = getTimetableTrain();
		if ((train !== -1) && (train !== currentTrain)) {
			animateTrainMiddleRight();
		}

		setTimeout(tick, animationSpeed);
	}

	function coverTrain() {
		for (var i = 0; i < 6; ++i) {
			$('.resume-section .train .car:nth-child(' + (i + 1) + ')').removeClass().addClass('car');
		}
	}

	function fillTrain() {
		var index, slot, data;

		train = getTimetableTrain();
		data = timetableData[train];

		var dt = new Date(getTimetableDatetime(timetableData[train].timestamp));

		$('.trainTime').html(dt.getHours() + '.' + ('0' + dt.getMinutes()).slice(-2));
		$('.trainDestination').html(timetableData[train].destination);
		$('.trainLine').html(timetableData[train].line).removeClass().addClass('trainLine').addClass(timetableData[train].line);

		for (var i = 0; i < 6; ++i) {
			index = 0;
			slot = getTimetableSlot(i);

			if (slot > 100) {
				index = 3;
			} else if (slot > 50) {
				index = 2;
			} else if (slot > 0) {
				index = 1;
			}

			$('.resume-section .train .car:nth-child(' + (i + 1) + ')').removeClass().addClass('car').addClass('car' + index);
		}
	}
})(jQuery); // End of use strict
