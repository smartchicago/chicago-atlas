var ChartHelper = {};
ChartHelper.create = function(element, type, seriesData, startDate, yearRange, pointInterval, statType, categories) {
  var percentSuffix = '';
  if(statType == 'percent')
    percentSuffix = '%';

  var area_config = {};
  if (type == 'area')
    area_config = { stacking: 'normal' };

  var xaxis_config = {
                      type: 'datetime',
                      labels: {
                        formatter: function() { 
                          if (yearRange != '')
                            return yearRange;
                          else
                            return Highcharts.dateFormat('%Y', this.value); 
                        }
                      }
                    };

  var pointInterval_config = ChartHelper.pointInterval(pointInterval);
  var pointStart = startDate;

  if (typeof categories !== "undefined") {
    xaxis_config = { categories: categories };
    pointInterval_config = null;
    pointStart = null;
  }

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
    title: "",
    xAxis: xaxis_config,
    yAxis: {
        title: null,
        min: 0,
        labels: {
          formatter: function() { return ChartHelper.formatNumber(this.value) + percentSuffix; }
        },
    },
    plotOptions: {
      area: area_config,
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
        pointInterval: pointInterval_config,  
        pointStart: pointStart,
        shadow: false
      }
    },
    tooltip: {
        borderColor: "#ccc",
        formatter: function() {
          var s = "<strong>" + ChartHelper.toolTipDateFormat(pointInterval, this.x) + "</strong>";
          if (typeof categories !== "undefined")
            s = "<strong>" + this.x + "</strong>";
          $.each(this.points, function(i, point) {
            if (point.point.low != null && point.point.high != null && point.point.low != 0 && point.point.high != 0)
              s += "<br /><span style=\"color: " + point.series.color + "\">" + point.series.name + ":</span> " + point.point.low + percentSuffix + " - " + point.point.high + percentSuffix;
            else
              s += "<br /><span style=\"color: " + point.series.color + "\">" + point.series.name + ":</span> " + Highcharts.numberFormat(point.y, 0) + percentSuffix;
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
          pointFormat: '{series.name}: <b>{point.y}</b>',
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
                      return '<b>'+ this.point.name +'</b>: '+ this.y;
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
  if (interval == "decade")
    return 10 * 365 * 24 * 3600 * 1000;
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
  if (interval == "decade")
    return Highcharts.dateFormat("%Y", x);
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

ChartHelper.formatNumber = function(value) {
  if (value >= 1000000000)
    return value / 1000000000 + "B";
  else if (value >= 1000000)
    return value / 1000000 + "M";
  else if (value >= 1000)
    return value / 1000 + "K";
  else
    return value;
}