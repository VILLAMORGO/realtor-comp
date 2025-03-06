// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "@popperjs/core"
import "chartkick"
import "Chart.bundle"

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

/*----------  Messaging disappearing  ----------*/

// document.addEventListener("turbo:load", function() {
//   var conversationList = document.getElementById("conversation-list");
//   var messageContainer = document.getElementById("message-container");
//   var backButton = document.getElementById("back-button");
//   var conversationLinks = document.querySelectorAll(".conversation-item a");

//   if (conversationList && messageContainer && backButton) {
//     conversationLinks.forEach(function(link) {
//       link.addEventListener("click", function() {
//         if (window.innerWidth < 768) { // Apply only for small screens
//           setTimeout(function() {
//             var conversationList = document.getElementById("conversation-list");
//             var messageContainer = document.getElementById("message-container");
//             conversationList.classList.add("d-none");
//             messageContainer.classList.remove("d-none");
//             console.log("Remove from conversation list");
//           }, 500);
//           console.log("Trying to display");
//         }
//       });
//     });

//     backButton.addEventListener("click", function() {
//       if (window.innerWidth < 768) {
//         conversationList.classList.remove("d-none");
//         messageContainer.classList.add("d-none");
//       }
//     });
//   }
// });

document.addEventListener("turbo:load", function() {
  var conversationList = document.getElementById("conversation-list");
  var messageContainer = document.getElementById("message-container");
  var backButton = document.getElementById("back-button");
  var conversationLinks = document.querySelectorAll(".conversation-item a");

  if (conversationList && messageContainer && backButton) {
    conversationLinks.forEach(function(link) {
      link.addEventListener("click", function() {
        if (window.innerWidth < 768) { // Apply only for small screens
          setTimeout(function() {
            var conversationList = document.getElementById("conversation-list");
            var messageContainer = document.getElementById("message-container");

            // Apply fade-out transition
            conversationList.style.opacity = "0";
            conversationList.style.visibility = "hidden";

            setTimeout(function() {
              conversationList.classList.add("d-none"); // Hide after transition
              messageContainer.classList.remove("d-none");
              messageContainer.style.opacity = "0"; // Start invisible
              messageContainer.style.visibility = "visible";

              setTimeout(function() {
                messageContainer.style.opacity = "1"; // Fade in
              }, 100);
            }, 500);

            console.log("Remove from conversation list");
          }, 500);
        }
      });
    });

    backButton.addEventListener("click", function() {
      if (window.innerWidth < 768) {
        setTimeout(function() {
          messageContainer.style.opacity = "0"; // Fade out

          setTimeout(function() {
            messageContainer.classList.add("d-none");
            conversationList.classList.remove("d-none");
            conversationList.style.opacity = "0";
            conversationList.style.visibility = "visible";

            setTimeout(function() {
              conversationList.style.opacity = "1"; // Fade in
            }, 300);
          }, 800);
        }, 800);
      }
    });
  }
});


/*----------  Messaging disappearing End ----------*/


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

document.addEventListener('turbo:load', () => {
  const form = document.querySelector('.needs-validation');
  
  if (!form) return;

  const fields = form.querySelectorAll('input, select, textarea');

  fields.forEach(field => {
    field.addEventListener('input', () => validateField(field));
  });

  form.addEventListener('submit', (event) => {
    let valid = true;
    fields.forEach(field => {
      if (!validateField(field)) valid = false;
    });

    if (!valid) {
      event.preventDefault();
      event.stopPropagation();
    }
  });

  function validateField(field) {
    const validity = field.checkValidity();
    if (validity) {
      field.classList.remove('is-invalid');
      field.classList.add('is-valid');
      return true;
    } else {
      field.classList.remove('is-valid');
      field.classList.add('is-invalid');
      return false;
    }
  }
});