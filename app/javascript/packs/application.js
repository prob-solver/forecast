// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'css/site'

require('jquery')

Rails.start()
Turbolinks.start()
ActiveStorage.start()


import Chart from 'chart.js/auto'
import moment from 'moment'
import 'chartjs-adapter-moment'
import maplibregl from 'maplibre-gl'
import Mustache from 'mustache'


const weatherCodeDay = {
  "0": "Unknown",
  "1000": "Clear",
  "1100": "Mostly Clear",
  "1101": "Partly Cloudy",
  "1102": "Mostly Cloudy",
  "1001": "Cloudy",
  "1103": "Partly Cloudy and Mostly Clear",
  "2100": "Light Fog",
  "2101": "Mostly Clear and Light Fog",
  "2102": "Partly Cloudy and Light Fog",
  "2103": "Mostly Cloudy and Light Fog",
  "2106": "Mostly Clear and Fog",
  "2107": "Partly Cloudy and Fog",
  "2108": "Mostly Cloudy and Fog",
  "2000": "Fog",
  "4204": "Partly Cloudy and Drizzle",
  "4203": "Mostly Clear and Drizzle",
  "4205": "Mostly Cloudy and Drizzle",
  "4000": "Drizzle",
  "4200": "Light Rain",
  "4213": "Mostly Clear and Light Rain",
  "4214": "Partly Cloudy and Light Rain",
  "4215": "Mostly Cloudy and Light Rain",
  "4209": "Mostly Clear and Rain",
  "4208": "Partly Cloudy and Rain",
  "4210": "Mostly Cloudy and Rain",
  "4001": "Rain",
  "4211": "Mostly Clear and Heavy Rain",
  "4202": "Partly Cloudy and Heavy Rain",
  "4212": "Mostly Cloudy and Heavy Rain",
  "4201": "Heavy Rain",
  "5115": "Mostly Clear and Flurries",
  "5116": "Partly Cloudy and Flurries",
  "5117": "Mostly Cloudy and Flurries",
  "5001": "Flurries",
  "5100": "Light Snow",
  "5102": "Mostly Clear and Light Snow",
  "5103": "Partly Cloudy and Light Snow",
  "5104": "Mostly Cloudy and Light Snow",
  "5122": "Drizzle and Light Snow",
  "5105": "Mostly Clear and Snow",
  "5106": "Partly Cloudy and Snow",
  "5107": "Mostly Cloudy and Snow",
  "5000": "Snow",
  "5101": "Heavy Snow",
  "5119": "Mostly Clear and Heavy Snow",
  "5120": "Partly Cloudy and Heavy Snow",
  "5121": "Mostly Cloudy and Heavy Snow",
  "5110": "Drizzle and Snow",
  "5108": "Rain and Snow",
  "5114": "Snow and Freezing Rain",
  "5112": "Snow and Ice Pellets",
  "6000": "Freezing Drizzle",
  "6003": "Mostly Clear and Freezing drizzle",
  "6002": "Partly Cloudy and Freezing drizzle",
  "6004": "Mostly Cloudy and Freezing drizzle",
  "6204": "Drizzle and Freezing Drizzle",
  "6206": "Light Rain and Freezing Drizzle",
  "6205": "Mostly Clear and Light Freezing Rain",
  "6203": "Partly Cloudy and Light Freezing Rain",
  "6209": "Mostly Cloudy and Light Freezing Rain",
  "6200": "Light Freezing Rain",
  "6213": "Mostly Clear and Freezing Rain",
  "6214": "Partly Cloudy and Freezing Rain",
  "6215": "Mostly Cloudy and Freezing Rain",
  "6001": "Freezing Rain",
  "6212": "Drizzle and Freezing Rain",
  "6220": "Light Rain and Freezing Rain",
  "6222": "Rain and Freezing Rain",
  "6207": "Mostly Clear and Heavy Freezing Rain",
  "6202": "Partly Cloudy and Heavy Freezing Rain",
  "6208": "Mostly Cloudy and Heavy Freezing Rain",
  "6201": "Heavy Freezing Rain",
  "7110": "Mostly Clear and Light Ice Pellets",
  "7111": "Partly Cloudy and Light Ice Pellets",
  "7112": "Mostly Cloudy and Light Ice Pellets",
  "7102": "Light Ice Pellets",
  "7108": "Mostly Clear and Ice Pellets",
  "7107": "Partly Cloudy and Ice Pellets",
  "7109": "Mostly Cloudy and Ice Pellets",
  "7000": "Ice Pellets",
  "7105": "Drizzle and Ice Pellets",
  "7106": "Freezing Rain and Ice Pellets",
  "7115": "Light Rain and Ice Pellets",
  "7117": "Rain and Ice Pellets",
  "7103": "Freezing Rain and Heavy Ice Pellets",
  "7113": "Mostly Clear and Heavy Ice Pellets",
  "7114": "Partly Cloudy and Heavy Ice Pellets",
  "7116": "Mostly Cloudy and Heavy Ice Pellets",
  "7101": "Heavy Ice Pellets",
  "8001": "Mostly Clear and Thunderstorm",
  "8003": "Partly Cloudy and Thunderstorm",
  "8002": "Mostly Cloudy and Thunderstorm",
  "8000": "Thunderstorm"
}

function getForecastData(location_id) {
  return $.get(`/api/v1/locations/${location_id}/forecasts`).fail(function() {
    alert('do not support forecast weather for this address')
  });
}

function getLocation(location_id) {
  return $.get(`/api/v1/locations/${location_id}`)
}

async function renderForecast(location) {
  const forecast = await getForecastData(location.id);

  renderForecastHead(forecast);
  renderChart(forecast);
}

function renderForecastHead(forecast) {
  let template = $('#forecast-info-template').html();
  console.log(forecast.data.timelines)
  const rendered = Mustache.render(
    template,
    {
      forecast: forecast.data,
      formatDate: function() {
        return function (date, render) {
          return moment(render(date)).format('ddd D');
        }
      },
      mathRound: function() {
        return function (number, render) {
          return Math.round(render(number))
        }
      },
      currentWeather: weatherCodeDay[forecast.data.timelines.minutely[0].values.weatherCode],
      weatherIcon: function() {
        return function(code, render) {
          console.log(render(code))

          const weather_name = weatherCodeDay[render(code)].replaceAll(" ", "_").toLowerCase();
          return $("<img/>").attr("src", `/assets/weather_codes/png/${render(code)}0_${weather_name}_small.png`).attr("alt", weather_name).prop('outerHTML');;
        }
      },
      current_weather: forecast.data.timelines.minutely[0].values,
      fetch_from: forecast.fetch_from,
      postal_code: forecast.postal_code
    }
  )
  $("#forecast-container").html(rendered);
}

function renderChart(forecast) {
  const data = forecast.data.timelines.hourly.map(function(hourly_data) {
    return {
      "hour": new Date(hourly_data.time),
      "temperature": hourly_data.values.temperature,
      "temperatureApparent": hourly_data.values.temperatureApparent,
      "precipitationProbability": hourly_data.values.precipitationProbability
    }
  });

  const ctx = document.getElementById('chart-container').getContext('2d')

  let chart = Chart.getChart("chart-container");
  if (chart != undefined) {
    chart.destroy()
  }

  new Chart(
    ctx,
    {
      type: 'line',
      data: {
        labels: data.map(row => row.hour),
        datasets: [
          {
            label: 'Temperature',
            data: data.map(row => row.temperature),
            borderColor: 'rgb(255, 99, 132)'
          },
          {
            label: 'Feels like',
            data: data.map(row => row.temperatureApparent),
            borderColor: 'rgb(153, 102, 255)'
          },
          {
            label: "Precipiation",
            data: data.map(row => row.precipitationProbability),
            fill: 'origin',
            borderColor: 'rgb(54, 162, 235)', //blue
            backgroundColor: 'rgb(54, 162, 235)'
          }
        ]
      },
      options: {
        scales: {
          x: {
            type: "time",
            time: {
              format: "DD.MM.YYYY HH:mm",
              unit: "hour",
              displayFormats: {
                'hour': 'ddd ha',
                'day': 'dddd',
                'week': 'DD.MM',
                'month': 'DD.MM',
                'year': 'MMMM',
              },
            },
          },
        },
      }
    }
  );
};



window.renderChart = renderChart;
window.renderForecast = renderForecast;
window.getLocation = getLocation;