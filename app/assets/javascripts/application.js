// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .

document.addEventListener("turbolinks:load", function() {
  // いいねボタンの処理
  document.querySelectorAll('.like-button').forEach(function(button) {
    button.addEventListener('click', function(e) {
      e.preventDefault();
      var form = this.closest('form');
      var url = form.action;
      var method = form.querySelector('input[name="_method"]') ? 
                   form.querySelector('input[name="_method"]').value : form.method;
      
      fetch(url, {
        method: method.toUpperCase(),
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        if (data.liked) {
          button.classList.add('liked');
        } else {
          button.classList.remove('liked');
        }
        var countEl = button.querySelector('.like-count');
        if (countEl) {
          countEl.textContent = data.likes_count;
        }
      });
    });
  });
});
