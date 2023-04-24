const RequestManager = (() => {
  function successStatus(code) {
    const successCodes = [...Array(205).keys()].slice(200);
    return successCodes.includes(code);
  }
  
  function sendRequest(request, requestData) {
    if (requestData) {
      request.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
      let json = JSON.stringify(requestData);
      request.send(json);
    } else {
      request.send();
    }
  }
  
  function prepResponse(jsonFlag, response) {
    return jsonFlag ? JSON.parse(response) : response;
  }

  function makeRequest(httpMethod, jsonFlag, id=null, data=null) {
    return new Promise(function(resolve, reject) {
      let request = new XMLHttpRequest();
      request.open(httpMethod, createUrl(id));
      
      request.addEventListener('load', () => {
        if (successStatus(request.status)) {
          resolve(prepResponse(jsonFlag, request.response));
        } else {
          reject(Error("Bad Request"));
        }
      });
      
      sendRequest(request, data);
    });
  }
  
  function createUrl(id=null) {
    const BASE_URL = 'http://localhost:3000/api/contacts';
    return id ? BASE_URL + '/' + id : BASE_URL;
  }
  
  return {
    getContacts() {
      return makeRequest('GET', true);
    },
  
    getContact(id) {
      return makeRequest('GET', true, id);
    },
  
    deleteContact(id) {
      return makeRequest('DELETE', false, id);
    },
  
    saveContact(data) {
      return makeRequest('POST', true, null, data);
    },
  
    updateContact(data, id) {
      return makeRequest('PUT', true, id, data);
    }
  };

})();

export function requestManager()  {
  return RequestManager;
}