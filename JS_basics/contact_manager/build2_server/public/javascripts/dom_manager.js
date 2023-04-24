const DomManager = {
  
  allContacts: [], 

  find(selector) {
    return document.querySelector(selector);
  },
  
  findAll(selector) {
    let items = document.querySelectorAll(selector);
    return this.arrify(items);
  },
  
  findContact(contactData) {
    return this.allContacts.filter(contact => {
      return contact.id === contactData.id;
    })[0];
  },
  
  arrify(collection) {
    return Array.prototype.slice.call(collection);
  },
  
  template(id) {
    return Handlebars.compile(this.find(id).innerHTML);
  },
  
  renderHandlebarsHTML(id, data) {
    let renderAsHTML = this.template(id);
    return renderAsHTML(data);
  },
  
  anchorContactId(match, url) {
    return url.substr(match.index, url.length).split('').filter(char => {
      return char.match('[0-9]');
    }).join('');
  },

  addClass(...classSelectors) {
    const cssClass = classSelectors[0];
    classSelectors.slice(1).forEach(selector => {
      this.find(selector).classList.add(cssClass);
    });
  },
      
  removeClass(...classSelectors) {
    const cssClass = classSelectors[0];
    classSelectors.slice(1).forEach(selector => {
      const el = this.find(selector);
      if (el.classList.contains(cssClass)) {
        el.classList.remove(cssClass);
      }
    });
  },
  
  hidden(element) {
    return element.classList.contains('hide');
  },
  
  filterUls(criteria) {
    return this.findAll('ul').filter(criteria);
  },
  
  doesNotMatchTag(element) {
    return !element.innerText.match(this.filterTagHTML.toLowerCase());
  },
  
  addUlIdstoArr(uls, arr) {
    uls.forEach(ul => {
      arr.push('#' + ul.id);
    });
    
    return arr;
  },
  
  removeFilter(html) {
    const ulIds = this.filterUls(this.hidden);

    if (html.match('Tag')) {
      this.addClass('hide', '.reset-tag-filters');
    } else {
      this.addClass('hide', '.search-filter-removal');
      this.find('.search').value = '';
      const noMatchesDiv = this.find('.empty-search-contacts');
      if (!this.hidden(noMatchesDiv)) {
        this.addClass('hide', '.empty-search-contacts');
      }
    }

    const selectors = this.addUlIdstoArr(ulIds, ['.tag-filters', '.search']);
    this.removeClass('hide', ...selectors);
  },
  
  showTaggedContacts(html) {
    this.filterTagHTML = html;
    const ulIds = this.filterUls(this.doesNotMatchTag.bind(this));
    const selectors = this.addUlIdstoArr(ulIds, ['.tag-filters', '.search']);

    this.addClass('hide', ...selectors);
    this.removeClass('hide', '.reset-tag-filters');
    this.find('strong').innerHTML = html;
  },
  
  removeContactLocally(id, fullRemovalFlag) {
    this.find(`[href*="${id}"]`).closest('ul').remove();
    if (fullRemovalFlag) {
      return this.allContacts.filter(contact => contact.id !== id);
    }
  },
  
  addHTMLForm(formData) {
    let html = this.renderHandlebarsHTML('#contact-form-template', formData);
    const parent = this.find('.main-container');
    parent.innerHTML += html;
  },
  
  addContact(contactData) {
    this.allContacts.push(contactData);
    this.insertContactHTML(contactData);
  },
  
  doesNotMatchSearch(element) {
    let contactName = element.querySelector('strong').innerText;
    return !contactName.match(`^${this.find('.search').value}`);
  },
  
  numMatches(searchVal) {
    return this.allContacts.filter(obj => {
      const regex = `^${searchVal}`;
      return obj.full_name.match(regex);
    }).length;
  },
  
  showSearchMatches() {
    const ulIds = this.filterUls(this.doesNotMatchSearch.bind(this));
    this.addClass('hide', ...this.addUlIdstoArr(ulIds, ['.tag-filters']));
    const searchVal = this.find('.search').value;
    const unhideSelectors = ['.search-filter-removal'];

    if (this.numMatches(searchVal) === 0) {
      const searchHTML = this.find('.empty-search-contacts').querySelector('strong');
      searchHTML.innerText = searchVal;
      unhideSelectors.push('.empty-search-contacts');
    }
    
    this.removeClass('hide', ...unhideSelectors);
  },
  
  editContact(newContactData) {
    for (let i = 0; i < this.allContacts.length; i += 1) {
      let contact = this.allContacts[i];
      if (contact.id === newContactData.id) {
        Object.keys(contact).forEach(key => {
          contact[key] = newContactData[key];
        });
        break;
      }
    }

    this.removeContactLocally(newContactData.id, false);
    this.insertContactHTML(newContactData);
  },
  
  insertContactHTML(contactData) {
    const contacts = { contacts: [contactData] };
    const html = this.renderHandlebarsHTML('#contacts-template', contacts);
    let contactsContainer = this.find('.all-contacts');
    contactsContainer.innerHTML += html;
  },
  
  removeEditForm() {
    const formForEditing = this.find('#edit-contact-form');
    if (formForEditing) {
      formForEditing.remove();
    }
  },
  
  updateDisplayToCancel() {
    const unHideEls = ['.add-search-container', '.all-contacts'];
    if (this.allContacts.length === 0) { 
      unHideEls.push('.empty-contacts'); 
    }
    
    this.removeEditForm();
    this.addClass('hide', '#add-contact-form');
    this.removeClass('hide', ...unHideEls);
  },
  
  displayAddForm() {
    this.addClass('hide', '.add-search-container',  '.empty-contacts', '.all-contacts');
    this.removeClass('hide', '#add-contact-form');
  },
  
  addEditDisplayUpdate(data, formId) {
    if (formId.match('add')) {
      this.addContact(data);
      this.addClass('hide', formId);
    } else {
      this.editContact(data);
      this.removeEditForm();
    }
    this.removeClass('hide', '.add-search-container', '.all-contacts');
  },
  
  prepFormValue(val, id) {
    if (id === "id") {
      return Number(val);
    } else {
      return val;
    }
  },
  
  proposedContact(formId) {
    const form = this.find(formId);
    const contact = {};
    const desiredProps = ["full_name", "email", "phone_number", "tags"];
    formId.match('edit') ? desiredProps.push('id') : 'do nothing';
    
    this.arrify(form).forEach(element => {
      if (desiredProps.includes(element.id)) {
        if (element.value === '' && formId.match('edit')) {
          const newVal = element.getAttribute('placeholder');
          contact[element.name] = this.prepFormValue(newVal, element.id);
        } else {
          contact[element.name] = this.prepFormValue(element.value, element.id);
        }
      }
    });
    
    return contact;
  },
  
  editOrDeleteContact(target, xhrRequest) {
    const deleteHref = target.href.match('delete/');
    const editHref = target.href.match('edit/');
            
    if (deleteHref) { 
      this.deleteContact(deleteHref, target, xhrRequest);
    } else if (editHref) {
      this.displayEditForm(editHref, target);
    }
  },
  
  deleteContact(deleteHref, target, xhrRequest) {
    const confirmed = confirm("Are you sure you want to delete this contact?");
    if (confirmed) {
      const id = Number(this.anchorContactId(deleteHref, target.href));
      xhrRequest.deleteContact(id);
      this.allContacts = this.removeContactLocally(id, true);
                
        if (this.allContacts.length === 0) {
          this.removeClass('hide', '.empty-contacts');
        }
      }
    },
    
  fillInCurrentTags(selectedTags, editForm) {
    selectedTags.split(', ').forEach(tag => {
      editForm[tag] = 'selected';
    });
  },
      
  displayEditForm(editHref, target) {
    this.addClass('hide', '.add-search-container', '.all-contacts');
    const id = Number(this.anchorContactId(editHref, target.href));
    const contact = this.allContacts.filter(contact => contact.id === id)[0];
    
    let attributes = Object.keys(contact).filter(key => key !== 'id');
    attributes.forEach(property => {
      this.editForm[property] = "placeholder='" + contact[property] + "'";
    });
              
    this.editForm["idValue"] = `value='${id}'`;
    this.addHTMLForm(this.editForm);
    this.removeClass('hide', '#edit-contact-form');
  },
      
  submitForm(target, xhr, Contact) {
    const self = this;
    const addFormFlag = target.form.innerHTML.match('Create');
    let formId = '-contact-form'; 
    formId = (addFormFlag ? '#add' : '#edit') + formId;

    let contact = Object.create(Contact).init(this.proposedContact(formId));
    if (Array.isArray(contact)) {
      contact.forEach(errorMsg => alert(errorMsg));
    } else {
      if (formId === '#add-contact-form') {
        xhr.saveContact(contact).then(function(contact) {
          self.addEditDisplayUpdate(contact, formId);
        });
      } else {
        xhr.updateContact(contact, contact.id).then(function(contact) {
          self.addEditDisplayUpdate(contact, formId);
        });
      }
    }
  },
};

export function domManager()  {
  return DomManager;
}
