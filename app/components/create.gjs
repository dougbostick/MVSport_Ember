import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import { isBlank } from '@ember/utils';

export default class Create extends Component {
  @tracked newTodo = {task: '', assignee: ''}

  <template>
    <form {{on 'submit' this.createTodo}}>
      <input
        class="new-todo"
        aria-label="What needs to be done?"
        placeholder="What needs to be done?"
        autofocus
      >
      <input
        class="new-todo"
        aria-label="Who needs to do it?"
        placeholder="Who needs to do it?"
        autofocus
      >
      <input type="submit" value="Add Todo" style="display:none">
    </form>
  </template>

  @service repo;

  createTodo = (event) => {
    event.preventDefault()
    let { target } = event
    let task = target[0].value
    let assignee = target[1].value
    if(!isBlank(task) && !isBlank(assignee)){
      this.repo.add({title: task, assignee: assignee, completed: false})
      target[0].value = ''
      target[1].value = '' 
     }
    
  };
}
