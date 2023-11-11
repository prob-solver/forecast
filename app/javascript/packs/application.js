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
import 'moment'
import 'chartjs-adapter-moment'
import maplibregl from 'maplibre-gl'
//import 'maplibre-gl/dist/maplibre-gl.css';


function getForecastData(location_id) {
  return $.get(`/api/v1/locations/${location_id}/forecasts`)
}

async function renderForecastInfo(location) {
  const forecast = await getForecastData(location.id);

  renderForecastHead(forecast);
  renderChart(forecast);
}

function renderForecastHead() {
  $('#forecast-container').append()
}

function renderChart(forecast) {
  const data = forecast.data.timelines.hourly.map(function(hourly_data) {
    return {
      "hour": new Date(hourly_data.time),
      "temperature": hourly_data.values.temperature
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
            label: '5 Days temperature',
            data: data.map(row => row.temperature)
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
                'hour': 'dddd HH',
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
