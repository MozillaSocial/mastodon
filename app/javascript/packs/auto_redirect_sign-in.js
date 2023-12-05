import ready from '../mastodon/ready';

ready(() => {
  const form = document.querySelector('#sso_form')
  form.insertAdjacentHTML('beforeend', '<h4>Redirecting...</h4>')
  form.elements.commit.style.setProperty('visibility', 'hidden')
  form.elements.intent.value = localStorage.getItem('mozsoc.auth_intent')
  localStorage.removeItem('mozsoc.auth_intent');
  form.submit();
});
