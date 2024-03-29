import EmberRouter from '@ember/routing/router';

import config from 'todomvc/config/environment';

export default class Router extends EmberRouter {
	location = config.locationType;
	rootURL = config.rootURL;
}

Router.map(function () {
	this.route('active');
	this.route('completed');
	this.route('sort');
	this.route('clear');
	this.route('sort_completed');
});
