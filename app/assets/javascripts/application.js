// OshiConnect JavaScript
document.addEventListener("DOMContentLoaded", function() {
  // いいねボタンの処理
  document.querySelectorAll('.like-button').forEach(function(button) {
    button.addEventListener('click', function(e) {
      e.preventDefault();
      var form = this.closest('form');
      if (!form) return;
      
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
