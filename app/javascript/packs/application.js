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


function getForecastData(location_id) {
  return $.get(`/api/v1/locations/${location_id}/forecasts`).fail(function() {
    alert('do not support forecast weather for this address')
  });
}

async function renderForecastInfo(location) {
  const forecast = await getForecastData(location.id);

  renderForecastHead(forecast);
  renderChart(forecast);
}

function renderForecastHead(forecast) {
  let template = $('#forecast-info-template').html();

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
window.renderForecastInfo = renderForecastInfo;