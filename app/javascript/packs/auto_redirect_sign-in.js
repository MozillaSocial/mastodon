import { sso_redirect } from '../mastodon/initial_state';
import ready from '../mastodon/ready';

ready(() => {
  let form = document.createElement('form');
  form.action = sso_redirect;
  form.method = 'post';
  if (localStorage.getItem('mozsoc.auth_intent') === 'signup') {
    let input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'intent';
    input.value = 'signup';
    form.append(input);
  }
  localStorage.removeItem('mozsoc.auth_intent');
  document.body.append(form);
  form.submit();
});
