import { contactCreator } from './contact.js';
import { domManager } from './dom_manager.js';
import { requestManager } from './request_manager.js';
import { createForm } from './form.js';

const ContactManager = (() => {
  const dom = domManager();
  const Contact = contactCreator();
  const requester = requestManager();
   
  return {
    init() {
      dom.addHTMLForm(createForm('add-contact-form', 'Create Contact'));
      dom.editForm = createForm('edit-contact-form', 'Edit Contact');
      this.bindEvents();
    },
    
    processClick(target) {
      const html = target.innerHTML;
      const type = target.nodeName;

      if (target.className.match('add-contact')) {
        dom.displayAddForm();
      } else if (type === 'A') {
        dom.editOrDeleteContact(target, requester);
      } else if (html.match('Submit')) {
        dom.submitForm(target, requester, Contact);
      } else if (html.match('Cancel')) {
        dom.updateDisplayToCancel();
      } else if (html.toLowerCase().match(Contact.tagsRegex()) && type === 'BUTTON') {
        dom.showTaggedContacts(target.innerHTML);
      } else if (html.match('Remove Tag Filter|Remove Name Search Filter')) {
        dom.removeFilter(html);
      }
    },

    bindEvents() {
      const self = this;
      document.addEventListener('click', event => {
        event.preventDefault();
        self.processClick(event.target);
      });
      
      dom.find('.search').addEventListener('keyup', event => {
        dom.showSearchMatches();
      });
    }
  };
})();

document.addEventListener('DOMContentLoaded', () => {
  ContactManager.init();
});