document.addEventListener('DOMContentLoaded', () => {
  const contactManager = (() => {
    
    function find(selector) {
      return document.querySelector(selector);
    }
    
    const SELECTORS = {
      search: '.search',
      addSearch: '.add-search-container',
      noContacts: '.empty-contacts',
      contactsDiv: '.all-contacts'
    };
    
    const DANGER_CHARS_ENCODING = {
      '&': '&amp',
      '>': '&lt',
      '<': '&gt',
      '"': '&quot',
      "'": '&#x27',
    };
    
    const FORM_INPUT_REGEX = {
     'fullname': ['[A-Za-z]{1,}', 'Fullname must have >= 1 alphabetical character'],
     'email': ['[A-Za-z]{1,}@[A-Za-z]{1,}\.[A-Za-z]{2,}', 
               "Ensure there's a leading name, an @, and an extension in the email"],
     'phone_number': ['[0-9]{3}-[0-9]{3}-[0-9]{4}',
                      "Phone number should have 10 digits & appropriate hyphens (ex: 222-222-2222)"]
    };

    const addContactProps = {
      id: 'add-contact-form',
      title: 'Create Contact',
      fullname: '',
      email: '',
      phone_number: '',
      sales: '',
      marketing: '',
      engineering: '',
      hr: '',
      accounting: '',
      admin: '',
      cs: ''
    };
    
    const VALID_IDS = Object.keys(FORM_INPUT_REGEX).concat("tag");
    const editForm = Object.assign({}, addContactProps);
    editForm.title = 'Edit Contact';
    editForm.id = 'edit-contact-form';
    
    const TEMPLATES = {
      form: Handlebars.compile(find('#contact-form-template').innerHTML),
      contacts: Handlebars.compile(find("#contacts-template").innerHTML)
    };
    
    let contactId = 0;
    function generateContactId() {
      return contactId += 1;
    }
  
    return {
      arrify: function(collection) {
        return Array.prototype.slice.call(collection);
      },
  
      addClass: function(...classSelectors) {
        const cssClass = classSelectors[0];
        classSelectors.slice(1).forEach(selector => {
          find(selector).classList.add(cssClass);
        });
      },
      
      removeClass: function(...classSelectors) {
        const cssClass = classSelectors[0];
        classSelectors.slice(1).forEach(selector => {
          const el = find(selector);
          if (el.classList.contains(cssClass)) {
            el.classList.remove(cssClass);
          }
        });
      },
  
      addHTMLForm: function(formObject) {
        let html = TEMPLATES.form(formObject);
        let parent = find('.main-container');
        parent.innerHTML += html;
      },

      init: function() {
        this.addHTMLForm(addContactProps);
        SELECTORS.addForm = '#add-contact-form';
        this.allContacts = [];
        this.bindEvents();
      },
    
      createContact: function(form) {
        const contact = { id: generateContactId() };
        return this.editContactObject(contact, form);
      },
      
      editContactObject: function(contact, form) {
        const self = this;
        self.arrify(form).forEach(element => {
          if (VALID_IDS.includes(element.id)) {
            contact[element.name] = self.encodeDangerChars(element.value);
          }
        });
        
        return contact;
      },
      
      editContacts: function(target) {
        const id = document.querySelectorAll("input[name='contactId']")[1].value;
        this.allContacts.forEach((contact, idx, arr) => {
          if (String(contact.id) === id) {
            arr[idx] = this.editContactObject(contact, target.form);
          }
        });
            
        target.form.remove();
      },
      
      encodeDangerChars: function(string) {
        return string.split('').map(char => {
          if (Object.keys(DANGER_CHARS_ENCODING).includes(char)) {
            return DANGER_CHARS_ENCODING[char];
          } else {
            return char;
          }
        }).join('');
      },
      
      validContactInput: function(form) {
        let allValid = true;

        this.arrify(form.querySelectorAll('input')).forEach(el => {
          let regex_error_msg = FORM_INPUT_REGEX[el.id];
          
          if (regex_error_msg) {
            if (!el.value.match(regex_error_msg[0])) {
              alert(regex_error_msg[1]);
              allValid = false;
            }
          }
        });
        
        return allValid;
      },

      anchorContactId: function(match, url) {
        return url.substr(match.index, url.length).split('').filter(char => {
          return char.match('[0-9]');
        }).join();
      },

      formIds: function() {
        return this.arrify(document.querySelectorAll('form')).map(el => '#' + el.id);
      },
      
      addContactsHTML: function() {
        const self = this;
        find(SELECTORS.contactsDiv).remove();
        let htmlData = TEMPLATES.contacts({ contacts: self.allContacts });
        let contactsContainer = find('.contacts-container');
        contactsContainer.innerHTML += htmlData;
      },

      deleteContact: function(deleteHref, target) {
        const confirmed = confirm("Are you sure you want to delete this contact?");
        if (confirmed) {
          const id = Number(this.anchorContactId(deleteHref, target.href));
          this.allContacts = this.allContacts.filter(contact => contact.id !== id);
          target.parentNode.parentNode.remove();
                
          if (this.allContacts.length === 0) {
            this.removeClass('hide', SELECTORS.noContacts);
          }
        }
      },
      
      updateDisplayToCancel: function() {
        const unHideEls = [SELECTORS.addSearch, SELECTORS.contactsDiv];
        if (this.allContacts.length === 0) { 
          unHideEls.push(SELECTORS.noContacts); 
        }
        const formForEditing = find('#' + editForm.id);
        if (formForEditing) {
          formForEditing.remove();
        }
        
        this.addClass('hide', ...this.formIds());
        this.removeClass('hide', ...unHideEls);
      },
      
      displayAddForm: function() {
        this.addClass('hide', SELECTORS.addSearch, SELECTORS.noContacts, SELECTORS.contactsDiv);
        this.removeClass('hide', SELECTORS.addForm);
      },
      
      displayEditForm: function(editHref, target) {
        this.addClass('hide', SELECTORS.addSearch, SELECTORS.contactsDiv);
        const id = Number(this.anchorContactId(editHref, target.href));
        const contact = this.allContacts.filter(contact => contact.id === id)[0];
              
        const selectedTags = Object.keys(editForm).filter(key => {
          key.match('(sales|marketing|engineering|hr|accounting|admin|cs)');
        });
        selectedTags.forEach(tag => editForm[tag] = '');

        VALID_IDS.forEach(property => {
          if (property !== 'tag') {
            editForm[property] = "placeholder='" + contact[property] + "'";
          } else {
            editForm[contact[property]] = "selected";
          }
        });
              
        editForm["idValue"] = `value='${id}'`;
        this.addHTMLForm(editForm);
        this.removeClass('hide', '#edit-contact-form');
      },
      
      submitForm: function(target) {
        if (this.validContactInput(target.closest('form'))){
          if (target.form.id === 'add-contact-form') {
            this.allContacts.push(this.createContact(find(SELECTORS.addForm)));
            this.addClass('hide', SELECTORS.addForm);
          } else {
            this.editContacts(target);
          }
            
          this.addContactsHTML();
          this.removeClass('hide', SELECTORS.addSearch);
        }
      },
      
      editOrDeleteContact: function(target) {
        const deleteHref = target.href.match('delete/');
        const editHref = target.href.match('edit/');
            
        if (deleteHref) { 
          this.deleteContact(deleteHref, target);
        } else if (editHref) {
          this.displayEditForm(editHref, target);
        }
      },
      
      processClick: function(target) {
        if (target.className.match('add-contact')) {
          this.displayAddForm();

        } else if (target.nodeName === 'A') {
          this.editOrDeleteContact(target);
              
        } else if (target.innerHTML.match('Submit')) {
          this.submitForm(target);
            
        } else if (target.innerHTML.match('Cancel')) {
          this.updateDisplayToCancel();
        }
      },
  
      bindEvents: function() {
        const self = this;
        document.addEventListener('click', event => {
          event.preventDefault();
          self.processClick(event.target);
        });
      }
    };
  })();

  contactManager.init();
});
