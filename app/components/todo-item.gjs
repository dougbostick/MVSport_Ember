import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import { isBlank } from '@ember/utils';

export default class TodoItem extends Component {
  <template>
    <li class="{{if @todo.completed 'completed'}} {{if this.editing 'editing'}}">
      <div class="view">
        <input
          class="toggle"
          type="checkbox"
          aria-label="Toggle the completion state of this todo"
          checked={{@todo.completed}}
          {{on 'change' this.toggleCompleted}}
        >
        <label {{on 'dblclick' this.startEditing}}>Task: {{@todo.title}}</label>
        <label {{on 'dblclick' this.startEditing}}>Assignee: {{@todo.assignee}}</label>

        <button
          class="destroy"
          {{on 'click' this.removeTodo}}
          type="button"
          aria-label="Delete this todo"></button>
      </div>
      <form {{on 'submit' this.doneEditing}}>
        <input
          class="edit"
          value={{@todo.title}}
          {{on 'keydown' this.handleKeydown}}
          autofocus
        >
        <input
          class="edit"
          value={{@todo.assignee}}
          {{on 'keydown' this.handleKeydown}}
          autofocus
        >
        {{#if this.editing}}
        <input type='submit' value='done editing'>
        {{/if}}
      </form>
    </li>
  </template>

  @service repo;
  @tracked editing;

  removeTodo = () => this.repo.delete(this.args.todo);

  toggleCompleted = (event) => {
      this.args.todo.completed = event.target.checked;
			this.repo.persist();
  }

  handleKeydown = (event) => {
    if (event.keyCode === 13) {
      event.target.blur();
    } else if (event.keyCode === 27) {
      this.editing = false;
    }
  }

  startEditing = (event) => {
    this.args.onStartEdit();
    this.editing = true;

    event.target.closest('li')?.querySelector('input.edit').focus();
  }

  doneEditing = (event) => {
			if (!this.editing) { return; }
      event.preventDefault()
      let todoTitle = event.target[0].value.trim();
      let todoAssignee = event.target[1].value.trim();

			if (isBlank(todoTitle)) {
        this.removeTodo();
			} else {
        this.args.todo.title = todoTitle;
        this.args.todo.assignee = todoAssignee
        this.editing = false;
				this.args.onEndEdit();
			}
  }

}
