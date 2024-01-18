import { service } from 'ember-primitives/helpers';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

import Create from './create';
import Footer from './footer';

function hasTodos(todos) {
	return todos.length > 0;
}

export default class Layout extends Component{

	@tracked colorToggle = false
	toggleColor = (event) => {
		this.colorToggle = !this.colorToggle
		event.target.style.color = this.colorToggle ? 'red' : 'green'
	}

	<template>
		<section class="todoapp">
			<header class="header">
				<h1 
					{{on 'click' this.toggleColor}}
				>
				{{#if this.colorToggle}}
					todos
				{{else}} 
					MV Sport (click)
				{{/if}}

				</h1>

				<Create />
			</header>

			{{yield}}

			{{#let (service "repo") as |repo|}}
				{{#if (hasTodos repo.all)}}
					<Footer />
				{{/if}}
			{{/let}}
		</section>
	</template>
}

