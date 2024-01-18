import { uniqueId } from '@ember/helper';
import Service from '@ember/service';

import { TrackedMap, TrackedObject } from 'tracked-built-ins';
// ember reacts to changes in these objects

function loadTodos() {
	// localStorage has to be an array (required by the todomvc repo),
	// so let's convert to an object on id.
	// local sotrage needs string
	let list = JSON.parse(window.localStorage.getItem('todos') || '[]');

	return list.reduce((indexed, todo) => {
		indexed.set(todo.id, new TrackedObject(todo));

		return indexed;
	}, new TrackedMap());
}

function save(indexedData) {
	let data = [...indexedData.values()];

	window.localStorage.setItem('todos', JSON.stringify(data));
}

export default class Repo extends Service {
	/**
	 * @type {Map<string, {
	 *   id: number,
	 *   title: string,
	 * 	 assignee: string,
	 *   completed: boolean,
	 * }>}
	 */
	data = null;

	load = () => {
		this.data = loadTodos();
	};

	get sort() {
		return this.all.sort((a, b) => a.title.localeCompare(b.title));
	}

	get sortCompleted() {
		return this.all.sort((a) => (a.completed ? 1 : -1));
	}

	get all() {
		return [...this.data.values()];
	}

	get completed() {
		return this.all.filter((todo) => todo.completed);
	}

	get active() {
		return this.all.filter((todo) => !todo.completed);
	}

	get remaining() {
		// This is an alias
		return this.active;
	}

	addRandom = () => {
		const randomTodo = (Math.random() + 1).toString(36).substring(7);

		this.add({ title: randomTodo, completed: false });
	};

	clearCompleted = () => {
		this.completed.forEach(this.delete);
	};

	clearAll = () => {
		this.all.forEach(this.delete);
	};

	add = (attrs) => {
		let newId = uniqueId();

		this.data.set(newId, new TrackedObject({ ...attrs, id: newId }));
		this.persist();
	};

	delete = (todo) => {
		this.data.delete(todo.id);
		this.persist();
	};

	persist = () => {
		save(this.data);
	};
}
