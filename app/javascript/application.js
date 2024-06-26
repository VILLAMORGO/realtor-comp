// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "@popperjs/core"

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('input[type=number]').forEach(function(input) {
      input.addEventListener('focus', function() {
        input.addEventListener('keydown', function(event) {
          if (event.keyCode === 38 || event.keyCode === 40) {
            event.preventDefault();
          }
        });
      });
    });
});

document.addEventListener("turbo:load", function() {
  var toggleButton = document.getElementById("toggle-optional-fields");
  var optionalFields = document.getElementById("optional-fields");

  if (toggleButton && optionalFields) {
    toggleButton.addEventListener("click", function() {
      if (optionalFields.classList.contains("hidden")) {
        optionalFields.classList.remove("hidden");
        optionalFields.classList.add("visible");
        toggleButton.textContent = "Hide Optional Fields";
      } else {
        optionalFields.classList.remove("visible");
        optionalFields.classList.add("hidden");
        toggleButton.textContent = "Show Optional Fields";
      }
    });
  }
  console.log("toggleButton.textContent");
});

document.addEventListener('turbo:load', function() {
  document.querySelectorAll('.btn-group-toggle .btn').forEach(function(button) {
    button.addEventListener('click', function() {
      document.querySelectorAll('.btn-group-toggle .btn').forEach(function(btn) {
        btn.classList.remove('active');
      });
      this.classList.add('active');
    });
  });
});
