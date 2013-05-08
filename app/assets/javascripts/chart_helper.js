var ChartHelper = {};
ChartHelper.create = function(element, type, title, seriesData, startDate, yearRange, pointInterval, statType) {
  var percentSuffix = '';
  if(statType == 'percent')
    percentSuffix = '%';

  return new Highcharts.Chart({
      chart: {
          renderTo: element,
          type: type,
          marginRight: 20
      },
      legend: {
        backgroundColor: "#ffffff",
        borderColor: "#cccccc"
      },
      credits: { 
        enabled: false 
      },
      title: title,
      xAxis: {
          type: 'datetime',
          labels: {
            formatter: function() { 
              if (yearRange != '')
                return yearRange;
              else
                return Highcharts.dateFormat('%Y', this.value); 
            }
          }
      },
      yAxis: {
          title: null,
          min: 0,
          labels: {
            formatter: function() { return this.value + percentSuffix; }
          },
      },
      plotOptions: {
        series: {
          marker: {
            radius: 0,
            states: {
              hover: {
                enabled: true,
                radius: 5
              }
            }
          },
          pointInterval: ChartHelper.pointInterval(pointInterval),  
          pointStart: startDate,
          shadow: false
        }
      },
      tooltip: {
          borderColor: "#ccc",
          formatter: function() {
            var s = "<strong>" + ChartHelper.toolTipDateFormat(pointInterval, this.x) + "</strong>";
            $.each(this.points, function(i, point) {
              if (point.point.low != null && point.point.high != null)
                s += "<br /><span style=\"color: " + point.series.color + "\">" + point.series.name + ":</span> " + point.point.low + percentSuffix + " - " + point.point.high + percentSuffix;
              else
                s += "<br /><span style=\"color: " + point.series.color + "\">" + point.series.name + ":</span> " + point.y + percentSuffix;
            });
            return s;
          },
          shared: true
      },
      series: seriesData
    });
  }

ChartHelper.createPie = function(element, pieData, sliceTitle) {
  return new Highcharts.Chart({
      chart: {
          renderTo: element,
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false
      },
      credits: { 
        enabled: false 
      },
      title: {
          text: null
      },
      tooltip: {
          pointFormat: '{series.name}: <b>{point.percentage}%</b>',
          percentageDecimals: 1
      },
      plotOptions: {
          pie: {
              allowPointSelect: true,
              cursor: 'pointer',
              dataLabels: {
                  enabled: true,
                  color: '#000000',
                  connectorColor: '#000000',
                  formatter: function() {
                      return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
                  }
              }
          }
      },
      series: [{
          type: 'pie',
          name: sliceTitle,
          data: pieData
      }]
  });
}

ChartHelper.pointInterval = function(interval) {
  if (interval == "year")
    return 365 * 24 * 3600 * 1000;
  if (interval == "quarter")
    return 3 * 30.4 * 24 * 3600 * 1000;
  if (interval == "month") //this is very hacky. months have different day counts, so our point interval is the average - 30.4
    return 30.4 * 24 * 3600 * 1000;
  if (interval == "week")
    return 7 * 24 * 3600 * 1000;
  if (interval == "day")
    return 24 * 3600 * 1000;
  if (interval == "hour")
    return 3600 * 1000;
  else
    return 1;
}

ChartHelper.toolTipDateFormat = function(interval, x) {
  if (interval == "year")
    return Highcharts.dateFormat("%Y", x);
  if (interval == "quarter")
    return Highcharts.dateFormat("%B %Y", x);
  if (interval == "month")
    return Highcharts.dateFormat("%B %Y", x);
  if (interval == "week")
    return Highcharts.dateFormat("%e %b %Y", x);
  if (interval == "day")
    return Highcharts.dateFormat("%e %b %Y", x);
  if (interval == "hour")
    return Highcharts.dateFormat("%H:00", x);
  else
    return 1;
}